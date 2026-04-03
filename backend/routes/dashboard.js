const express = require('express');
const pool = require('../db');
const router = express.Router();

// GET /api/dashboard/stats
router.get('/stats', async (req, res) => {
  try {
    // จำนวนผู้ใช้ทั้งหมด
    const [[totalUsers]] = await pool.query(
      `SELECT COUNT(*) as total FROM users`
    );

    // ผู้ใช้ใหม่เดือนนี้
    const [[newUsersThisMonth]] = await pool.query(
      `SELECT COUNT(*) as total FROM users
       WHERE MONTH(created_at) = MONTH(NOW())
       AND YEAR(created_at) = YEAR(NOW())`
    );

    // ผู้ใช้ใหม่เดือนที่แล้ว
    const [[newUsersLastMonth]] = await pool.query(
      `SELECT COUNT(*) as total FROM users
       WHERE MONTH(created_at) = MONTH(DATE_SUB(NOW(), INTERVAL 1 MONTH))
       AND YEAR(created_at) = YEAR(DATE_SUB(NOW(), INTERVAL 1 MONTH))`
    );

    // งานที่เปิดอยู่
    const [[openJobs]] = await pool.query(
      `SELECT COUNT(*) as total FROM jobs WHERE status = 'open'`
    );

    // งานใหม่วันนี้
    const [[newJobsToday]] = await pool.query(
      `SELECT COUNT(*) as total FROM jobs
       WHERE DATE(created_at) = CURDATE()`
    );

    // รายได้รวม
    const [[totalEarnings]] = await pool.query(
      `SELECT IFNULL(SUM(amount), 0) as total FROM earnings`
    );

    // จำนวน transactions
    const [[transactionCount]] = await pool.query(
      `SELECT COUNT(*) as total FROM earnings`
    );

    // คำนวณ % เปลี่ยนแปลง
    const lastMonthCount = newUsersLastMonth.total || 1;
    const growthPercent = Math.round(
      ((newUsersThisMonth.total - lastMonthCount) / lastMonthCount) * 100
    );

    res.json({
      users: {
        total: Number(totalUsers.total).toLocaleString(),
        new_this_month: newUsersThisMonth.total,
        growth_percent: growthPercent,
      },
      jobs: {
        open: openJobs.total,
        new_today: newJobsToday.total,
      },
      earnings: {
        total: Number(totalEarnings.total).toLocaleString(),
        transaction_count: transactionCount.total,
      },
    });
  } catch (error) {
    console.error('Dashboard stats error:', error);
    res.status(500).json({ message: error.message });
  }
});

// GET /api/dashboard/activities
router.get('/activities', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT * FROM activity_logs
       ORDER BY created_at DESC
       LIMIT 10`
    );
    res.json(rows);
  } catch (error) {
    console.error('Activities error:', error);
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
