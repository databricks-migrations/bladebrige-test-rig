LOGON 192.168.1.102/dbc,dbc;  
   DATABASE tduser;  
   BEGIN LOADING tduser.Employee_Stg  
      ERRORFILES Employee_ET, Employee_UV  
      CHECKPOINT 10;  
      SET RECORD VARTEXT ",";  
      DEFINE in_EmployeeNo (VARCHAR(10)), 
         in_FirstName (VARCHAR(30)), 
         in_LastName (VARCHAR(30)), 
         in_BirthDate (VARCHAR(10)), 
         in_JoinedDate (VARCHAR(10)), 
         in_DepartmentNo (VARCHAR(02)), 
         FILE = employee.txt;
      INSERT INTO Employee_Stg (
         EmployeeNo,
         FirstName,
         LastName,
         BirthDate,
         JoinedDate, 
         DepartmentNo
      ) 
      VALUES (  
         :in_EmployeeNo, 
         :in_FirstName, 
         :in_LastName, 
         :in_BirthDate (FORMAT 'YYYY-MM-DD'), 
         :in_JoinedDate (FORMAT 'YYYY-MM-DD'),
         :in_DepartmentNo
      ); 
   END LOADING;  
LOGOFF;