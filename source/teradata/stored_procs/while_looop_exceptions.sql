--
-- Example: WHILE Loop Exceptions
--
CREATE PROCEDURE spSample8()
BEGIN
    DECLARE hNumber INTEGER;
    DECLARE CONTINUE HANDLER
    FOR SQLSTATE '42000'
    INSERT INTO Proc_Error_Table
    (:SQLSTATE, CURRENT_TIMESTAMP, 'spSample8',
        'Failed to Insert Row');

    SET hNumber = 1;

    -- Statement_8_1
    UPDATE Employee SET Salary_Amount = 10000
    WHERE Employee_Number = 1001;

    WHILE hNumber < 10
    DO
    -- Statement_8_2
    INSERT INTO EmpNames VALUES (1002, 'Thomas');
    SET hNumber = hNumber + 1;
    END WHILE;
    -- If the EmpNames table had been dropped,
    -- Statement_8_2 returns an SQLSTATE code of         -- '42000' that is handled.

    -- Statement_8_3
    UPDATE Employee
    SET Salary_Amount = 10000
    WHERE Employee_Number = 1003;
END;

--
-- Using preceding Stored Proc
--* INSERT INTO Department VALUES ('10', 'Development');
--*     
--* UPDATE Employee
--*     SET Salary_Amount = 10000
--*     WHERE Employee_Number = 1000;
--*     
--* CALL spSample8();