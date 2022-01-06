--
-- source: https://docs.teradata.com/r/CeAGk~BNtx~axcR0ed~5kw/qkt9pvPjUNPQbCaRXlerBQ
--

-- FIXME: Only subset of stored proc types included here. 
--        Need deep dive on what type of stored Procs can be supported on Databricks 

--
-- Example: Static Form of the DECLARE CURSOR Statement
--
CREATE PROCEDURE Sample_p (INOUT c INTEGER)
       DYNAMIC RESULT SETS 2
    BEGIN
       DECLARE cur1 CURSOR WITH RETURN ONLY FOR
          SELECT * FROM m1;
       DECLARE cur2 CURSOR WITH RETURN ONLY FOR
          SELECT * FROM m2 WHERE m2.a > c;
       SET c = c +1;
       OPEN cur1;
       OPEN cur2;
    END;


--
-- Example: Dynamic Form of the DECLARE Statement
--
CREATE PROCEDURE sp1 (IN SqlStr VARCHAR(50), IN a INT)
   DYNAMIC RESULT SETS 1
   BEGIN
     DECLARE c1 CURSOR WITH RETURN ONLY FOR s1;
     PREPARE s1 FROM SqlStr;
     OPEN c1 USING a;
   END;


--
-- Example: Using Dynamic SQL Statements With an EXECUTE IMMEDIATE Statement
--
CREATE PROCEDURE new_sales_table (my_table VARCHAR(30),
                                       my_database VARCHAR(30))
BEGIN
  DECLARE sales_columns VARCHAR(128)
     DEFAULT '(item INTEGER, price DECIMAL(8,2) , 
                 sold INTEGER)' ;
DECLARE sqlstr VARCHAR(500);
SET sqlstr = 'CREATE TABLE ' || my_database || 
                '.' || my_table || sales_columns ;
EXECUTE IMMEDIATE sqlstr;
END;


--
-- Example: Using Dynamic SQL Statements With a CALL Statement
--
CREATE PROCEDURE new_sales_table (my_table VARCHAR(30), my_database VARCHAR(30))
BEGIN
  DECLARE sales_columns VARCHAR(128)
        DEFAULT '(item INTEGER, price DECIMAL(8,2) , sold INTEGER)' ;
   CALL DBC.SysExecSQL('CREATE TABLE ' || my_database || '.' || my_table || sales_columns) ;
END;

--
-- Example: Using Dynamic SQL Statements Within a Stored Procedure that Returns a Results Set
--
CREATE PROCEDURE GetEmployeeSalary
(IN EmpName VARCHAR(100), OUT Salary DEC(10,2))
BEGIN
  DECLARE SqlStr VARCHAR(1000);
  DECLARE C1 CURSOR FOR S1;
  SET SqlStr = 'SELECT Salary FROM EmployeeTable WHERE EmpName = ?';
  PREPARE S1 FROM SqlStr;
  OPEN C1 USING EmpName;
  FETCH C1 INTO Salary;
  CLOSE C1;
END;


--
-- Sample Stored Procedures
--

-- Sample Tables

--DDL defines the accounts table:
CREATE MULTISET TABLE sampleDb.tAccounts, NO FALLBACK,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL
     (
     BranchId INTEGER,
     AccountCode INTEGER,
     Balance DECIMAL(10,2),
         AccountNumber INTEGER,
         Interest DECIMAL(10,2))
PRIMARY INDEX (AccountNumber) ;

--DDL defines the error table:
CREATE MULTISET TABLE sampleDb.Proc_Error_Tbl ,NO FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL
     (
     sql_state CHAR(5) CHARACTER SET LATIN CASESPECIFIC,
     time_stamp TIMESTAMP(6),
     Add_branch CHAR(15) CHARACTER SET LATIN CASESPECIFIC,
     msg VARCHAR(40) CHARACTER SET LATIN CASESPECIFIC)
PRIMARY INDEX ( sql_state );


