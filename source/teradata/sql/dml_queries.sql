--
-- source: https://www.tutorialspoint.com/teradata/teradata_data_manipulation.htm


--
-- Uncommon Single row inserts
INSERT INTO schema1.dml_test_table1 (
   EmployeeNo, 
   FirstName, 
   LastName, 
   BirthDate, 
   JoinedDate, 
   DepartmentNo 
)
VALUES ( 
   101, 
   'Mike', 
   'James', 
   '1980-01-05', 
   '2005-03-27', 
   01
);


--
-- Uncommon Single row inserts

INSERT INTO target_schema.dml_test_table2 -- This is silver layer table
( 
   EmployeeNo, 
   FirstName, 
   LastName, 
   BirthDate, 
   JoinedDate, 
   DepartmentNo 
) 
SELECT 
   EmployeeNo, 
   FirstName, 
   LastName, 
   BirthDate, 
   JoinedDate,
   DepartmentNo 
FROM  
   source_schema.scource_table -- This is raw/bronze layer table
;


--
-- Update
UPDATE target_schema.dml_test_table3 
SET DepartmentNo = 03 
WHERE EmployeeNo = 101;

--
-- Deletes
DELETE FROM target_schema.dml_test_table4 
WHERE EmployeeNo = 101;



--
-- Teradata Upsert / Merge
-- source: https://dbmstutorials.com/random_teradata/teradata-upsert.html

-- Test Tables
--Table 1
CREATE MULTISET VOLATILE TABLE mergetable(
	id INTEGER,
	name VARCHAR(100),
	indicator_flag CHAR(1)
)
PRIMARY INDEX(id)
ON COMMIT PRESERVE ROWS;

--Table 2
CREATE MULTISET VOLATILE TABLE othertable(
	id INTEGER,
	name VARCHAR(100),
	indicator_flag CHAR(1)
)
PRIMARY INDEX(id)
ON COMMIT PRESERVE ROWS;

--Table 1:
INSERT INTO mergetable VALUES(1,'Teradata','N');
INSERT INTO mergetable VALUES(2,'Database',null);
INSERT INTO mergetable VALUES(3,'Oracle',null);
INSERT INTO mergetable VALUES(4,'Vertica',null);

--Table 2:
INSERT INTO othertable VALUES(1,'Teradata','Y');
INSERT INTO othertable VALUES(2,'Database','N');
INSERT INTO othertable VALUES(5,'DB2','Y');
INSERT INTO othertable VALUES(6,'MYSQL','Y');

--
-- Example1: Upsert / Merge using other table (Multiple operation)
--
MERGE INTO mergetable tgt
USING othertable src
     ON (src.id = tgt.id)
WHEN MATCHED THEN
UPDATE 
SET 
   name             = src.name,
   indicator_flag   = src.indicator_flag
WHEN NOT MATCHED THEN
INSERT 
(
   id,
   name,
   indicator_flag
)
VALUES(
   src.id,
   src.name,
   src.indicator_flag
);
--Output:
--*** Merge completed. 4 rows affected.
--    2 rows inserted, 2 rows updated, no rows deleted.

--
-- Basic Upsert(Conditional Insert): Upsert with hardcoded values into a table, only one action will performed i.e either UPDATE or INSERT.
-- When 'WHERE' condition is satisfied in Update then Update will happen
-- 

-- Not supported and needs reqrite
UPDATE mergetable
SET   indicator_flag = 'N'
WHERE id = 3
ELSE 
   INSERT INTO mergetable (3, 'MongoDB', 'N');

--Output: 
--*** Update completed. One row changed. 

-- Not supported and needs reqrite
UPDATE mergetable
SET indicator_flag = 'N'
WHERE id = 7
ELSE 
    INSERT INTO mergetable (7, 'MongoDB', 'N');

--Output: 
--*** Insert completed. One row added.


--####################################################### 
-- Teradata: Update Using Another Table
-- source: https://dbmstutorials.com/random_teradata/teradata-update-using-other-table.html
--####################################################### 

-- Sample Data:
--Table 1
CREATE MULTISET VOLATILE TABLE updatetable(
    id INTEGER,
    name VARCHAR(100),
    indicator_flag CHAR(1)
)
PRIMARY INDEX(id)
ON COMMIT PRESERVE ROWS;


