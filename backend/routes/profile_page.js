// routes/profile.js
// npm install multer
const express = require('express');
const router  = express.Router();
const multer  = require('multer');
const path    = require('path');
const fs      = require('fs');
const db      = require('../db');

// ─────────────────────────────────────────────
// MULTER setup
// ✅ แก้: ลบ duplicate destination ออก (bug เดิม)
// ─────────────────────────────────────────────
const uploadDir = path.join(__dirname, '..', 'uploads', 'profiles');
if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir, { recursive: true });

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, uploadDir),  // ✅ มีแค่อันเดียว
  filename:    (req, file, cb) => {
    const ext = path.extname(file.originalname) || '.jpg';
    cb(null, `user_${req.params.id}_${Date.now()}${ext}`);
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 5 * 1024 * 1024 }, // 5 MB
  fileFilter: (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) cb(null, true);
    else cb(new Error('อนุญาตเฉพาะไฟล์รูปภาพเท่านั้น'));
  },
});

// ─── helpers ──────────────────────────────────
function parseSkills(raw) {
  if (!raw) return [];
  try {
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : [String(parsed)];
  } catch {
    return raw.split(',').map(s => s.trim()).filter(Boolean);
  }
}

function formatUser(u) {
  return {
    id:                Number(u.id),
    full_name:         u.full_name         ?? '',
    email:             u.email             ?? '',
    phone:             u.phone             ?? null,
    bio:               u.bio               ?? null,
    job_title:         u.job_title         ?? null,
    skills:            parseSkills(u.skills),
    profile_image_url: u.profile_image_url ?? null,
    rating:            Number(u.rating)    || 0,
    total_jobs:        Number(u.total_jobs)|| 0,
    is_verified:       u.is_verified === 1 ? 1 : 0,
  };
}

// ─────────────────────────────────────────────
// GET /api/users/:id/profile
// ─────────────────────────────────────────────
router.get('/users/:id/profile', async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT id, full_name, email, phone, bio,
              job_title, skills, profile_image_url,
              rating, total_jobs, is_verified
       FROM users WHERE id = ?`,
      [req.params.id]
    );
    if (!rows.length) return res.status(404).json({ message: 'ไม่พบผู้ใช้' });
    res.json(formatUser(rows[0]));
  } catch (err) {
    console.error('GET /profile error:', err);
    res.status(500).json({ message: err.message });
  }
});

// ─────────────────────────────────────────────
// PUT /api/users/:id/profile  (multipart/form-data)
// ✅ multer middleware อยู่ตรงนี้ ไม่ใช่ใน storage
// ─────────────────────────────────────────────
router.put('/users/:id/profile', upload.single('profile_image'), async (req, res) => {
  try {
    const { full_name, email, phone, bio, job_title, skills } = req.body;

    // skills: Flutter ส่ง JSON array string → เก็บเป็น comma-string ใน DB
    let skillsStr = null;
    if (skills !== undefined) {
      try {
        const arr = JSON.parse(skills);
        skillsStr = Array.isArray(arr) ? arr.join(',') : String(skills);
      } catch {
        skillsStr = String(skills);
      }
    }

    // ✅ ถ้า upload รูปมา สร้าง URL — ใช้ req.protocol + host หรือ hardcode
    let profileImageUrl = undefined;
    if (req.file) {
      // ปรับ URL ตาม production จริง
      const host = `${req.protocol}://${req.get('host')}`;
      profileImageUrl = `${host}/uploads/profiles/${req.file.filename}`;
    }

    // Build dynamic SET clause
    const sets   = [];
    const params = [];

    if (full_name       !== undefined) { sets.push('full_name = ?');         params.push(full_name); }
    if (email           !== undefined) { sets.push('email = ?');             params.push(email); }
    if (phone           !== undefined) { sets.push('phone = ?');             params.push(phone || null); }
    if (bio             !== undefined) { sets.push('bio = ?');               params.push(bio || null); }
    if (job_title       !== undefined) { sets.push('job_title = ?');         params.push(job_title || null); }
    if (skillsStr       !== null)      { sets.push('skills = ?');            params.push(skillsStr); }
    if (profileImageUrl !== undefined) { sets.push('profile_image_url = ?'); params.push(profileImageUrl); }

    // ✅ ถ้าไม่มีอะไรให้ update เลย ก็ไม่ต้อง query
    if (sets.length > 0) {
      sets.push('updated_at = NOW()');
      params.push(req.params.id);
      await db.query(`UPDATE users SET ${sets.join(', ')} WHERE id = ?`, params);
    }

    // Return updated profile
    const [rows] = await db.query(
      `SELECT id, full_name, email, phone, bio,
              job_title, skills, profile_image_url,
              rating, total_jobs, is_verified
       FROM users WHERE id = ?`,
      [req.params.id]
    );
    res.json(formatUser(rows[0]));
  } catch (err) {
    console.error('PUT /profile error:', err);
    res.status(500).json({ message: err.message });
  }
});

// ─────────────────────────────────────────────
// GET /api/users/:id/portfolios
// ─────────────────────────────────────────────
router.get('/users/:id/portfolios', async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT id, user_id, user_name, description, tags, image_url, verify_status
       FROM portfolios
       WHERE user_id = ?
       ORDER BY id DESC`,
      [req.params.id]
    );
    res.json(rows);
  } catch (err) {
    console.error('GET /portfolios error:', err);
    res.status(500).json({ message: err.message });
  }
});

// ─────────────────────────────────────────────
// GET /api/users/:id/earnings
// ─────────────────────────────────────────────
router.get('/users/:id/earnings', async (req, res) => {
  try {
    const userId = req.params.id;

    const [[monthRow]] = await db.query(
      `SELECT COALESCE(SUM(amount), 0) AS total_month
       FROM earnings
       WHERE user_id = ?
         AND MONTH(created_at) = MONTH(CURRENT_DATE())
         AND YEAR(created_at)  = YEAR(CURRENT_DATE())`,
      [userId]
    );

    const [[prevRow]] = await db.query(
      `SELECT COALESCE(SUM(amount), 0) AS previous_month
       FROM earnings
       WHERE user_id = ?
         AND MONTH(created_at) = MONTH(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH))
         AND YEAR(created_at)  = YEAR(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH))`,
      [userId]
    );

    const [[balanceRow]] = await db.query(
      `SELECT COALESCE(SUM(amount), 0) AS available_balance
       FROM earnings
       WHERE user_id = ? AND status = 'paid'`,
      [userId]
    );

    const [recentItems] = await db.query(
      `SELECT id, user_id, amount, title, description, work_date, status
       FROM earnings
       WHERE user_id = ?
       ORDER BY created_at DESC
       LIMIT 10`,
      [userId]
    );

    res.json({
      total_month:       Number(monthRow.total_month)        || 0,
      previous_month:    Number(prevRow.previous_month)      || 0,
      available_balance: Number(balanceRow.available_balance)|| 0,
      recent_items:      recentItems,
    });
  } catch (err) {
    console.error('GET /earnings error:', err);
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;