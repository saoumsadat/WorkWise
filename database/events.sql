-- ---------------------------------------------------------
-- Event Code: E-1
-- Event Name: MonthlyPaymentGeneration
-- Description:
--   Runs monthly to generate unpaid payment records
--   for accepted applications.
-- ---------------------------------------------------------

DELIMITER $$

CREATE EVENT MonthlyPaymentGeneration
ON SCHEDULE
    EVERY 1 MONTH
    STARTS (DATE_FORMAT(CURRENT_DATE, '%Y-%m-01'))
DO
BEGIN
    CALL GenerateMonthlyPayments();
END$$

DELIMITER ;