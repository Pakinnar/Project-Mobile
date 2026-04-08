const express = require('express');
const pool = require('../db');
const router = express.Router();

// ดึงข้อมูลตรวจสอบทั้งหมด
router.get('/', async (req, res) => {
  try {
    const { type = 'users' } = req.query;

    if (type === 'users') {
      const [rows] = await pool.query(`
        SELECT
          id,
          full_name AS name,
          email,
          created_at,
          id_number,
          verify_status
        FROM users
        WHERE role = 'user'
        ORDER BY created_at DESC
      `);

      const data = rows.map((item) => ({
        id: item.id.toString(),
        badge: item.verify_status.toUpperCase(),
        timeAgo: item.created_at,
        name: item.name,
        description: 'การตรวจสอบตัวตน (ID Verification)',
        idNumber: item.id_number,
        location: null,
        salary: null,
        tags: [],
        imageUrl: null,
        type: 'person',
        status: item.verify_status,
      }));

      return res.json(data);
    }

    if (type === 'portfolios') {
      const [rows] = await pool.query(`
        SELECT *
        FROM portfolios
        ORDER BY created_at DESC
      `);

      const data = rows.map((item) => ({
        id: item.id.toString(),
        badge: item.verify_status.toUpperCase(),
        timeAgo: item.created_at,
        name: item.user_name,
        description: item.description,
        idNumber: null,
        location: null,
        salary: null,
        tags: item.tags ? item.tags.split(',') : [],
        imageUrl: item.image_url,
        type: 'portfolio',
        status: item.verify_status,
      }));

      return res.json(data);
    }

    if (type === 'jobs') {
      const [rows] = await pool.query(`
        SELECT *
        FROM verify_jobs
        ORDER BY created_at DESC
      `);

      const data = rows.map((item) => ({
        id: item.id.toString(),
        badge: item.verify_status.toUpperCase(),
        timeAgo: item.created_at,
        name: item.company_name,
        description: item.description,
        idNumber: null,
        location: item.location,
        salary: item.salary,
        tags: [],
        imageUrl: item.image_url,
        type: 'company',
        status: item.verify_status,
      }));

      return res.json(data);
    }

    return res.status(400).json({ message: 'type ไม่ถูกต้อง' });
  } catch (error) {
    console.error('Verify list error:', error);
    res.status(500).json({ message: error.message });
  }
});

// อนุมัติ/ปฏิเสธ
router.patch('/:type/:id/status', async (req, res) => {
  try {
    const { type, id } = req.params;
    const { status } = req.body;

    if (!['approved', 'rejected', 'pending'].includes(status)) {
      return res.status(400).json({ message: 'status ไม่ถูกต้อง' });
    }

    if (type === 'users') {
      await pool.query(
        `UPDATE users SET verify_status = ? WHERE id = ?`,
        [status, id]
      );
    } else if (type === 'portfolios') {
      await pool.query(
        `UPDATE portfolios SET verify_status = ? WHERE id = ?`,
        [status, id]
      );
    } else if (type === 'jobs') {
      await pool.query(
        `UPDATE verify_jobs SET verify_status = ? WHERE id = ?`,
        [status, id]
      );
    } else {
      return res.status(400).json({ message: 'type ไม่ถูกต้อง' });
    }

    res.json({ message: 'อัปเดตสถานะสำเร็จ' });
  } catch (error) {
    console.error('Verify update error:', error);
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;

