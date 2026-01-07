USE workwise;

-- =========================
-- UNIVERSITIES (MULTIPLE)
-- =========================
INSERT INTO University (university_id, name) VALUES
(1, 'BRAC University'),
(2, 'University of Dhaka'),
(3, 'BUET'),
(4, 'North South University');

-- =========================
-- GENERIC COURSES
-- =========================
INSERT INTO Generic_Course (generic_id, name) VALUES
(1, 'Introduction to Programming'),
(2, 'Database Systems'),
(3, 'Statistics'),
(4, 'Communication Skills'),
(5, 'Basic Accounting');

-- =========================
-- UNIVERSITY COURSES
-- =========================
INSERT INTO University_Course (course_code, course_title, university_id, generic_id) VALUES
-- BRAC
('CSE110', 'Programming Language I', 1, 1),
('CSE370', 'Database Systems', 1, 2),
('ENG091', 'Communication Skills', 1, 4),

-- DU
('STA201', 'Statistics I', 2, 3),
('ACC101', 'Accounting Basics', 2, 5),

-- BUET
('CSE101', 'Structured Programming', 3, 1),

-- NSU
('MIS205', 'Database Management', 4, 2);

-- =========================
-- SKILLS
-- =========================
INSERT INTO Skill (skill_id, skill_name, skill_description) VALUES
(1, 'Python', 'Basic programming and scripting'),
(2, 'SQL', 'Database querying'),
(3, 'Excel', 'Spreadsheet data handling'),
(4, 'Communication', 'Customer interaction'),
(5, 'Data Analysis', 'Statistical analysis'),
(6, 'Bookkeeping', 'Basic accounting work');

-- =========================
-- GENERIC COURSE → SKILL
-- =========================
INSERT INTO Produces (generic_id, skill_id) VALUES
(1, 1),
(2, 2),
(3, 5),
(3, 3),
(4, 4),
(5, 6);

-- =========================
-- USERS
-- =========================
INSERT INTO User (user_id, name, email) VALUES
-- Students
(101, 'Rahim Ahmed', 'rahim@bracu.ac.bd'),
(102, 'Nusrat Jahan', 'nusrat@du.ac.bd'),
(103, 'Tanvir Hossain', 'tanvir@buet.ac.bd'),
(104, 'Mehedi Hasan', 'mehedi@northsouth.edu'),

-- Clients
(201, 'Hasan Karim', 'hasan@foodbox.com'),
(202, 'Farzana Islam', 'farzana@techhelpbd.com'),
(203, 'Imran Chowdhury', 'imran@careplus.org'),

-- Admins
(301, 'Dr. Mahbub Hasan', 'mahbub@bracu.ac.bd'),
(302, 'Prof. Salma Akter', 'salma@du.ac.bd'),
(303, 'Dr. Rezaul Karim', 'rezaul@buet.ac.bd');

-- =========================
-- USER PHONES
-- =========================
INSERT INTO User_Phone (user_id, phone) VALUES
(101, '01711111111'),
(102, '01822222222'),
(103, '01933333333'),
(104, '01644444444'),
(201, '01555555555'),
(202, '01466666666'),
(203, '01377777777');

-- =========================
-- STUDENTS
-- =========================
INSERT INTO Student (user_id, student_id, major) VALUES
(101, 'BRAC-STU-001', 'Computer Science'),
(102, 'DU-STU-014', 'Statistics'),
(103, 'BUET-STU-009', 'CSE'),
(104, 'NSU-STU-021', 'MIS');

-- =========================
-- UNIVERSITY ADMINS
-- =========================
INSERT INTO University_Admin (user_id, university_id) VALUES
(301, 1),
(302, 2),
(303, 3);

-- =========================
-- CLIENTS
-- =========================
INSERT INTO Client (user_id, company_name, industry) VALUES
(201, 'FoodBox', 'Food Delivery'),
(202, 'TechHelp BD', 'IT Services'),
(203, 'CarePlus NGO', 'Social Services');

-- =========================
-- STUDENT TAKES COURSES
-- =========================
INSERT INTO Takes (student_id, course_code, semester, grade) VALUES
(101, 'CSE110', 'Spring 2024', 'A'),
(101, 'CSE370', 'Fall 2024', 'A-'),
(101, 'ENG091', 'Fall 2024', 'B+'),
(102, 'STA201', 'Spring 2024', 'B+'),
(102, 'ACC101', 'Fall 2024', 'A'),
(102, 'ENG091', 'Fall 2024', 'A-'),
(103, 'CSE101', 'Spring 2024', 'A'),
(103, 'STA201', 'Fall 2024', 'B'),
(103, 'ACC101', 'Fall 2024', 'B+'),
(104, 'ACC101', 'Fall 2024', 'A'),
(104, 'MIS205', 'Fall 2024', 'B');

-- =========================
-- JOBS (MOSTLY PART-TIME / ODD JOBS)
-- =========================
INSERT INTO Job (job_id, job_title, job_description, salary, social_contribution_points, admin_id, client_id) VALUES
(1, 'Food Delivery Assistant', 'Part-time food delivery in nearby areas', 12000, 6, 301, 201),
(2, 'Excel Data Entry Helper', 'Evening data entry work (part-time)', 15000, 7, 302, 202),
(3, 'Python Tutor (Weekend)', 'Teach Python basics to school students', 18000, 9, 301, 202),
(4, 'NGO Field Survey Helper', 'Collect survey data on weekends', 10000, 10, 302, 203),
(5, 'Bookkeeping Assistant', 'Part-time accounting support', 16000, 8, 303, 203);

-- =========================
-- JOB → SKILL REQUIREMENTS
-- =========================
INSERT INTO Requires (job_id, skill_id) VALUES
(1, 4),
(2, 3),
(2, 4),
(3, 1),
(3, 4),
(4, 4),
(4, 5),
(5, 6),
(5, 3);

-- =========================
-- APPLICATIONS
-- =========================
-- INSERT INTO Application (student_id, job_id, application_no, apply_date, status) VALUES
-- (101, 1, 1, '2025-01-05', 'Pending'),
-- (101, 3, 2, '2025-01-07', 'Pending'),
-- (102, 2, 1, '2025-01-06', 'Pending'),
-- (103, 5, 1, '2025-01-08', 'Pending'),
-- (104, 4, 1, '2025-01-09', 'Pending');

-- =========================
-- PAYMENTS
-- =========================
-- INSERT INTO Payment (payment_id, payment_date, payment_month, payment_year, amount, status,
--                      application_student_id, application_job_id, client_id) VALUES
-- (1, '2025-02-01', 2, 2025, 12000, 'Paid', 101, 1, 201),
-- (2, '2025-02-05', 2, 2025, 10000, 'Paid', 104, 4, 203),
-- (3, '2025-02-05', 2, 2025, 10000, 'Unpaid', 104, 4, 201),
-- (4, CURRENT_DATE, MONTH(CURRENT_DATE), YEAR(CURRENT_DATE), 12000, 'Unpaid', 101, 1, 201);

-- =========================
-- AUDIT LOG (SEED)
-- =========================
-- INSERT INTO AuditLog (log_id, operation_type, entity_name, user_id) VALUES
-- (1, 'INSERT', 'Job', 301),
-- (2, 'INSERT', 'Application', 101),
-- (3, 'INSERT', 'Payment', 203);
