"use strict";

console.log("WorkWise frontend loaded");

const CURRENT_USER_ID = parseInt(localStorage.getItem("user_id"));

/* =========================
   STUDENT DATA & LOGIC
========================= */
let student = null;
const CURRENT_STUDENT_ID = CURRENT_USER_ID;

const studentJobs = [];

const currentMonth = "March 2025";

const appliedJobIds = new Set();

async function loadStudentJobs(studentId) {
    const res = await fetch(
        `http://localhost:3000/api/students/${studentId}/available-jobs`
    );
    const jobs = await res.json();

    studentJobs.length = 0;

    jobs.forEach(j => {
        studentJobs.push({
            id: j.job_id,
            title: j.job_title,
            salary: j.salary,
            socialPoints: j.social_contribution_points ?? "N/A"
        });
    });

    renderStudent();
}

async function loadStudentProfile() {
    try {
        const res = await fetch(
            `http://localhost:3000/api/students/${CURRENT_STUDENT_ID}`
        );
        const data = await res.json();

        student = {
            userId: data.user_id,
            studentId: data.student_id,
            name: data.name,
            email: data.email,
            major: data.major
        };

        loadStudentApplications();
        loadStudentSkills();
        loadCurrentMonthPayments();
        loadStudentJobs(student.userId);
        renderStudent();
    } catch (err) {
        console.error("Failed to load student profile", err);
    }
}

async function loadStudentApplications() {
    const res = await fetch(
        `http://localhost:3000/api/students/${student.userId}/applications`
    );
    const apps = await res.json();

    renderStudentApplications(apps);
}

async function loadStudentSkills() {
    try {
        const res = await fetch(
            `http://localhost:3000/api/students/${student.userId}/skills`
        );
        const rows = await res.json();

        renderStudentSkills(rows);
    } catch (err) {
        console.error("Failed to load student skills", err);
    }
}

async function loadCurrentMonthPayments() {
    if (!student) return;

    try {
        const res = await fetch(
            `http://localhost:3000/api/students/${student.userId}/payments/current`
        );
        const payments = await res.json();

        renderCurrentMonthPayments(payments);
    } catch (err) {
        console.error("Failed to load payment status", err);
    }
}

function renderStudent() {
    if (!student) return;
    const studentInfoDiv = document.getElementById("student-info");
    const jobList = document.getElementById("student-job-list");

    if (studentInfoDiv) {
        studentInfoDiv.innerHTML = `
            <h3>Student Information</h3>
            <p><strong>User ID:</strong> ${student.userId}</p>
            <p><strong>Student ID:</strong> ${student.studentId}</p>
            <p><strong>Name:</strong> ${student.name}</p>
            <p><strong>Email:</strong> ${student.email}</p>
            <p><strong>Major:</strong> ${student.major}</p>
        `;
    }

    if (jobList) {
        jobList.innerHTML = "";
        studentJobs.forEach(job => {
            const li = document.createElement("li");
            li.innerHTML = `
                <strong>${job.title}</strong><br>
                Salary: ${job.salary}<br>
                Social Contribution Points: ${job.socialPoints}<br>
                Status: <span class="status">${job.applied ? "Applied" : "Not Applied"}</span><br>
                <button ${job.applied ? "disabled" : ""} onclick="applyJob(${job.id})">
                    ${job.applied ? "Applied" : "Apply"}
                </button>
            `;
            jobList.appendChild(li);
        });
    }
}

