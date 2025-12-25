// backend/server.js
const express = require("express");
const cors = require("cors");

const studentRoutes = require("./routes/student.routes");
const clientRoutes = require("./routes/client.routes");
const adminRoutes = require("./routes/admin.routes");
const jobRoutes = require("./routes/job.routes");

const app = express();

app.use(cors());
app.use(express.json());

// app.use("/api/students", studentRoutes);
// app.use("/api/clients", clientRoutes);
// app.use("/api/admins", adminRoutes);
app.use("/api/jobs", jobRoutes);

app.listen(3000, () => {
    console.log("Backend running on http://localhost:3000");
});


const db = require("./db");

app.get("/db-test", async (req, res) => {
    try {
        const [rows] = await db.query("SELECT 1 AS test");
        res.json({ status: "DB connected", result: rows });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});