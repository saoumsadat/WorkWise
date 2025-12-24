"use strict";

console.log("WorkWise frontend loaded");

/* =========================
   STUDENT DATA & LOGIC
========================= */
const student = {
    userId: 101,
    studentId: "STU-2023-045",
    name: "John Doe",
    email: "john.doe@email.com",
    major: "Computer Science"
};

const studentJobs = [
    {
        id: 1,
        title: "Software Intern",
        salary: 20000,
        skills: ["Python", "SQL"],
        socialPoints: 8,
        applied: false
    },
    {
        id: 2,
        title: "Data Analyst",
        salary: 30000,
        skills: ["Excel", "Statistics"],
        socialPoints: 10,
        applied: false
    }
];

const studentSkills = [
    {
        skillName: "Problem Solving",
        paths: ["CSE220 → DSA", "CSE111 → OOP"]
    },
    {
        skillName: "Database Design",
        paths: ["CSE330 → Relational Databases"]
    }
];

const currentMonth = "March 2025";

const payments = [
    {
        studentName: "John Doe",
        jobTitle: "Software Intern",
        status: "Pending"
    },
    {
        studentName: "Jane Smith",
        jobTitle: "Data Analyst",
        status: "Paid"
    }
];

const studentApplications = [
    {
        jobTitle: "Software Intern",
        company: "TechNova Ltd.",
        status: "Accepted"
    },
    {
        jobTitle: "Data Analyst",
        company: "DataWorks Inc.",
        status: "Pending"
    }
];