--
-- example: AddBranch Stored Proc
-- This CREATE PROCEDURE statement creates a procedure named AddBranch that supports the internal functions of a bank:
-- 
-- Capture and add details of the new branch to the table tBranch.
-- Assign a BranchId to a new branch.
-- Add details of new accounts of a branch to the table tAccounts.
-- Update balances and interest in the accounts contained in the table tAccounts for the new branch.
CREATE PROCEDURE AddBranch (
                       OUT oBranchId INTEGER,
                        IN iBranchName CHAR(15),
                        IN iBankCode INTEGER,
                        IN iStreet VARCHAR(30),
                        IN iCity VARCHAR(30),
                        IN iState VARCHAR(30),
                        IN iZip INTEGER
                        )
Lmain: BEGIN
     -- Lmain is the label for the main compound statement
  
  -- Local variable declarations follow
   DECLARE hMessage CHAR(50) DEFAULT
              'Error: Database Operation ...';
   DECLARE hNextBranchId INTEGER;
   DECLARE hAccountNumber INTEGER DEFAULT 10;
   DECLARE hBalance INTEGER;
                
     -- Condition Handler Declarations
   DECLARE CONTINUE HANDLER FOR SQLSTATE '21000'
      
   -- Label compoun statements within handlers as HCS1 etc.
   HCS1: BEGIN
         INSERT INTO Proc_Error_Tbl
       (:SQLSTATE, CURRENT_TIMESTAMP, 'AddBranch', hMessage);
      END HCS1;
   DECLARE CONTINUE HANDLER FOR SQLSTATE '42000'
      HCS2: BEGIN
         SET hMessage = 'Table Not Found ... ';
         INSERT INTO Proc_Error_Tbl
         (:SQLSTATE, CURRENT_TIMESTAMP, 'AddBranch', hMessage);
      END HCS2;
   -- Get next branch-id from tBranchId table
   CALL GetNextBranchId  hNextBranchId);
   -- Add new branch to tBranch table
   INSERT INTO tBranch ( BranchId, BankId, BranchName, Street, City,  State, Zip)
   VALUES ( hNextBranchId, iBankId, iBranchName, iStreet, iCity, iState, iZip);
  -- Assign branch number to the output parameter;
  -- the value is returned to the calling procedure
   SET oBranchId = hNextBranchId;
   -- Insert the branch number and name in tDummy table
   INSERT INTO tDummy VALUES(hNextBranchId, iBranchName);
   -- Insert account numbers pertaining to the current branch
   SELECT max(AccountNumber) INTO hAccountNumber FROM tAccounts;
   WHILE (hAccountNumber <= 1000) 
   DO
      INSERT INTO tAccounts (BranchId, AccountNumber)
     VALUES ( hNextBranchId, hAccountNumber);
       -- Advance to next account number
      SET hAccountNumber = hAccountNumber + 1;
   END WHILE;
    
  -- Update balance in each account of the current branch-id
   SET hAccountNumber = 1;
   L1: LOOP
       UPDATE tAccounts SET Balance = 100000
         WHERE BranchId = hNextBranchId AND
          AccountNumber = hAccountNumber;
       -- Generate account number
       SET hAccountNumber = hAccountNumber + 1;
       -- Check if through with all the accounts
       IF (hAccountNumber > 1000) THEN
        LEAVE L1;
       END IF;
   END LOOP L1;
   -- Update Interest for each account of the current branch-id
   FOR fAccount AS cAccount CURSOR FOR
   -- since Account is a reserved word
      SELECT Balance AS aBalance FROM tAccounts
         WHERE BranchId = hNextBranchId
   DO
   -- Update interest for each account
      UPDATE tAccounts SET Interest = fAccount.aBalance * 0.10
         WHERE CURRENT OF cAccount;
   END FOR;
  -- Inner nested compound statement begins
  Lnest: BEGIN
    -- local variable declarations in inner compound statement
   DECLARE Account_Number, counter INTEGER;
   DECLARE Acc_Balance DECIMAL (10,2);
   -- cursor declaration in inner compound statement
   DECLARE acc_cur CURSOR FOR
         SELECT AccountCode, Balance FROM tAccounts
         ORDER BY AccountNumber;
  -- condition handler declarations in inner compound statement
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    HCS3: BEGIN
              DECLARE h_Message VARCHAR(50);
              DECLARE EXIT HANDLER FOR SQLWARNING
                 HCS4: BEGIN
                     SET h_Message = 'Requested sample is larger
                      than table rows';
                     INSERT INTO Proc_Error_Tbl (:SQLSTATE,
          CURRENT_TIMESTAMP, 'AddBranch', h_Message);
                 END HCS4;
               
       SET h_Message = 'Data not Found ...';
             INSERT INTO Proc_Error_Tbl (:SQLSTATE,
         CURRENT_TIMESTAMP, 'AddBranch', h_Message);
         SELECT COUNT(*) INTO :counter FROM Proc_Error_Tbl
         SAMPLE 10;
       -- Raises a warning. This is a condition raised by
       -- a handler action statement. This is handled.
        END HCS3;
        DELETE FROM tDummy1;
        -- Raises “no data found” warning
        OPEN acc_cur;
        L2: REPEAT
        BEGIN
            FETCH acc_cur INTO Account_code, Acc_Balance;
            CASE
              WHEN (Account_code  <= 1000) THEN
               INSERT INTO dummy1 (Account_code, Acc_Balance);
               ELSE
               LEAVE L3;
            END CASE;
        END;
        UNTIL (SQLCODE = 0)
        END REPEAT L2;
    CLOSE acc_cur;
  END Lnest; --- end of inner nested block.
