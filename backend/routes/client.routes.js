const express = require("express");
const router = express.Router();
const db = require("../db"); // adjust path if needed

/* =====================================================
   CLIENT → PROFILE
   GET /api/clients/:clientId
===================================================== */
router.get("/:clientId", async (req, res) => {
    const { clientId } = req.params;

    try {
        const [rows] = await db.query(
            `
            SELECT
                u.user_id,
                u.name,
                c.company_name,
                c.industry
            FROM User u
            JOIN Client c
                ON u.user_id = c.user_id
            WHERE u.user_id = ?
            `,
            [clientId]
        );

        if (rows.length === 0) {
            return res.status(404).json({ error: "Client not found" });
        }

        res.json(rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

/* =====================================================
   CLIENT → JOBS (jobs posted by this client)
   GET /api/clients/:clientId/jobs
===================================================== */
router.get("/:clientId/jobs", async (req, res) => {
    const { clientId } = req.params;

    try {
        const [rows] = await db.query(
            `
            SELECT
                job_id,
                job_title,
                salary,
                social_contribution_points
            FROM Job
            WHERE client_id = ?
            ORDER BY job_id DESC
            `,
            [clientId]
        );

        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

/* =====================================================
   CLIENT → APPLICATIONS FOR A JOB
   GET /api/clients/jobs/:jobId/applications
===================================================== */
router.get("/jobs/:jobId/applications", async (req, res) => {
    const { jobId } = req.params;

    try {
        const [rows] = await db.query(
            `
            SELECT
                a.student_id,
                u.name AS student_name,
                a.status,
                a.apply_date
            FROM Application a
            JOIN User u
                ON a.student_id = u.user_id
            WHERE a.job_id = ?
            ORDER BY a.apply_date ASC
            `,
            [jobId]
        );

        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});


/* =====================================================
CLIENT → REVIEW APPLICATION
POST /api/clients/applications/review
===================================================== */
router.post("/applications/review", async (req, res) => {
    const { student_id, job_id, decision } = req.body;

    if (!student_id || !job_id || !decision) {
        return res.status(400).json({
            error: "student_id, job_id, and decision are required"
        });
    }

    if (decision !== "Accepted" && decision !== "Rejected") {
        return res.status(400).json({
            error: "Decision must be Accepted or Rejected"
        });
    }
    
    try {
        await db.query(
            "CALL ReviewApplication(?, ?, ?)",
            [student_id, job_id, decision]
        );
        
        res.json({
            message: `Application ${decision.toLowerCase()} successfully`
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

/* =====================================================
CLIENT → CURRENT MONTH PAYMENTS
   GET /api/clients/:clientId/payments/current
   ===================================================== */
   router.get("/:clientId/payments/current", async (req, res) => {
       const { clientId } = req.params;

    try {
        const [rows] = await db.query(
            `
            SELECT
                payment_id,
                student_name,
                job_title,
                amount,
                status
                FROM v_client_payments
                WHERE client_id = ?
                AND payment_month = MONTH(CURRENT_DATE)
              AND payment_year = YEAR(CURRENT_DATE)
            ORDER BY student_name
            `,
            [clientId]
        );
        
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

/* =====================================================
   CLIENT → MARK PAYMENT AS PAID
   POST /api/clients/payments/:paymentId/pay
===================================================== */
router.post("/payments/:paymentId/pay", async (req, res) => {
    const { paymentId } = req.params;

    try {
        await db.query(
            "CALL MarkPaymentPaid(?)",
            [paymentId]
        );

        res.json({ message: "Payment marked as paid" });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

/* =====================================================
   CLIENT → POST JOB (WITH SKILLS)
   POST /api/clients/:clientId/jobs
===================================================== */
router.post("/:clientId/jobs", async (req, res) => {
    const { clientId } = req.params;
    const { job_title, job_description, salary, skills } = req.body;
    
    if (!job_title || !job_description || !salary) {
        return res.status(400).json({
            error: "job_title, job_description, and salary are required"
        });
    }

    const conn = await db.getConnection();

    try {
        await conn.beginTransaction();

        // 1️⃣ Create job
        await conn.query(
            "CALL PostJob(?, ?, ?, ?)",
            [clientId, job_title, job_description, salary]
        );

        // 2️⃣ Get newly created job_id
        const [[jobRow]] = await conn.query(
            `
            SELECT job_id
            FROM Job
            WHERE client_id = ?
            ORDER BY job_id DESC
            LIMIT 1
            `,
            [clientId]
        );
        
        const jobId = jobRow.job_id;
        
        // 3️⃣ Insert required skills
        if (Array.isArray(skills)) {
            for (const skillId of skills) {
                await conn.query(
                    `
                    INSERT INTO Requires (job_id, skill_id)
                    VALUES (?, ?)
                    `,
                    [jobId, skillId]
                );
            }
        }

        await conn.commit();
        res.json({ message: "Job posted with skills successfully" });

    } catch (err) {
        await conn.rollback();
        res.status(500).json({ error: err.message });
    } finally {
        conn.release();
    }
});


module.exports = router;