--Table 2
CREATE  MULTISET VOLATILE TABLE othertable(
    id INTEGER,
    name VARCHAR(100),
    indicator_flag CHAR(1)
)
PRIMARY INDEX(id)
ON COMMIT PRESERVE ROWS;
--Table 1:
INSERT INTO updatetable VALUES(1,'Teradata',null);
INSERT INTO updatetable VALUES(2,'Database',null);
INSERT INTO updatetable VALUES(3,'Oracle',null);
INSERT INTO updatetable VALUES(4,'Vertica',null);

--Table 2:
INSERT INTO othertable VALUES(1,'Teradata','Y');
INSERT INTO othertable VALUES(2,'Database','N');
INSERT INTO othertable VALUES(5,'DB2','Y');
INSERT INTO othertable VALUES(6,'MYSQL','Y');

-- Sample Queries

--Basic update : Update hardcode values to a table
UPDATE updatetable 
SET indicator_flag='Y'
WHERE id=4;

--Output:
--*** Update completed. One row updated.


--Multicolumn update : Update multiple column of a table
UPDATE updatetable 
SET indicator_flag='Y',
    name='Hive'
WHERE id=4;

--Output:
--*** Update completed. One row updated.


-- Approach 1 : update with the help of other table using join filter.
update updatetable 
from othertable as tempTableAlias
set indicator_flag = tempTableAlias.indicator_flag
where updatetable.id = tempTableAlias.id;

--Output:
--*** Update completed. Two row updated.

--Approach 2 : Update with the help of other table using join filter.
UPDATE tempAggr
FROM updatetable as tempAggr,
     othertable as tempTableAlias
SET indicator_flag = tempTableAlias.indicator_flag
WHERE tempAggr.id = tempTableAlias.id;

--Output:
--*** Update completed. Two row updated.

--Approach 3 : Update with the help of other table using Merge join.
MERGE INTO updatetable tgt
USING othertable src
ON (src.id=tgt.id)
WHEN MATCHED THEN
UPDATE 
SET indicator_flag = src.indicator_flag,
    name=src.name;

--Output:
--*** Merge completed. 2 rows affected.
--     No rows inserted, 2 rows updated, no rows deleted.



--####################################################### 
-- Teradata: Delete From Table
-- source: https://dbmstutorials.com/random_teradata/teradata-delete-from-table.html
--####################################################### 

--Samples Tables

--Table 1
CREATE MULTISET VOLATILE TABLE deletetable(
   id INTEGER,
   name VARCHAR(100)
)
PRIMARY INDEX(id)
ON COMMIT PRESERVE ROWS;

--Table 2
CREATE MULTISET VOLATILE TABLE othertable(
   id INTEGER,
   name VARCHAR(100)
)
PRIMARY INDEX(id)
ON COMMIT PRESERVE ROWS;

--Table 1:
INSERT INTO deletetable VALUES(1,'Teradata');
INSERT INTO deletetable VALUES(2,'Database');
INSERT INTO deletetable VALUES(3,'Oracle');
INSERT INTO deletetable VALUES(4,'Vertica');

--Table 2:
INSERT INTO othertable VALUES(1,'Teradata');
INSERT INTO othertable VALUES(2,'Database');
INSERT INTO othertable VALUES(5,'DB2');
INSERT INTO othertable VALUES(6,'MYSQL');


-- Approach 1 : Delete with the help of other table using direct filter.
DELETE FROM deletetable 
WHERE deletetable.id=othertable.id;

-- Output:
-- *** Delete completed. Two row deleted.

-- Approach 2 : Delete with the help of other table using join.
DELETE deletetable
  FROM othertable  
WHERE deletetable.id = othertable.id;

-- Output:
-- *** Delete completed. Two row deleted.

-- Approach 3 : Delete with the help of other table using traditional WHERE clause join.
DELETE FROM deletetable, othertable  
WHERE deletetable.id = othertable.id;

-- Output:
-- *** Delete completed. Two row deleted.

-- Approach 4 : Delete with the help of other table using EXISTS condition.
DELETE FROM deletetable
WHERE EXISTS (SELECT 1 FROM othertable WHERE deletetable.id = othertable.id);

-- Output:
-- *** Delete completed. Two row deleted.

-- Approach 5 : Delete with the help of other table using IN condition. This approach should be avoided.
DELETE FROM deletetable
WHERE id in (SELECT id FROM othertable);

-- Output:
-- *** Delete completed. Two row deleted.

-- Approach 6 : Delete with the help of other table using Merge join.
MERGE INTO deletetable tgt
USING othertable src
     ON (src.id = tgt.id)
WHEN MATCHED THEN
DELETE ;

-- Output:
-- *** Merge completed. 2 rows affected.
--     No rows inserted, no rows updated, 2 rows deleted


