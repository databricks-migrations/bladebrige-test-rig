--
-- source: https://docs.teradata.com/r/CeAGk~BNtx~axcR0ed~5kw/qkt9pvPjUNPQbCaRXlerBQ
--
-- Example: Using Dynamic SQL Statements Within a Stored Procedure that Returns a Results Set
--
CREATE PROCEDURE GetEmployeeSalary (
    IN EmpName VARCHAR(100), 
    OUT Salary DEC(10,2)
)
BEGIN
  DECLARE SqlStr VARCHAR(1000);
  DECLARE C1 CURSOR FOR S1;
  SET SqlStr = 'SELECT Salary FROM EmployeeTable WHERE EmpName = ?';
  PREPARE S1 FROM SqlStr;
  OPEN C1 USING EmpName;
  FETCH C1 INTO Salary;
  CLOSE C1;
END;