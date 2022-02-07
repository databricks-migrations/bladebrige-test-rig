/** source: https://www.tutorialspoint.com/teradata/teradata_fastexport.htm
*/

-- sample data
-- EmployeeNo  FirstName  LastName  BirthDate
-- 101         Mike       James     1/5/1980
-- 104         Alex       Stuart    11/6/1984
-- 102         Robert     Williams  3/5/1983
-- 105         Robert     James     12/1/1984
-- 103         Peter      Paul      4/1/1983

.LOGTABLE tduser.employee_log;  
.LOGON 192.168.1.102/dbc,dbc;  
   DATABASE tduser;  
   .BEGIN EXPORT SESSIONS 2;  
      .EXPORT OUTFILE employeedata.txt  
      MODE RECORD FORMAT TEXT;
      SELECT CAST(EmployeeNo AS CHAR(10)), 
         CAST(FirstName AS CHAR(15)), 
         CAST(LastName AS CHAR(15)), 
         CAST(BirthDate AS CHAR(10))   
      FROM
      Employee;
   .END EXPORT;
.LOGOFF;

-- Executing a FastExport Script
--
-- fexp < employee.fx