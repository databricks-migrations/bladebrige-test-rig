.Logtable Logtable002;           
.Logon tdpx/user,pwd;            
.Begin Import Mload              
   tables                        
      Employee,                  
      History;                   

.Layout Transaction;             
  .Field TransCode * Char(3);    
  .Field EmpNo     * Smallint;   
  .Field DeptNo    * Smallint;   

.DML Label Updates;              
Update Employee                  
     set DeptNo = :DeptNo        
     where EmpNo  = :EmpNo;      

.DML Label Deletes;              
Delete from Employee             
     where EmpNo  = :EmpNo;    
       
.DML Label Inserts;              
Insert into History.*;           
                                 
.Import Infile INPUT             
   Layout Transaction            
   Apply Updates where           
   TransCode = 'TRA'             
Apply Deletes where              
   TransCode = 'BYE'             
Apply Inserts;                   
.End Mload;                      
.Logoff; 