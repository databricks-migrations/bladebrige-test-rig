
.BEGIN IMPORT MLOAD TABLES Employee
   .LAYOUT EmployeeLayout;
   .FIELD EmpNum 1 INTEGER;
   .FIELD Fone * (CHAR (10));
   
   .DML LABEL EmployeeUpsertDML
     DO INSERT FOR MISSING UPDATE ROWS;
   UPDATE Employee SET PhoneNo = :Fone WHERE EmpNo = :EmpNum;
   INSERT Employee (EmpNo, PhoneNo) VALUES (:EmpNum, :Fone);

   .IMPORT INFILE employee.txt  
   FORMAT VARTEXT ','
   LAYOUT EmployeeLayout
   APPLY EmployeeUpsertDML;     
.END MLOAD;