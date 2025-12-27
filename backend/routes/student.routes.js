const express = require("express");
const router = express.Router();
const db = require("../db");

// GET student profile by user_id
router.get("/:userId", async (req, res) => {
    const { userId } = req.params;

    try {
        const [rows] = await db.query(
            `
            SELECT 
                u.user_id,
                u.name,
                u.email,
                s.student_id,
                s.major
            FROM User u
            JOIN Student s ON u.user_id = s.user_id
            WHERE u.user_id = ?
            `,
            [userId]
        );

        if (rows.length === 0) {
            return res.status(404).json({ message: "Student not found" });
        }

        res.json(rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;


// GET applications for a student (using VIEW)
router.get("/:userId/applications", async (req, res) => {
    const { userId } = req.params;

    try {
        const [rows] = await db.query(
            `
            SELECT
                application_no,
                apply_date,
                status,
                job_title,
                company_name
            FROM v_student_applications
            WHERE student_id = ?
            ORDER BY apply_date DESC
            `,
            [userId]
        );

        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// GET skill profile for a student (using VIEW)
router.get("/:userId/skills", async (req, res) => {
    const { userId } = req.params;

    try {
        const [rows] = await db.query(
            `
            SELECT
                skill_id,
                skill_name,
                skill_description,
                generic_course,
                course_code,
                course_title
            FROM v_student_skill_profile
            WHERE student_id = ?
            ORDER BY skill_name, course_code
            `,
            [userId]
        );

        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// GET current month payment status for student
router.get("/:userId/payments/current", async (req, res) => {
    const { userId } = req.params;

    const now = new Date();
    const month = now.getMonth() + 1; // JS months start at 0
    const year = now.getFullYear();

    try {
        const [rows] = await db.query(
            `
            SELECT
                job_title,
                status,
                amount
            FROM v_student_payment_status
            WHERE student_id = ?
              AND payment_month = ?
              AND payment_year = ?
            `,
            [userId, month, year]
        );

        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// TEMP test route
router.get("/:userId/payments/test", async (req, res) => {
    const { userId } = req.params;

    const [rows] = await db.query(
        `
        SELECT job_title, status, amount
        FROM v_student_payment_status
        WHERE student_id = ?
          AND payment_month = 2
          AND payment_year = 2025
        `,
        [userId]
    );

    res.json(rows);
});

// POST apply or reapply for a job
router.post("/:userId/apply", async (req, res) => {
    const { userId } = req.params;
    const { jobId } = req.body;

    try {
        await db.query(
            "CALL ApplyOrReapplyJob(?, ?)",
            [userId, jobId]
        );

        res.json({ message: "Application submitted successfully" });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
});

// GET available jobs for a student (DB decides availability)
router.get("/:userId/available-jobs", async (req, res) => {
    const { userId } = req.params;

    try {
        const [rows] = await db.query(
            `
            SELECT
                j.job_id,
                j.job_title,
                j.salary,
                j.social_contribution_points
            FROM Job j
            WHERE NOT EXISTS (
                SELECT 1
                FROM Application a
                WHERE a.student_id = ?
                  AND a.job_id = j.job_id
                  AND a.status <> 'Rejected'
            )
            `,
            [userId]
        );

        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});