function renderStudentSkills(rows) {
    const skillList = document.getElementById("student-skill-list");
    if (!skillList) return;

    skillList.innerHTML = "";

    if (!rows || rows.length === 0) {
        skillList.innerHTML = "<li>No skills found.</li>";
        return;
    }

    // Group courses by skill
    const skillMap = {};

    rows.forEach(r => {
        if (!skillMap[r.skill_id]) {
            skillMap[r.skill_id] = {
                name: r.skill_name,
                description: r.skill_description,
                paths: []
            };
        }

        skillMap[r.skill_id].paths.push(
            `${r.course_code} → ${r.course_title} (${r.generic_course})`
        );
    });

    Object.values(skillMap).forEach(skill => {
        const li = document.createElement("li");
        li.innerHTML = `
            <strong>${skill.name}</strong><br>
            <em>${skill.description}</em><br>
            ${skill.paths.join("<br>")}
        `;
        skillList.appendChild(li);
    });
}


function renderStudentApplications(apps) {
    const list = document.getElementById("student-application-list");
    if (!list) return;

    list.innerHTML = "";

    if (!apps || apps.length === 0) {
        list.innerHTML = "<li>No applications yet.</li>";
        return;
    }

    apps.forEach(app => {
        const li = document.createElement("li");

        let actionButton = "";

        if (app.status === "Rejected") {
            actionButton = `
                <button onclick="reapplyJob(${app.job_id}, this)">
                    Reapply
                </button>
            `;
        }

        li.innerHTML = `
            <strong>${app.job_title}</strong><br>
            Company: ${app.company_name}<br>
            Status: <strong>${app.status}</strong><br>
            Applied on: ${app.apply_date}<br>
            Application No: ${app.application_no}<br>
            ${actionButton}
        `;

        list.appendChild(li);
    });
}

function renderCurrentMonthPayments(payments) {
    const monthDiv = document.getElementById("current-month");
    const list = document.getElementById("student-payment-status");

    if (!monthDiv || !list) return;

    const now = new Date();
    const monthName = now.toLocaleString("default", { month: "long" });
    const year = now.getFullYear();

    monthDiv.innerHTML = `<strong>${monthName} ${year}</strong>`;
    list.innerHTML = "";

    if (!payments || payments.length === 0) {
        list.innerHTML = "<li>No payment records for this month.</li>";
        return;
    }

    payments.forEach(p => {
        const li = document.createElement("li");
        li.innerHTML = `
            <strong>${p.job_title}</strong><br>
            Amount: ${p.amount}<br>
            Status: <strong>${p.status}</strong>
        `;
        list.appendChild(li);
    });
}

async function applyJob(jobId) {
    if (!student) return;

    try {
        const res = await fetch(
            `http://localhost:3000/api/students/${student.userId}/apply`,
            {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ jobId })
            }
        );

        const data = await res.json();

        if (!res.ok) {
            if (data?.error?.includes("eligible")) {
                alert("You are not eligible for this job");
            } else {
                alert("Application failed");
            }
            return;
        }

        alert("Application submitted successfully");

        // Refresh DB-backed sections
        loadStudentApplications();
        loadStudentJobs(student.userId);
    } catch (err) {
        console.error("Apply failed", err);
        alert("Something went wrong");
    }
}

async function reapplyJob(jobId, btn) {
    if (!student) return;

    try {
        await fetch(
            `http://localhost:3000/api/students/${student.userId}/apply`,
            {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ jobId })
            }
        );

        // 1) Remove the button immediately (UX)
        if (btn) btn.remove();

        // 2) Refresh DB-backed sections (truth sync)
        await loadStudentApplications();
        await loadStudentJobs(student.userId);
    } catch (err) {
        console.error("Reapply failed", err);
    }
}


/* =========================
   CLIENT DATA & LOGIC
========================= */

const CURRENT_CLIENT_ID = CURRENT_USER_ID;

let clientProfile = null;
let clientJobs = [];

async function loadClientProfile() {
    try {
        const res = await fetch(
            `http://localhost:3000/api/clients/${CURRENT_CLIENT_ID}`
        );
        const data = await res.json();

        clientProfile = data;
        renderClient();
    } catch (err) {
        console.error("Failed to load client profile", err);
    }
}


