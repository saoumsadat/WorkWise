-- =========================
-- DATABASE
-- =========================
CREATE DATABASE IF NOT EXISTS workwise;
USE workwise;

-- =========================
-- UNIVERSITY & COURSES
-- =========================
CREATE TABLE University (
    university_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE Generic_Course (
    generic_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE University_Course (
    course_code VARCHAR(20) PRIMARY KEY,
    course_title VARCHAR(100) NOT NULL,
    university_id INT NOT NULL,
    generic_id INT NOT NULL,
    FOREIGN KEY (university_id) REFERENCES University(university_id),
    FOREIGN KEY (generic_id) REFERENCES Generic_Course(generic_id)
);

-- =========================
-- SKILLS
-- =========================
CREATE TABLE Skill (
    skill_id INT PRIMARY KEY AUTO_INCREMENT,
    skill_name VARCHAR(100) NOT NULL,
    skill_description TEXT
);

-- Generic_Course ⇄ Skill (M:N)
CREATE TABLE Produces (
    generic_id INT,
    skill_id INT,
    PRIMARY KEY (generic_id, skill_id),
    FOREIGN KEY (generic_id) REFERENCES Generic_Course(generic_id),
    FOREIGN KEY (skill_id) REFERENCES Skill(skill_id)
);

-- =========================
-- USERS (SUPERCLASS)
-- =========================
CREATE TABLE User (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE User_Phone (
    user_id INT,
    phone VARCHAR(20),
    PRIMARY KEY (user_id, phone),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

-- =========================
-- USER SUBCLASSES
-- =========================
CREATE TABLE Student (
    user_id INT PRIMARY KEY,
    student_id VARCHAR(30) UNIQUE NOT NULL,
    major VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE University_Admin (
    user_id INT PRIMARY KEY,
    university_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (university_id) REFERENCES University(university_id)
);

CREATE TABLE Client (
    user_id INT PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    industry VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

-- =========================
-- STUDENT TAKES COURSES
-- =========================
CREATE TABLE Takes (
    student_id INT,
    course_code VARCHAR(20),
    semester VARCHAR(20),
    grade VARCHAR(5),
    PRIMARY KEY (student_id, course_code),
    FOREIGN KEY (student_id) REFERENCES Student(user_id),
    FOREIGN KEY (course_code) REFERENCES University_Course(course_code)
);

-- =========================
-- JOBS
-- =========================
CREATE TABLE Job (
    job_id INT PRIMARY KEY AUTO_INCREMENT,
    job_title VARCHAR(100) NOT NULL,
    job_description TEXT,
    salary DECIMAL(10,2),
    social_contribution_points INT,
    admin_id INT NULL,
    client_id INT NOT NULL,
    FOREIGN KEY (admin_id) REFERENCES University_Admin(user_id),
    FOREIGN KEY (client_id) REFERENCES Client(user_id)
);

-- Job ⇄ Skill (M:N)
CREATE TABLE Requires (
    job_id INT,
    skill_id INT,
    PRIMARY KEY (job_id, skill_id),
    FOREIGN KEY (job_id) REFERENCES Job(job_id),
    FOREIGN KEY (skill_id) REFERENCES Skill(skill_id)
);

-- =========================
-- APPLICATION (WEAK ENTITY)
-- =========================
CREATE TABLE Application (
    student_id INT,
    job_id INT,
    application_no INT,
    apply_date DATE,
    status VARCHAR(20),
    PRIMARY KEY (student_id, job_id),
    FOREIGN KEY (student_id) REFERENCES Student(user_id),
    FOREIGN KEY (job_id) REFERENCES Job(job_id)
);

-- =========================
-- PAYMENTS
-- =========================
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_date DATE,
    payment_month INT,
    payment_year INT,
    amount DECIMAL(10,2),
    status VARCHAR(20),
    application_student_id INT,
    application_job_id INT,
    client_id INT,
    FOREIGN KEY (application_student_id, application_job_id)
        REFERENCES Application(student_id, job_id),
    FOREIGN KEY (client_id) REFERENCES Client(user_id)
);

-- =========================
-- AUDIT LOG
-- =========================
CREATE TABLE AuditLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    operation_type VARCHAR(10),
    entity_name VARCHAR(50),
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);