function renderStudent() {
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
                Skills: ${job.skills.join(", ")}<br>
                Status: <span class="status">${job.applied ? "Applied" : "Not Applied"}</span><br>
                <button ${job.applied ? "disabled" : ""} onclick="applyJob(${job.id})">
                    ${job.applied ? "Applied" : "Apply"}
                </button>
            `;
            jobList.appendChild(li);
        });
    }
}

function renderStudentSkills() {
    const skillList = document.getElementById("student-skill-list");
    if (!skillList) return;

    skillList.innerHTML = "";

    studentSkills.forEach(skill => {
        const li = document.createElement("li");

        li.innerHTML = `
            <strong>${skill.skillName}</strong>
            (${skill.paths.join(", ")})
        `;

        skillList.appendChild(li);
    });
}


function renderStudentApplications() {
    const list = document.getElementById("student-application-list");
    if (!list) return;

    list.innerHTML = "";

    if (studentApplications.length === 0) {
        list.innerHTML = "<li>No applications yet.</li>";
        return;
    }

    studentApplications.forEach(app => {
        const li = document.createElement("li");
        li.innerHTML = `
            <strong>${app.jobTitle}</strong><br>
            Company: ${app.company}<br>
            Status: ${app.status}
        `;
        list.appendChild(li);
    });
}

function renderCurrentMonthPayments() {
    const monthDiv = document.getElementById("current-month");
    const list = document.getElementById("student-payment-status");

    if (!monthDiv || !list) return;

    monthDiv.innerHTML = `<strong>${currentMonth}</strong>`;
    list.innerHTML = "";

    const studentName = student.name;

    const myPayments = payments.filter(
        p => p.studentName === studentName
    );

    if (myPayments.length === 0) {
        list.innerHTML = "<li>No payment records for this month.</li>";
        return;
    }

    myPayments.forEach(p => {
        const li = document.createElement("li");
        li.innerHTML = `
            <strong>${p.jobTitle}</strong><br>
            Status: ${p.status}
        `;
        list.appendChild(li);
    });
}

function applyJob(jobId) {
    const job = studentJobs.find(j => j.id === jobId);
    if (!job || job.applied) return;

    job.applied = true;

    studentApplications.push({
        jobTitle: job.title,
        status: "Applied"
    });

    renderStudent();
}

/* =========================
   CLIENT DATA & LOGIC
========================= */
const client = {
    userId: 201,
    companyName: "TechNova Ltd.",
    industry: "Software Services",
    email: "hr@technova.com"
};

const clientJobs = [
    { id: 1, title: "Software Intern", salary: 20000 },
    { id: 2, title: "Backend Developer", salary: 50000 }
];

const jobApplications = {
    1: [
        {
            studentName: "John Doe",
            studentId: "STU-2023-045",
            skills: ["Python", "SQL"],
            status: "Pending"
        },
        {
            studentName: "Jane Smith",
            studentId: "STU-2023-078",
            skills: ["Python", "Data Analysis"],
            status: "Pending"
        }
    ]
};


function postJob(title, salary) {
    clientJobs.push({
        id: Date.now(),
        title: title,
        salary: salary
    });

    renderClient();
}

function renderClient() {
    const clientInfoDiv = document.getElementById("client-info");
    const clientJobList = document.getElementById("client-job-list");

    if (clientJobs.length === 0) {
        clientJobList.innerHTML = "<li>No jobs posted yet.</li>";
        return;
    }

    if (clientInfoDiv) {
        clientInfoDiv.innerHTML = `
            <h3>Client Information</h3>
            <p><strong>User ID:</strong> ${client.userId}</p>
            <p><strong>Company:</strong> ${client.companyName}</p>
            <p><strong>Industry:</strong> ${client.industry}</p>
            <p><strong>Email:</strong> ${client.email}</p>
        `;
    }

    if (clientJobList) {
        clientJobList.innerHTML = "";

        clientJobs.forEach(job => {
            const li = document.createElement("li");

            li.innerHTML = `
            <strong>${job.title}</strong><br>
            Salary: ${job.salary}<br>
            Status: Open<br><br>
            <button onclick="openApplications(${job.id})">
                View Applications
            </button>
        `;

            clientJobList.appendChild(li);
        });
    }
}

function viewApplications(jobId) {
    alert("View Applications will be implemented after backend integration.");
}

function openApplications(jobId) {
    localStorage.setItem("currentJobId", jobId);
    window.location.href = "client-applications.html";
}

function updateApplicationStatus(jobId, index, newStatus) {
    jobApplications[jobId][index].status = newStatus;
    renderClientApplications();
}

function renderClientApplications() {
    const list = document.getElementById("client-application-list");
    if (!list) return;

    const jobId = localStorage.getItem("currentJobId");
    const applications = jobApplications[jobId] || [];

    list.innerHTML = "";

    if (applications.length === 0) {
        list.innerHTML = "<li>No applications for this job.</li>";
        return;
    }

    applications.forEach((app, index) => {
        const li = document.createElement("li");
        li.innerHTML = `
            <strong>${app.studentName}</strong><br>
            Student ID: ${app.studentId}<br>
            Skills: ${app.skills.join(", ")}<br>
            Status: <strong>${app.status}</strong><br><br>
            <button onclick="updateApplicationStatus(${jobId}, ${index}, 'Accepted')">Accept</button>
            <button onclick="updateApplicationStatus(${jobId}, ${index}, 'Rejected')">Reject</button>
        `;
        list.appendChild(li);
    });
}

function renderClientPayments() {
    const monthDiv = document.getElementById("client-payment-month");
    const list = document.getElementById("client-payment-list");

    if (!monthDiv || !list) return;

    monthDiv.innerHTML = `<strong>${currentMonth}</strong>`;
    list.innerHTML = "";

    if (payments.length === 0) {
        list.innerHTML = "<li>No employees to pay this month.</li>";
        return;
    }

    payments.forEach((p, index) => {
        const li = document.createElement("li");

        li.innerHTML = `
            <strong>${p.studentName}</strong><br>
            Job: ${p.jobTitle}<br>
            Status: <strong>${p.status}</strong><br><br>
            ${
                p.status === "Pending"
                    ? `<button onclick="payStudent(${index})">Pay</button>`
                    : `<em>Payment completed</em>`
            }
        `;

        list.appendChild(li);
    });
}

function payStudent(index) {
    payments[index].status = "Paid";

    renderClientPayments();
    renderCurrentMonthPayments();
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
const admin = {
    userId: 301,
    name: "Dr. Alice Smith",
    university: "ABC University",
    email: "admin@abc.edu"
};

const adminJobs = [
    {
        id: 1,
        title: "Software Intern",
        socialPoints: null
    },
    {
        id: 2,
        title: "Community Data Analyst",
        socialPoints: 10
    }
];

function renderAdmin() {
    const adminInfoDiv = document.getElementById("admin-info");
    const adminJobList = document.getElementById("admin-job-list");

    if (adminInfoDiv) {
        adminInfoDiv.innerHTML = `
            <h3>Admin Information</h3>
            <p><strong>User ID:</strong> ${admin.userId}</p>
            <p><strong>Name:</strong> ${admin.name}</p>
            <p><strong>University:</strong> ${admin.university}</p>
            <p><strong>Email:</strong> ${admin.email}</p>
        `;
    }

    if (adminJobList) {
        adminJobList.innerHTML = "";

        adminJobs.forEach(job => {
            const li = document.createElement("li");

            const pointsDisplay =
                job.socialPoints === null
                    ? "<em>Not Assigned</em>"
                    : `<span id="points-${job.id}">${job.socialPoints}</span>`;

            const editLabel =
                job.socialPoints === null ? "Assign" : "Edit";

            li.innerHTML = `
                <strong>${job.title}</strong><br>
                Social Contribution Points:
                ${pointsDisplay}
                <button class="edit-btn" onclick="enableEdit(${job.id})">✏️ ${editLabel}</button>

                <div id="edit-${job.id}" style="display:none;">
                    <input
                        type="number"
                        id="input-${job.id}"
                        value="${job.socialPoints ?? ""}"
                        min="0"
                        placeholder="Enter points"
                    >
                    <button onclick="saveEdit(${job.id})">Save</button>
                </div>
            `;

            adminJobList.appendChild(li);
        });

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
renderStudent();
renderClient();
renderAdmin();
renderStudentApplications();
renderStudentSkills();
renderCurrentMonthPayments();
renderClientApplications();
renderClientPayments();