async function loadClientJobs() {
    try {
        const res = await fetch(
            `http://localhost:3000/api/clients/${CURRENT_CLIENT_ID}/jobs`
        );
        const jobs = await res.json();

        clientJobs = jobs;
        renderClient();
    } catch (err) {
        console.error("Failed to load client jobs", err);
    }
}

async function loadClientPayments() {
    try {
        const res = await fetch(
            `http://localhost:3000/api/clients/${CURRENT_CLIENT_ID}/payments/current`
        );
        const payments = await res.json();

        renderClientPayments(payments);
    } catch (err) {
        console.error("Failed to load client payments", err);
    }
}

async function loadSkills() {
    try {
        const res = await fetch("http://localhost:3000/api/jobs/skills");
        const skills = await res.json();

        const skillList = document.getElementById("skill-list");
        if (!skillList) return;

        skillList.innerHTML = "";

        skills.forEach(skill => {
            const label = document.createElement("label");
            label.innerHTML = `
                <input type="checkbox" value="${skill.skill_id}">
                ${skill.skill_name}
            `;
            skillList.appendChild(label);
            skillList.appendChild(document.createElement("br"));
        });
    } catch (err) {
        console.error("Failed to load skills", err);
    }
}

async function postJob(title, salary) {
    try {
        const selectedSkills = Array.from(
            document.querySelectorAll("#skill-list input:checked")
        ).map(cb => parseInt(cb.value));

        const res = await fetch(
            `http://localhost:3000/api/clients/${CURRENT_CLIENT_ID}/jobs`,
            {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    job_title: title,
                    job_description: title,
                    salary: salary,
                    skills: selectedSkills
                })
            }
        );

        const data = await res.json();

        if (!res.ok) {
            alert(data.error || "Failed to post job");
            return;
        }

        alert("Job posted successfully");

        // Refresh DB-backed job list
        loadClientJobs();

    } catch (err) {
        console.error("Job post failed", err);
        alert("Server error while posting job");
    }
}

function renderClient() {
    const clientInfoDiv = document.getElementById("client-info");
    const clientJobList = document.getElementById("client-job-list");

    if (clientInfoDiv && clientProfile) {
        clientInfoDiv.innerHTML = `
            <h3>Client Information</h3>
            <p><strong>User ID:</strong> ${clientProfile.user_id}</p>
            <p><strong>Company:</strong> ${clientProfile.company_name}</p>
            <p><strong>Industry:</strong> ${clientProfile.industry}</p>
        `;
    }

    if (!clientJobList) return;

    clientJobList.innerHTML = "";

    if (!clientJobs || clientJobs.length === 0) {
        clientJobList.innerHTML = "<li>No jobs posted yet.</li>";
        return;
    }

    clientJobs.forEach(job => {
        const li = document.createElement("li");

        li.innerHTML = `
            <strong>${job.job_title}</strong><br>
            Salary: ${job.salary}<br>
            Social Contribution Points: ${job.social_contribution_points ?? "N/A"}<br><br>
            <button onclick="openApplications(${job.job_id})">
                View Applications
            </button>
        `;

        clientJobList.appendChild(li);
    });
}

function openApplications(jobId) {
    localStorage.setItem("currentJobId", jobId);
    window.location.href = "client-applications.html";
}

async function updateApplicationStatus(jobId, studentId, decision) {
    try {
        const res = await fetch(
            "http://localhost:3000/api/clients/applications/review",
            {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    student_id: studentId,
                    job_id: jobId,
                    decision: decision
                })
            }
        );

        const data = await res.json();

        if (!res.ok) {
            alert(data.error || "Failed to review application");
            return;
        }

        // Refresh DB-backed list (single source of truth)
        await renderClientApplications();

    } catch (err) {
        console.error("Review failed", err);
        alert("Server error while reviewing application");
    }
}


