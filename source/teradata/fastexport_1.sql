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