END Lmain; -- This comment is part of stored procedure body
-- End-of-Create-Procedure.


--
-- Example: Using a Condition Name and Its Associated SQLSTATE Value in a Handler
-- 
CREATE PROCEDURE condsp1 (INOUT IOParam2 INTEGER,
                            OUT OParam3 INTEGER)
cs1: BEGIN
    DECLARE divide_by_zero CONDITION FOR SQLSTATE '22012';
    DECLARE EXIT HANDLER
        FOR divide_by_zero, SQLSTATE '42000'
        SET OParam3 = 0;
    SET IOParam2 = 0;
    SET OParam3 = 20/IOParam2;    /* raises exception 22012 */
END cs1;


--
-- Example: Associating a Handler Action with Multiple Condition Names
--

CREATE PROCEDURE condsp2 (INOUT IOParam2 INTEGER,
                             OUT OParam3 CHAR(30))
   Cs1: BEGIN
      DECLARE divide_by_zero CONDITION FOR SQLSTATE '22012';
      DECLARE table_does_not_exist CONDITION FOR SQLSTATE '42000';
      DECLARE CONTINUE HANDLER
         FOR divide_by_zero, table_does_not_exist
            SET OParam3 = 0;
      SET IOParam2=0;
      SET OParam3 = 20/IOParam2;    /* raises exception 22012 */
      INSERT notab VALUES (IOParam2 + 20); /* raises exception 42000 */
   END Cs1;
   
--
-- Example: Reusing the SQLSTATE Code
--
CREATE PROCEDURE spSample (OUT po1 VARCHAR(50),
                            OUT po2 VARCHAR(50))
BEGIN
    DECLARE i INTEGER DEFAULT 0;
    L1: BEGIN
        DECLARE var1 VARCHAR(25) DEFAULT 'ABCD';
        DECLARE CONTINUE HANDLER FOR SQLSTATE '42000'
            SET po1 = "Table does not exist in L1";
        INSERT INTO tDummy (10, var1);
        -- Table does not exist.
        L2: BEGIN
            DECLARE var1 VARCHAR(25) DEFAULT 'XYZ';
            DECLARE CONTINUE HANDLER FOR SQLSTATE '42000'
                SET po2 = "Table does not exist in L2";
            INSERT INTO tDummy (i, var1);
        -- Table does not exist.
        END L2;
    END L1;
END;

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
INSERT INTO Department VALUES ('10', 'Development');
    
UPDATE Employee
    SET Salary_Amount = 10000
    WHERE Employee_Number = 1000;
    
CALL spSample8();

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
INSERT INTO Department VALUES ('10', 'Development');
    
UPDATE Employee
SET Salary_Amount = 10000
WHERE Employee_Number = 1000;

CALL spSample9();


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
INSERT INTO Department VALUES ('10', 'Development');
    
UPDATE Employee SET Salary_Amount = 10000
    WHERE Employee_Number = 1000;

CALL spSample4();