async function renderClientApplications() {
    const list = document.getElementById("client-application-list");
    if (!list) return;

    const jobId = localStorage.getItem("currentJobId");
    if (!jobId) {
        list.innerHTML = "<li>No job selected.</li>";
        return;
    }

    try {
        const res = await fetch(
            `http://localhost:3000/api/clients/jobs/${jobId}/applications`
        );
        const applications = await res.json();

        list.innerHTML = "";

        if (!applications || applications.length === 0) {
            list.innerHTML = "<li>No applications for this job.</li>";
            return;
        }

        applications.forEach(app => {
            const li = document.createElement("li");

            let actionButtons = "";

            if (app.status === "Pending") {
                actionButtons = `
                    <br><br>
                    <button onclick="updateApplicationStatus(${jobId}, ${app.student_id}, 'Accepted')">
                        Accept
                    </button>
                    <button onclick="updateApplicationStatus(${jobId}, ${app.student_id}, 'Rejected')">
                        Reject
                    </button>
                `;
            }

            li.innerHTML = `
                <strong>${app.student_name}</strong><br>
                Student ID: ${app.student_id}<br>
                Applied on: ${app.apply_date}<br>
                Status: <strong>${app.status}</strong>
                ${actionButtons}
            `;

            list.appendChild(li);
        });
    } catch (err) {
        console.error("Failed to load applications", err);
        list.innerHTML = "<li>Error loading applications.</li>";
    }
}

function renderClientPayments(payments) {
    const monthDiv = document.getElementById("client-payment-month");
    const list = document.getElementById("client-payment-list");

    if (!monthDiv || !list) return;

    const now = new Date();
    const monthName = now.toLocaleString("default", { month: "long" });
    const year = now.getFullYear();

    monthDiv.innerHTML = `<strong>${monthName} ${year}</strong>`;
    list.innerHTML = "";

    if (!payments || payments.length === 0) {
        list.innerHTML = "<li>No employees to pay this month.</li>";
        return;
    }

    payments.forEach(p => {
        const li = document.createElement("li");

        let action = "";
        if (p.status === "Unpaid") {
            action = `
                <br><br>
                <button onclick="payClientPayment(${p.payment_id})">
                    Mark as Paid
                </button>
            `;
        }

        li.innerHTML = `
            <strong>${p.student_name}</strong><br>
            Job: ${p.job_title}<br>
            Amount: ${p.amount}<br>
            Status: <strong>${p.status}</strong>
            ${action}
        `;

        list.appendChild(li);
    });
}

async function payClientPayment(paymentId) {
    try {
        const res = await fetch(
            `http://localhost:3000/api/clients/payments/${paymentId}/pay`,
            {
                method: "POST"
            }
        );

        const data = await res.json();

        if (!res.ok) {
            alert(data.error || "Failed to mark payment as paid");
            return;
        }

        // Refresh DB-backed list (single source of truth)
        await loadClientPayments();

    } catch (err) {
        console.error("Failed to mark payment as paid", err);
        alert("Server error while marking payment as paid");
    }
}

const postJobForm = document.getElementById("post-job-form");

if (postJobForm) {
    postJobForm.addEventListener("submit", function (e) {
        e.preventDefault();

        const title = document.getElementById("job-title").value;
        const salary = document.getElementById("job-salary").value;

        postJob(title, salary);

        postJobForm.reset();
    });
}


/* =========================
   ADMIN DATA & LOGIC
========================= */
const CURRENT_ADMIN_ID = CURRENT_USER_ID;
let adminProfile = null;

async function loadAdminProfile() {
    try {
        const res = await fetch(
            `http://localhost:3000/api/admins/${CURRENT_ADMIN_ID}`
        );
        const data = await res.json();

        adminProfile = data;
        renderAdmin();
    } catch (err) {
        console.error("Failed to load admin profile", err);
    }
}

let adminJobs = [];

