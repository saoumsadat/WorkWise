const express = require("express");
const router = express.Router();
const db = require("../db");

/* =====================================================
   ADMIN → PROFILE
   GET /api/admins/:adminId
===================================================== */
router.get("/:adminId", async (req, res) => {
    const { adminId } = req.params;

    try {
        const [rows] = await db.query(
            `
            SELECT
                u.user_id,
                u.name,
                u.email,
                uni.name AS university_name
            FROM User u
            JOIN University_Admin ua
                ON u.user_id = ua.user_id
            JOIN University uni
                ON ua.university_id = uni.university_id
            WHERE u.user_id = ?
            `,
            [adminId]
        );

        if (rows.length === 0) {
            return res.status(404).json({ error: "Admin not found" });
        }

        res.json(rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});


/* =====================================================
   ADMIN → ALL JOBS (WITH ASSIGNMENT ORIGIN)
   GET /api/admins/:adminId/jobs
===================================================== */
router.get("/:adminId/jobs", async (req, res) => {
    const { adminId } = req.params;

    try {
        const [rows] = await db.query(
            `
            SELECT
                j.job_id,
                j.job_title,
                j.social_contribution_points,
                j.admin_id AS assigned_admin_id,
                au.university_id AS assigned_university_id,
                u2.name AS assigned_university_name,
                my_ua.university_id AS my_university_id
            FROM Job j

            -- who assigned the value (if any)
            LEFT JOIN University_Admin au
                ON j.admin_id = au.user_id
            LEFT JOIN University u2
                ON au.university_id = u2.university_id

            -- current admin's university
            JOIN University_Admin my_ua
                ON my_ua.user_id = ?

            ORDER BY j.job_id DESC
            `,
            [adminId]
        );

        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;

/* =====================================================
   ADMIN → ASSIGN / RE-EVALUATE SOCIAL POINTS
   POST /api/admins/jobs/:jobId/assign-points
===================================================== */
router.post("/jobs/:jobId/assign-points", async (req, res) => {
    const { jobId } = req.params;
    const { admin_id, points } = req.body;

    if (!admin_id || points === undefined) {
        return res.status(400).json({
            error: "admin_id and points are required"
        });
    }

    try {
        await db.query(
            `
            UPDATE Job
            SET
                social_contribution_points = ?,
                admin_id = ?
            WHERE job_id = ?
            `,
            [points, admin_id, jobId]
        );

        res.json({ message: "Social contribution points updated" });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});