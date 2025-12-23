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

const studentApplications = [];

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
            Application Status: ${app.status}
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
            <button onclick="viewApplications(${job.id})">
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
        socialPoints: 8
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

            li.innerHTML = `
                <strong>${job.title}</strong><br>
                Social Contribution Points:
                <span id="points-${job.id}">${job.socialPoints}</span>
                <button class="edit-btn" onclick="enableEdit(${job.id})">✏️</button>
                <div id="edit-${job.id}" style="display:none;">
                    <input type="number" id="input-${job.id}" value="${job.socialPoints}" min="0">
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
    const newValue = parseInt(input.value);

    const job = adminJobs.find(j => j.id === jobId);
    if (!job) return;

    job.socialPoints = newValue;

    document.getElementById(`points-${jobId}`).innerText = newValue;
    document.getElementById(`edit-${jobId}`).style.display = "none";
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