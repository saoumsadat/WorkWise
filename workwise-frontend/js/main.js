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

function applyJob(jobId) {
    const job = studentJobs.find(j => j.id === jobId);
    if (!job) return;
    job.applied = true;
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

function renderClient() {
    const clientInfoDiv = document.getElementById("client-info");
    const clientJobList = document.getElementById("client-job-list");

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
                Status: Open
            `;
            clientJobList.appendChild(li);
        });
    }
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
                Social Contribution Points: ${job.socialPoints}
            `;
            adminJobList.appendChild(li);
        });
    }
}

/* =========================
   INIT
========================= */
renderStudent();
renderClient();
renderAdmin();
