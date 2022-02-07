--
-- Examples of a CONTINUE Handler
--
CREATE PROCEDURE spSample4()
BEGIN
    DECLARE hNumber INTEGER;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    INSERT INTO Proc_Error_Table
    (:SQLSTATE, CURRENT_TIMESTAMP, 'spSample4',
    'Failed to Insert Row');
    
    -- Statement_4_1
    UPDATE Employee
        SET Salary_Amount = 10000
        WHERE Employee_Number = 1001;
        
    -- Statement_4_2
    INSERT INTO EmpNames VALUES (1002, 'Thomas');
        
    -- If the EmpNames table had been dropped, Statement_4_2
    -- returns SQLEXCEPTION that is handled.
        
    -- Statement_4_3
    UPDATE Employee
        SET Salary_Amount = 10000
        WHERE Employee_Number = 1003;
END;

--
-- Using the preceding sp
--* INSERT INTO Department VALUES ('10', 'Development');
--*     
--* UPDATE Employee SET Salary_Amount = 10000
--*     WHERE Employee_Number = 1000;
--* 
--* CALL spSample4();