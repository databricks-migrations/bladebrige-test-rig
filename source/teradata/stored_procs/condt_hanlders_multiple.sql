--
-- Multiple Condition Handlers In a Stored Procedure
--
CREATE PROCEDURE spSample10()
BEGIN
    DECLARE EmpCount INTEGER;
    DECLARE CONTINUE HANDLER
    FOR SQLSTATE '42000'
    H1:BEGIN

    -- Statement_10_1
    UPDATE Employee
    SET Ename = 'John';

    -- Suppose column Ename has been dropped.
    -- Statement_10_1 returns SQLSTATE code '52003' that is
    -- defined for the handler within the
    -- block that activates this handler.

    -- Statement_10_2
    INSERT INTO Proc_Error_Table (:SQLSTATE,
        CURRENT_TIMESTAMP, 'spSample10', 'Failed to Insert Row');
    END H1;

    DECLARE EXIT HANDLER
        FOR SQLSTATE '52003'
    INSERT INTO Proc_Error_Table (:SQLSTATE,
        CURRENT_TIMESTAMP, 'spSample10', 'Column does not exist');

    DECLARE CONTINUE HANDLER
        FOR SQLWARNING
    INSERT INTO Proc_Error_Table (:SQLSTATE,
        CURRENT_TIMESTAMP, 'spSample10', 'Warning has occurred');
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND
    INSERT INTO Proc_Error_Table (:SQLSTATE,
    CURRENT_TIMESTAMP, 'spSample10', 'No data found');
    -- Statement_10_3
    UPDATE Employee
    SET Salary_Amount = 10000
    WHERE Employee_Number = 1001;

    -- Statement_10_4
    INSERT INTO EmpNames VALUES (1002, 'Thomas');

    -- Suppose table EmpNames has been dropped.
    -- Statement_10_4 returns SQLSTATE '42000' that is
    -- handled.
    -- Statement_10_5
    UPDATE Employee
    SET Salary_Amount = 10000
    WHERE Employee_Number = 1003;

    -- Statement_10_6
    SELECT COUNT(*) INTO EmpCount FROM Employee SAMPLE 5;
    -- Suppose table Employee has only three rows.
    -- Statement_10_6 returns SQLSTATE 'T7473' that is
    -- handled by SQLWARNING handler.
    -- Statement_10_7
    DELETE Employee WHERE Employee_Number = 1;
    -- Suppose table Employee does not have a row for
    -- Employee_Number = 1. Statement_10_7 returns SQLSTATE
    -- '02000' that is handled by NOT FOUND handler.
END;