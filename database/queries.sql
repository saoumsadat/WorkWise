-- STUDENT:::


-- Q1: Load student basic profile
-- Used in: Student dashboard header
-- Description: Fetches identity and academic info of a student
-- Tables: User, Student
-- Requirement: Multi-table JOIN

SELECT
    u.user_id,
    u.name,
    u.email,
    s.student_id,
    s.major
FROM User u
JOIN Student s
    ON u.user_id = s.user_id
WHERE u.user_id = 101;


-- Q2: Derive skills of a student
-- Used in: Student skill profile
-- Description: Retrieves all skills acquired by a student
-- Through: Takes → University_Course → Generic_Course → Produces → Skill
-- Requirement: Multi-table JOIN, analytical/derived query

SELECT DISTINCT
    sk.skill_id,
    sk.skill_name,
    sk.skill_description
FROM Takes t
JOIN University_Course uc
    ON t.course_code = uc.course_code
JOIN Generic_Course gc
    ON uc.generic_id = gc.generic_id
JOIN Produces p
    ON gc.generic_id = p.generic_id
JOIN Skill sk
    ON p.skill_id = sk.skill_id
WHERE t.student_id = 101;

-- Q2A: Student skills with course lineage
-- Used in: Student skill profile (UI)
-- Description: Shows skills along with university and generic courses
-- Requirement: Multi-table JOIN, explanatory/analytical query

SELECT DISTINCT
    sk.skill_id,
    sk.skill_name,
    sk.skill_description,
    gc.name AS generic_course,
    uc.course_code,
    uc.course_title
FROM Takes t
JOIN University_Course uc
    ON t.course_code = uc.course_code
JOIN Generic_Course gc
    ON uc.generic_id = gc.generic_id
JOIN Produces p
    ON gc.generic_id = p.generic_id
JOIN Skill sk
    ON p.skill_id = sk.skill_id
WHERE t.student_id = 101
ORDER BY sk.skill_name, uc.course_code;


-- Q3: Available jobs (minimal)
-- Used in: Student job listing (base query)
-- Description: Fetches all jobs with salary and social contribution points
-- Requirement: Multi-table JOIN

SELECT
    j.job_id,
    j.job_title,
    j.salary,
    j.social_contribution_points,
    c.company_name
FROM Job j
JOIN Client c
    ON j.client_id = c.user_id
ORDER BY j.job_id;

-- Q3A: Available jobs with required skills
-- Used in: Student job listing (UI)
-- Description: Shows jobs along with their required skills
-- Requirement: Multi-table JOIN, explanatory query

SELECT
    j.job_id,
    j.job_title,
    j.salary,
    j.social_contribution_points,
    c.company_name,
    sk.skill_name
FROM Job j
JOIN Client c
    ON j.client_id = c.user_id
LEFT JOIN Requires r
    ON j.job_id = r.job_id
LEFT JOIN Skill sk
    ON r.skill_id = sk.skill_id
ORDER BY j.job_id, sk.skill_name;


-- Q4: Check if a student satisfies all required skills for a job
-- Used in: Eligibility validation before applying
-- Requirement: Nested subquery, set logic

SELECT j.job_id, j.job_title
FROM Job j
WHERE j.job_id = 3
AND NOT EXISTS (
    SELECT r.skill_id
    FROM Requires r
    WHERE r.job_id = j.job_id
    AND r.skill_id NOT IN (
        SELECT p.skill_id
        FROM Takes t
        JOIN University_Course uc ON t.course_code = uc.course_code
        JOIN Generic_Course gc ON uc.generic_id = gc.generic_id
        JOIN Produces p ON gc.generic_id = p.generic_id
        WHERE t.student_id = 101
    )
);


-- Q5: Student applies for a job
-- Used in: Apply button
-- Description: Creates a new application with default status
-- Business rule: Status is system-controlled, not student-controlled

INSERT INTO Application (
    student_id,
    job_id,
    application_no,
    apply_date,
    status
)
VALUES (
    102,
    1,
    2,
    CURRENT_DATE,
    'Rejected'
);


-- Q6: View all applications of a student
-- Used in: "My Applications" page
-- Requirement: Multi-table JOIN
-- Candidate for VIEW

SELECT
    a.application_no,
    j.job_title,
    c.company_name,
    a.status,
    a.apply_date
FROM Application a
JOIN Job j ON a.job_id = j.job_id
JOIN Client c ON j.client_id = c.user_id
WHERE a.student_id = 101
ORDER BY a.apply_date DESC;


-- Q7: Student payment status for current month
-- Used in: Student dashboard payment section
-- Requirement: Time-based analytical query

SELECT
    j.job_title,
    p.amount,
    p.status,
    p.payment_month,
    p.payment_year
FROM Payment p
JOIN Application a
    ON p.application_student_id = a.student_id
   AND p.application_job_id = a.job_id
JOIN Job j ON a.job_id = j.job_id
WHERE a.student_id = 101
  AND p.payment_month = MONTH(CURRENT_DATE)
  AND p.payment_year = YEAR(CURRENT_DATE);


-- Q8: Check if student already applied to a job
-- Used in: Validation before insert
-- Requirement: Conditional existence check

SELECT 1
FROM Application
WHERE student_id = 103
  AND job_id = 1;


-- WF1: Student re-applies to a job (reference workflow SQL)
-- Description:
--   Models reapplication as a state transition rather than a new record.
-- Business rules:
--   - Only allowed if current status = 'Rejected'
--   - Status is reset to 'Pending'
--   - apply_date is updated
-- Notes:
--   - This logic is implemented as a stored procedure in procedures.sql
--   - Included here for documentation and testing purposes

