--
-- Example: Exceptions Raised By an IF Statement
-- 
CREATE PROCEDURE spSample9()
BEGIN
    DECLARE hNumber, NumberAffected INTEGER;
    DECLARE CONTINUE HANDLER
    FOR SQLSTATE '22012'
    INSERT INTO Proc_Error_Table
    (:SQLSTATE, CURRENT_TIMESTAMP, 'spSample9',
    'Failed Data Handling');

    SET hNumber = 100;

    -- Statement_9_1
    UPDATE Employee SET Salary_Amount = 10000
        WHERE Employee_Number BETWEEN 1001 AND 1010;

    SET NumberAffected = ACTIVITY_COUNT;

    IF hNumber/NumberAffected < 10 THEN

    -- If the UPDATE in Statement_9_1 results in 0 rows
    -- being affected, the IF condition raises an
    -- exception with SQLSTATE '22012' that is
    -- handled.

    -- Statement_9_2
    INSERT INTO data_table (NumberAffected, 'DATE');

    SET hNumber = hNumber + 1;

    END IF;

    -- Statement_9_3
    UPDATE Employee
        SET Salary_Amount = 10000
        WHERE Employee_Number = 1003;
END;


--
-- Using preceding example

-- INSERT INTO Department VALUES ('10', 'Development');
--     
-- UPDATE Employee
-- SET Salary_Amount = 10000
-- WHERE Employee_Number = 1000;
-- 
-- CALL spSample9();