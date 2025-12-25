// backend/db.js
const mysql = require("mysql2/promise");

const pool = mysql.createPool({
    host: "localhost",
    user: "pma",        // or your DB user
    password: "strongpassword",        // phpMyAdmin password
    database: "workwise",
    waitForConnections: true,
    connectionLimit: 10
});

module.exports = pool;