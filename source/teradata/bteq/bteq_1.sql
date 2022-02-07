.LOGON 192.168.1.102/dbc,dbc; 
   DATABASE tduser;

   CREATE TABLE employee_bkup ( 
      EmployeeNo INTEGER, 
      FirstName CHAR(30), 
      LastName CHAR(30), 
      DepartmentNo SMALLINT, 
      NetPay INTEGER 
   )
   Unique Primary Index(EmployeeNo);

   .IF ERRORCODE <> 0 THEN .EXIT ERRORCODE;
  
   SELECT * FROM  
   Employee 
   Sample 1; 
   .IF ACTIVITYCOUNT <> 0 THEN .GOTO InsertEmployee;  

   DROP TABLE employee_bkup;
  
   .IF ERRORCODE <> 0 THEN .EXIT ERRORCODE; 
 
   .LABEL InsertEmployee 
   INSERT INTO employee_bkup 
   SELECT a.EmployeeNo, 
      a.FirstName, 
      a.LastName, 
      a.DepartmentNo, 
      b.NetPay 
   FROM  
   Employee a INNER JOIN Salary b 
   ON (a.EmployeeNo = b.EmployeeNo);  

   .IF ERRORCODE <> 0 THEN .EXIT ERRORCODE; 
.LOGOFF; 