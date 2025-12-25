const express = require("express");
const router = express.Router();
const db = require("../db");

// GET all jobs
router.get("/", async (req, res) => {
    try {
        const [rows] = await db.query(
            "SELECT job_id, job_title, salary FROM Job"
        );
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;