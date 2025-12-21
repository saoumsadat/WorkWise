USE workwise;

/* ============================
   APPLICATION STATUS CONSTRAINT
   ============================ */
ALTER TABLE Application
ADD CONSTRAINT chk_application_status
CHECK (status IN ('Applied', 'Shortlisted', 'Hired', 'Rejected'));

/* ============================
   PAYMENT STATUS CONSTRAINT
   ============================ */
ALTER TABLE Payment
ADD CONSTRAINT chk_payment_status
CHECK (status IN ('Pending', 'Paid', 'Failed'));

/* ============================
   JOB CONSTRAINTS
   ============================ */
ALTER TABLE Job
ADD CONSTRAINT chk_job_salary
CHECK (salary >= 0);

ALTER TABLE Job
ADD CONSTRAINT chk_social_points
CHECK (social_contribution_points BETWEEN 0 AND 10);

/* ============================
   PAYMENT VALUE CONSTRAINTS
   ============================ */
ALTER TABLE Payment
ADD CONSTRAINT chk_payment_amount
CHECK (amount >= 0);

ALTER TABLE Payment
ADD CONSTRAINT chk_payment_month
CHECK (payment_month BETWEEN 1 AND 12);

ALTER TABLE Payment
ADD CONSTRAINT chk_payment_date
CHECK (payment_date BETWEEN 1 AND 31);

/* ============================
   EMAIL FORMAT (BASIC)
   ============================ */
ALTER TABLE User
ADD CONSTRAINT chk_user_email
CHECK (email LIKE '%@%.%');

/* ============================
   GRADE CONSTRAINT
   ============================ */
ALTER TABLE Takes
ADD CONSTRAINT chk_grade
CHECK (grade IN ('A', 'B', 'C', 'D', 'F'));

