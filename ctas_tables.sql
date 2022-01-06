
CREATE TABLE target_table AS (
       SELECT * 
       FROM subquery_table )
     WITH DATA;


CREATE TABLE target_table AS (
       SELECT column_1, column_2 
       FROM subquery_table )
     WITH NO DATA;

--
-- source: https://www.teradatapoint.com/teradata/create-table-teradata.htm
CREATE TABLE Employee_Database.bachelor_employee AS (
   SELECT
      *
   FROM Employee_Database.Employee e
   WHERE
      e.Marital_Status = 'S'
   )
WITH DATA;