-- Reference SQL (do NOT use directly in production logic)
UPDATE Application
SET status = 'Pending',
    apply_date = CURRENT_DATE
WHERE student_id = 103
  AND job_id = 5
  AND status = 'Rejected';



-- CLIENT:::


-- C1: Load client profile
-- Used in: Client dashboard header

SELECT
    u.user_id,
    u.name,
    u.email,
    c.company_name,
    c.industry
FROM User u
JOIN Client c
    ON u.user_id = c.user_id
WHERE u.user_id = 201;


-- C2: View jobs posted by client
-- Used in: Client dashboard job list

SELECT
    j.job_id,
    j.job_title,
    j.salary,
    j.social_contribution_points
FROM Job j
WHERE j.client_id = 201
ORDER BY j.job_id;


-- C3: View applications for a job
-- Used in: Client "View Applications"
-- Requirement: Multi-table JOIN

SELECT
    a.student_id,
    s.student_id AS student_code,
    u.name AS student_name,
    a.application_no,
    a.status,
    a.apply_date
FROM Application a
JOIN Student s ON a.student_id = s.user_id
JOIN User u ON s.user_id = u.user_id
WHERE a.job_id = 3
ORDER BY a.apply_date;


-- C4: View applicant skills for a job
-- Used in: Client application review
-- Requirement: Multi-table JOIN

SELECT DISTINCT
    a.student_id,
    u.name AS student_name,
    sk.skill_name
FROM Application a
JOIN Student s ON a.student_id = s.user_id
JOIN User u ON s.user_id = u.user_id
JOIN Takes t ON s.user_id = t.student_id
JOIN University_Course uc ON t.course_code = uc.course_code
JOIN Generic_Course gc ON uc.generic_id = gc.generic_id
JOIN Produces p ON gc.generic_id = p.generic_id
JOIN Skill sk ON p.skill_id = sk.skill_id
WHERE a.job_id = 3
ORDER BY student_name, sk.skill_name;


-- C5: Accept application
-- Used in: Client action (Accept)

UPDATE Application
SET status = 'Accepted'
WHERE student_id = 101
  AND job_id = 3
  AND status = 'Pending';


-- C6: Reject application
-- Used in: Client action (Reject)

UPDATE Application
SET status = 'Rejected'
WHERE student_id = 102
  AND job_id = 2
  AND status = 'Pending';


-- C7: Employees to pay (current month)
-- Used in: Client payments page
-- Requirement: Analytical / time-based query

SELECT
    a.student_id,
    u.name AS student_name,
    j.job_title,
    p.amount,
    p.status
FROM Payment p
JOIN Application a
    ON p.application_student_id = a.student_id
   AND p.application_job_id = a.job_id
JOIN Job j ON a.job_id = j.job_id
JOIN User u ON a.student_id = u.user_id
WHERE p.client_id = 201
  AND p.payment_month = MONTH(CURRENT_DATE)
  AND p.payment_year = YEAR(CURRENT_DATE);


-- C8: Mark payment as paid
-- Used in: Client payment action

UPDATE Payment
SET status = 'Paid'
WHERE payment_id = 4
  AND status = 'Unpaid';


-- WF2: Client posts a new job (reference workflow SQL)
-- Description:
--   Creates a new job posted by a client.
-- Business rules:
--   - social_contribution_points is NULL initially
--   - Points are later assigned by University_Admin
-- Notes:
--   - Actual implementation handled via procedure in procedures.sql

-- Reference SQL
INSERT INTO Job (
    job_title,
    job_description,
    salary,
    social_contribution_points,
    client_id
)
VALUES (
    'Event Assistant',
    'Assist in organizing a university event',
    15000,
    NULL,
    201
);



-- UNIVERSITY ADMIN:::

-- UA1: Load university admin profile

SELECT
    u.user_id,
    u.name,
    u.email,
    un.university_id,
    un.name AS university_name
FROM User u
JOIN University_Admin ua ON u.user_id = ua.user_id
JOIN University un ON ua.university_id = un.university_id
WHERE u.user_id = 301;


-- UA2: Jobs pending social contribution points

SELECT
    j.job_id,
    j.job_title,
    c.company_name,
    j.salary
FROM Job j
JOIN Client c ON j.client_id = c.user_id
WHERE j.social_contribution_points IS NULL
ORDER BY j.job_id;


-- UA3: Assign or update social contribution points
-- Description: Sets social contribution points for a job.
-- Used for both initial assignment and later edits.

UPDATE Job
SET social_contribution_points = 9
WHERE job_id = 3;


-- UA4: Students of my university and their accepted jobs
-- Requirement: Multi-table JOIN

SELECT DISTINCT
    u.name AS student_name,
    s.student_id AS student_code,
    j.job_title,
    c.company_name,
    a.status
FROM University_Admin ua
JOIN University un
    ON ua.university_id = un.university_id
JOIN University_Course uc
    ON uc.university_id = un.university_id
JOIN Takes t
    ON t.course_code = uc.course_code
JOIN Student s
    ON t.student_id = s.user_id
JOIN User u
    ON s.user_id = u.user_id
JOIN Application a
    ON s.user_id = a.student_id
JOIN Job j
    ON a.job_id = j.job_id
JOIN Client c
    ON j.client_id = c.user_id
WHERE ua.user_id = 303
  AND a.status = 'Accepted'
ORDER BY student_name;