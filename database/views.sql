-- ---------------------------------------------------------
-- View Code: V-S1
-- View Name: v_student_applications
-- Used By: Student
-- Description:
--   Provides a consolidated view of all job applications
--   submitted by students, including job title, company,
--   application status, and application date.
-- Source Queries:
--   Q6 (Student application history)
-- ---------------------------------------------------------

CREATE VIEW v_student_applications AS
SELECT
    a.student_id,
    a.application_no,
    a.apply_date,
    a.status,
    j.job_id,
    j.job_title,
    c.company_name
FROM Application a
JOIN Job j
    ON a.job_id = j.job_id
JOIN Client c
    ON j.client_id = c.user_id;



-- ---------------------------------------------------------
-- View Code: V-S2
-- View Name: v_student_skill_profile
-- Used By: Student
-- Description:
--   Provides a detailed skill profile for students,
--   including skill information and the university and
--   generic courses through which the skill was acquired.
-- Source Queries:
--   Q2A (Student skills with course lineage)
-- ---------------------------------------------------------

CREATE VIEW v_student_skill_profile AS
SELECT DISTINCT
    t.student_id,
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
    ON p.skill_id = sk.skill_id;



-- ---------------------------------------------------------
-- View Code: V-C2
-- View Name: v_client_payments
-- Used By: Client
-- Description:
--   Provides a consolidated view of employee payment status
--   for accepted job applications, including job and student
--   information, grouped by payment period.
-- Source Queries:
--   C7 (Client employees to pay - current month)
-- ---------------------------------------------------------

CREATE VIEW v_client_payments AS
SELECT
    p.payment_id,
    p.client_id,
    a.student_id,
    u.name AS student_name,
    a.job_id,
    j.job_title,
    p.amount,
    p.status,
    p.payment_month,
    p.payment_year
FROM Payment p
JOIN Application a
    ON p.application_student_id = a.student_id
   AND p.application_job_id = a.job_id
JOIN Job j
    ON a.job_id = j.job_id
JOIN User u
    ON a.student_id = u.user_id;