async function loadAdminJobs() {
    try {
        const res = await fetch(
            `http://localhost:3000/api/admins/${CURRENT_ADMIN_ID}/jobs`
        );
        const jobs = await res.json();

        adminJobs = jobs;
        renderAdminJobs();
    } catch (err) {
        console.error("Failed to load admin jobs", err);
    }
}

function renderAdmin() {
    const adminInfoDiv = document.getElementById("admin-info");
    if (!adminInfoDiv || !adminProfile) return;

    adminInfoDiv.innerHTML = `
        <h3>Admin Information</h3>
        <p><strong>User ID:</strong> ${adminProfile.user_id}</p>
        <p><strong>Name:</strong> ${adminProfile.name}</p>
        <p><strong>University:</strong> ${adminProfile.university_name}</p>
        <p><strong>Email:</strong> ${adminProfile.email}</p>
    `;
}

function renderAdminJobs() {
    const list = document.getElementById("admin-job-list");
    if (!list) return;

    list.innerHTML = "";

    if (!adminJobs || adminJobs.length === 0) {
        list.innerHTML = "<li>No jobs found.</li>";
        return;
    }

    adminJobs.forEach(job => {
        let pointsText = "<em>Not Assigned</em>";
        let buttonLabel = "Assign";

        if (job.social_contribution_points !== null) {
            buttonLabel = "Re-evaluate";

            if (
                job.assigned_university_id &&
                job.assigned_university_id !== job.my_university_id
            ) {
                pointsText = `
                    ${job.social_contribution_points}
                    <em>(Assigned by ${job.assigned_university_name})</em>
                `;
            } else {
                pointsText = job.social_contribution_points;
            }
        }

        const li = document.createElement("li");

        li.innerHTML = `
            <strong>${job.job_title}</strong><br>
            Social Contribution Point: ${pointsText}<br><br>

            <button onclick="openAssignPoints(${job.job_id}, ${job.social_contribution_points ?? ""})">
                ${buttonLabel}
            </button>

            <div id="assign-${job.job_id}" style="display:none;">
                <input
                    type="number"
                    id="points-${job.job_id}"
                    min="0"
                    value="${job.social_contribution_points ?? ""}"
                    placeholder="Enter points"
                >
                <button onclick="saveAssignPoints(${job.job_id})">
                    Save
                </button>
            </div>
        `;

        list.appendChild(li);
    });
}

function openAssignPoints(jobId) {
    const div = document.getElementById(`assign-${jobId}`);
    if (div) div.style.display = "block";
}

async function saveAssignPoints(jobId) {
    const input = document.getElementById(`points-${jobId}`);
    if (!input || input.value === "") return;

    const points = parseInt(input.value);

    try {
        const res = await fetch(
            `http://localhost:3000/api/admins/jobs/${jobId}/assign-points`,
            {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    admin_id: CURRENT_ADMIN_ID,
                    points: points
                })
            }
        );

        const data = await res.json();

        if (!res.ok) {
            alert(data.error || "Failed to assign points");
            return;
        }

        alert("Social contribution points updated");

        // refresh DB-backed state
        loadAdminJobs();

    } catch (err) {
        console.error("Assign points failed", err);
        alert("Server error while assigning points");
    }
}

function enableEdit(jobId) {
    document.getElementById(`edit-${jobId}`).style.display = "block";
}

function saveEdit(jobId) {
    const input = document.getElementById(`input-${jobId}`);
    const newValue = input.value;

    if (newValue === "") return;

    const job = adminJobs.find(j => j.id === jobId);
    if (!job) return;

    job.socialPoints = parseInt(newValue);

    renderAdmin();
}

function updateSocialPoints(jobId, newValue) {
    const job = adminJobs.find(j => j.id === jobId);
    if (!job) return;

    job.socialPoints = parseInt(newValue);
}

/* =========================
   INIT
========================= */
loadStudentProfile();
loadClientProfile();
loadSkills();
loadClientJobs();
loadClientPayments();
loadAdminProfile();
loadAdminJobs();
renderClientApplications();