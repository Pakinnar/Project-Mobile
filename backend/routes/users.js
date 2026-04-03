const express = require('express');
const pool = require('../db');
const router = express.Router();

// ดึง users ทั้งหมด
router.get('/', async (req, res) => {
  try {
    const { search = '', status = 'all' } = req.query;

    let sql = `
      SELECT
        id,
        full_name,
        email,
        created_at,
        status,
        phone,
        rating,
        total_jobs,
        is_verified,
        bio
      FROM users
      WHERE role = 'user'
    `;

    const params = [];

    if (search) {
      sql += ` AND (full_name LIKE ? OR email LIKE ?)`;
      params.push(`%${search}%`, `%${search}%`);
    }

    if (status !== 'all') {
      sql += ` AND status = ?`;
      params.push(status);
    }

    sql += ` ORDER BY created_at DESC`;

    const [rows] = await pool.query(sql, params);

    const formatted = rows.map((user) => ({
      id: user.id.toString(),
      name: user.full_name,
      email: user.email,
      registeredDate: user.created_at,
      status: user.status,
      phone: user.phone,
      rating: user.rating == null ? 0.0 : Number(user.rating),
      totalJobs: user.total_jobs ?? 0,
      isVerified: !!user.is_verified,
      bio: user.bio,
      isOnline: false,
    }));

    res.json(formatted);
  } catch (error) {
    console.error('Get users error:', error);
    res.status(500).json({ message: error.message });
  }
});

// ลบ user
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    await pool.query(`DELETE FROM users WHERE id = ?`, [id]);

    res.json({ message: 'ลบผู้ใช้สำเร็จ' });
  } catch (error) {
    console.error('Delete user error:', error);
    res.status(500).json({ message: error.message });
  }
});

// เปลี่ยนสถานะ user
router.patch('/:id/status', async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    if (!['active', 'pending', 'suspended'].includes(status)) {
      return res.status(400).json({ message: 'status ไม่ถูกต้อง' });
    }

    await pool.query(
      `UPDATE users SET status = ? WHERE id = ?`,
      [status, id]
    );

    res.json({ message: 'อัปเดตสถานะสำเร็จ' });
  } catch (error) {
    console.error('Update user status error:', error);
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;

