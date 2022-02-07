--
-- source: https://docs.teradata.com/r/CeAGk~BNtx~axcR0ed~5kw/qkt9pvPjUNPQbCaRXlerBQ
--
-- Example: Using Dynamic SQL Statements With a CALL Statement
--
CREATE PROCEDURE new_sales_table (my_table VARCHAR(30), my_database VARCHAR(30))
BEGIN
  DECLARE sales_columns VARCHAR(128)
        DEFAULT '(item INTEGER, price DECIMAL(8,2) , sold INTEGER)' ;
   CALL DBC.SysExecSQL('CREATE TABLE ' || my_database || '.' || my_table || sales_columns) ;
END;
