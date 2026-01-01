-- =========================================================
-- File: triggers.sql
-- Project: WorkWise
-- Description:
--   Minimal audit logging using database triggers.
-- =========================================================

DELIMITER $$

CREATE TRIGGER trg_application_audit
AFTER UPDATE ON Application
FOR EACH ROW
BEGIN
    -- Log only meaningful changes
    IF OLD.status <> NEW.status THEN
        INSERT INTO AuditLog (
            operation_type,
            entity_name,
            user_id,
            timestamp
        )
        VALUES (
            'UPDATE',
            'Application',
            (
                SELECT client_id
                FROM Job
                WHERE job_id = NEW.job_id
            ),
            CURRENT_TIMESTAMP
        );
    END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_application_insert_audit
AFTER INSERT ON Application
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (
        operation_type,
        entity_name,
        user_id,
        timestamp
    )
    VALUES (
        'INSERT',
        'Application',
        NEW.student_id,
        CURRENT_TIMESTAMP
    );
END$$

DELIMITER ;


-- JOB


DELIMITER $$

CREATE TRIGGER trg_job_insert_audit
AFTER INSERT ON Job
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (
        operation_type,
        entity_name,
        user_id,
        timestamp
    )
    VALUES (
        'INSERT',
        'Job',
        NEW.client_id,
        CURRENT_TIMESTAMP
    );
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_job_update_audit
AFTER UPDATE ON Job
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (
        operation_type,
        entity_name,
        user_id,
        timestamp
    )
    VALUES (
        'UPDATE',
        'Job',
        NEW.admin_id,
        CURRENT_TIMESTAMP
    );
END$$

DELIMITER ;


-- PAYMENT


DELIMITER $$

CREATE TRIGGER trg_payment_insert_audit
AFTER INSERT ON Payment
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (
        operation_type,
        entity_name,
        user_id,
        timestamp
    )
    VALUES (
        'INSERT',
        'Payment',
        NEW.client_id,
        CURRENT_TIMESTAMP
    );
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_payment_update_audit
AFTER UPDATE ON Payment
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (
        operation_type,
        entity_name,
        user_id,
        timestamp
    )
    VALUES (
        'UPDATE',
        'Payment',
        NEW.client_id,
        CURRENT_TIMESTAMP
    );
END$$

DELIMITER ;