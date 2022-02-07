--
-- source: https://docs.teradata.com/r/CeAGk~BNtx~axcR0ed~5kw/qkt9pvPjUNPQbCaRXlerBQ
--
-- Example: Using Dynamic SQL Statements With an EXECUTE IMMEDIATE Statement
--
CREATE PROCEDURE new_sales_table (my_table VARCHAR(30), my_database VARCHAR(30))
BEGIN
    DECLARE sales_columns VARCHAR(128)
    DEFAULT '(item INTEGER, price DECIMAL(8,2) , sold INTEGER)' ;
    DECLARE sqlstr VARCHAR(500);
    SET sqlstr = 'CREATE TABLE ' || my_database || '.' || my_table || sales_columns ;
    EXECUTE IMMEDIATE sqlstr;
END;
