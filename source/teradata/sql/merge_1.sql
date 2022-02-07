/** DDL for test tables
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
*/

/** Test data
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
*/

/** Merge
*/
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

/** Output:
 *** Merge completed. 4 rows affected.
     2 rows inserted, 2 rows updated, no rows deleted.
*/