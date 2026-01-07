-- ---------------------------------------------------------
-- Procedure Code: P-S1
-- Procedure Name: ApplyOrReapplyJob
-- Used By: Student
-- Description:
--   Allows a student to apply for a job.
--   If previously rejected, resets status to Pending.
-- Business Rules:
--   - One application per student per job
--   - Reapply allowed only if status = 'Rejected'
-- ---------------------------------------------------------

DELIMITER $$

CREATE PROCEDURE ApplyOrReapplyJob (
    IN p_student_id INT,
    IN p_job_id INT
)
BEGIN
    /* -----------------------------------------
       Eligibility Check (student must have ALL
       required skills for the job)
    ----------------------------------------- */
    IF EXISTS (
        SELECT 1
        FROM Requires r
        WHERE r.job_id = p_job_id
          AND NOT EXISTS (
              SELECT 1
              FROM v_student_skill_profile s
              WHERE s.student_id = p_student_id
                AND s.skill_id = r.skill_id
          )
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Student is not eligible for this job';
    END IF;

    /* -----------------------------------------
       Case 1: No existing application → apply
    ----------------------------------------- */
    IF NOT EXISTS (
        SELECT 1
        FROM Application
        WHERE student_id = p_student_id
          AND job_id = p_job_id
    ) THEN

        INSERT INTO Application (
            student_id,
            job_id,
            application_no,
            apply_date,
            status
        )
        VALUES (
            p_student_id,
            p_job_id,
            1,
            CURRENT_DATE,
            'Pending'
        );

    /* -----------------------------------------
       Case 2: Previously rejected → reapply
    ----------------------------------------- */
    ELSEIF EXISTS (
        SELECT 1
        FROM Application
        WHERE student_id = p_student_id
          AND job_id = p_job_id
          AND status = 'Rejected'
    ) THEN

        UPDATE Application
        SET
            status = 'Pending',
            apply_date = CURRENT_DATE
        WHERE student_id = p_student_id
          AND job_id = p_job_id;

    END IF;
END$$

DELIMITER ;


-- ---------------------------------------------------------
-- Procedure Code: P-C1
-- Procedure Name: ReviewApplication
-- Used By: Client
-- Description:
--   Allows a client to accept or reject a student application.
-- Business Rules:
--   - Only Pending applications can be reviewed
--   - Status can transition only to Accepted or Rejected
-- ---------------------------------------------------------

DELIMITER $$

CREATE PROCEDURE ReviewApplication (
    IN p_student_id INT,
    IN p_job_id INT,
    IN p_decision VARCHAR(10)
)
BEGIN
    -- Accept application
    IF p_decision = 'Accepted' THEN

        -- Update status (only if Pending)
        UPDATE Application
        SET status = 'Accepted'
        WHERE student_id = p_student_id
          AND job_id = p_job_id
          AND status = 'Pending';

        -- Create payment for current month if not exists
        INSERT INTO Payment (
            application_student_id,
            application_job_id,
            client_id,
            amount,
            status,
            payment_month,
            payment_year
        )
        SELECT
            a.student_id,
            a.job_id,
            j.client_id,
            j.salary,
            'Unpaid',
            MONTH(CURRENT_DATE),
            YEAR(CURRENT_DATE)
        FROM Application a
        JOIN Job j
            ON a.job_id = j.job_id
        WHERE a.student_id = p_student_id
          AND a.job_id = p_job_id
          AND a.status = 'Accepted'
          AND NOT EXISTS (
              SELECT 1
              FROM Payment p
              WHERE p.application_student_id = a.student_id
                AND p.application_job_id = a.job_id
                AND p.payment_month = MONTH(CURRENT_DATE)
                AND p.payment_year = YEAR(CURRENT_DATE)
          );

    -- Reject application
    ELSEIF p_decision = 'Rejected' THEN

        UPDATE Application
        SET status = 'Rejected'
        WHERE student_id = p_student_id
          AND job_id = p_job_id
          AND status = 'Pending';

    END IF;
END$$

DELIMITER ;



-- ---------------------------------------------------------
-- Procedure Code: P-C2
-- Procedure Name: MarkPaymentPaid
-- Used By: Client
-- Description:
--   Marks a payment as paid by the client.
-- Business Rules:
--   - Only Unpaid payments can be marked as Paid
-- ---------------------------------------------------------

DELIMITER $$

CREATE PROCEDURE MarkPaymentPaid (
    IN p_payment_id INT
)
BEGIN
    UPDATE Payment
    SET
        status = 'Paid',
        payment_date = CURRENT_DATE
    WHERE payment_id = p_payment_id
      AND status = 'Unpaid';
END$$

DELIMITER ;


-- ---------------------------------------------------------
-- Procedure Code: P-C3
-- Procedure Name: PostJob
-- Used By: Client
-- Description:
--   Allows a client to post a new job.
-- Business Rules:
--   - Job is linked to the client
--   - social_contribution_points is NULL initially
-- ---------------------------------------------------------

DELIMITER $$

CREATE PROCEDURE PostJob (
    IN p_client_id INT,
    IN p_job_title VARCHAR(255),
    IN p_job_description TEXT,
    IN p_salary DECIMAL(10,2)
)
BEGIN
    INSERT INTO Job (
        job_title,
        job_description,
        salary,
        social_contribution_points,
        client_id
    )
    VALUES (
        p_job_title,
        p_job_description,
        p_salary,
        NULL,
        p_client_id
    );
END$$

DELIMITER ;


-- ---------------------------------------------------------
-- Procedure Code: P-E1
-- Procedure Name: GenerateMonthlyPayments
-- Used By: Scheduled Event
-- Description:
--   Generates unpaid monthly payment records for all
--   accepted applications if not already present.
-- ---------------------------------------------------------

DELIMITER $$

CREATE PROCEDURE GenerateMonthlyPayments ()
BEGIN
    INSERT INTO Payment (
        application_student_id,
        application_job_id,
        client_id,
        amount,
        status,
        payment_month,
        payment_year
    )
    SELECT
        a.student_id,
        a.job_id,
        j.client_id,
        j.salary,
        'Unpaid',
        MONTH(CURRENT_DATE),
        YEAR(CURRENT_DATE)
    FROM Application a
    JOIN Job j
        ON a.job_id = j.job_id
    WHERE a.status = 'Accepted'
      AND NOT EXISTS (
          SELECT 1
          FROM Payment p
          WHERE p.application_student_id = a.student_id
            AND p.application_job_id = a.job_id
            AND p.payment_month = MONTH(CURRENT_DATE)
            AND p.payment_year = YEAR(CURRENT_DATE)
      );
END$$

DELIMITER ;