
const express = require('express');
const pool = require('../db');
const router = express.Router();

// CREATE announcement
router.post('/', async (req, res) => {
  try {
    const { title, content, target_group, image_url } = req.body;

    if (!title || !content || !target_group) {
      return res.status(400).json({
        message: 'กรุณากรอก title, content และ target_group',
      });
    }

    const [result] = await pool.query(
      `INSERT INTO announcements (title, content, target_group, image_url)
       VALUES (?, ?, ?, ?)`,
      [title, content, target_group, image_url || null]
    );

    res.status(201).json({
      message: 'สร้างประกาศสำเร็จ',
      id: result.insertId,
    });
  } catch (error) {
    console.error('Create announcement error:', error);
    res.status(500).json({
      message: error.message,
    });
  }
});

// GET all announcements
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT * FROM announcements
       ORDER BY created_at DESC`
    );

    res.json(rows);
  } catch (error) {
    console.error('Get announcements error:', error);
    res.status(500).json({
      message: error.message,
    });
  }
});

module.exports = router;

