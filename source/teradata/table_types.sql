--
-- source: https://dbmstutorials.com/teradata/teradata_table_types.html

-- Permanant Table
-- @Test: attributes to check - Multiset
-- 
CREATE MULTISET TABLE bladebridge.table_permant_test1
(                                   
  col_1   INTEGER,
  col_2   VARCHAR(50)
)
PRIMARY INDEX ( col_1 ,col_2 );

-- Permanant Table
-- @Test: attributes to check - set, column attribute like title
CREATE SET TABLE bladebridge.table_permant_test2
(                                   
  col_1   INTEGER,
  col_2   VARCHAR(50)
)
PRIMARY INDEX ( col_1 ,col_2 );


-- Global Temporary Tables(GTT)
-- Note: A GTT in Teradata has a persistent table definition that is stored in the Data Dictionary. 
--       Any number of sessions can materialize and populate their own local copies that are retained 
--       until session logoff.
--       Also note that contents of GTTs can be saved across the transactions with "ON COMMIT PRESERVE ROWS"
--       cluase where as default behaviour is to DELETE contents after COMMIT
-- 
--       Not sure this is same as Global Temporary Views in Databricks where 
--       the meta data definisions exists under global_temp schema and data is accessible to all sessions 
--       with in the same Spark Application (Databricks Cluster Scope?)
--
-- What is the target type on Databricks - Temporary View seems to be appropriate compared
--                           Global Temporary Views
-- 
CREATE GLOBAL TEMPORARY TABLE bladebridge.table_global_temp_test1,
LOG (f1 INT NOT NULL PRIMARY KEY, f2 DATE, f3 FLOAT) ON COMMIT PRESERVE ROWS;

CREATE SET GLOBAL TEMPORARY TABLE bladebridge.table_global_temp_test2,
LOG
(                                   
  col_1   INTEGER,
  col_2   VARCHAR(50) CHARACTER SET LATIN CASESPECIFIC TITLE 'Column Name 2'
)
PRIMARY INDEX ( col_1 ,col_2 )
ON COMMIT DELETE ROWS
; 

CREATE MULTISET VOLATILE TABLE bladebridge.table_volatile_test1
(   
  col_1 INTEGER,
  col_2 VARCHAR(50)
) 
ON COMMIT PRESERVE ROWS
; 