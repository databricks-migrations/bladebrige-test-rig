.LOGTABLE tduser.Employee_log;  
.LOGON 192.168.1.102/dbc,dbc; 
   .BEGIN MLOAD TABLES Employee_Stg;  
      .LAYOUT Employee;  
      .FIELD in_EmployeeNo * VARCHAR(10);  
      .FIELD in_FirstName * VARCHAR(30); 
      .FIELD in_LastName * VARCHAR(30);  
      .FIELD in_BirthDate * VARCHAR(10); 
      .FIELD in_JoinedDate * VARCHAR(10);  
      .FIELD in_DepartmentNo * VARCHAR(02);

      .DML LABEL EmpLabel; 
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
         :in_Lastname,
         :in_BirthDate,
         :in_JoinedDate,
         :in_DepartmentNo
      );
      .IMPORT INFILE employee.txt  
      FORMAT VARTEXT ','
      LAYOUT Employee
      APPLY EmpLabel;  
   .END MLOAD;  
LOGOFF;