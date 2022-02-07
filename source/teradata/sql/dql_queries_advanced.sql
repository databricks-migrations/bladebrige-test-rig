-- ####################################################### 
--  Teradata: Split String into table rows
--  source: https://dbmstutorials.com/random_teradata/teradata-recursive-query.html
-- ####################################################### 

-- Recursive Query
-- Not supported in Databricks - Test for Analyzer
WITH
RECURSIVE RecReverseStringTable(id, name, name_len, qry_level, reverse_string,tm)
AS(   
--Initialize the logic or Seed query
      SELECT id, 
             name, 
             CHARACTER_LENGTH(name), 
             1,  --Starting Query level from 1
             CAST(''  AS VARCHAR(50)),
             current_timestamp(6)
        FROM rec_example
UNION ALL
--Recursive Join / Repeated iteration of the logic in the entire table
     SELECT
          id,
          name,
          name_len,
          qry_level+1,
          SUBSTRING(name FROM qry_level FOR 1) || reverse_string,
          tm 
      FROM RecReverseStringTable 
      WHERE qry_level <= name_len
)
-- Termination Query
SELECT id,
        name,
        reverse_string
    FROM RecReverseStringTable 
    WHERE name_len+1 = qry_level ORDER BY 1;


-- ####################################################### 
-  Teradata: Split String into table rows
-- Source: https://dbmstutorials.com/random_teradata/teradata-string-to-table.html
-- ####################################################### 

--
-- STRTOK_SPLIT_TO_TABLE
-- Not supported in Databricks: Test for Analyzer
SELECT split_d.*
from table(
        STRTOK_SPLIT_TO_TABLE(
            database_table_example.id,
            database_table_example.user_id,
            '123456789'
        ) returns (
            outkey INTEGER,
            token INTEGER,
            result_string VARCHAR(100) CHARACTER SET LATIN
        )
    ) as split_d;

--
-- STRTOK_SPLIT_TO_TABLE
-- Not supported in Databricks: Test for Analyzer
SELECT split_d.*
from table(
        STRTOK_SPLIT_TO_TABLE(
            database_table_example.id,
            database_table_example.user_id,
            '123456789'
        ) returns (
            outkey INTEGER,
            token INTEGER,
            result_string VARCHAR(100) CHARACTER SET LATIN
        )
    ) as split_d
WHERE database_table_example.id = 7;

--
-- STRTOK_SPLIT_TO_TABLE
-- Not supported in Databricks: Test for Analyzer
WITH tbl as (
    SELECT *
    FROM database_table_example
    WHERE id = 7
)
SELECT split_d.*
from table(
        STRTOK_SPLIT_TO_TABLE(Stbl.id, tbl.user_id, '123456789') returns (
            outkey INTEGER,
            token INTEGER,
            result_string VARCHAR(100) CHARACTER SET LATIN
        )
    ) as split_d;

--
-- STRTOK_SPLIT_TO_TABLE
-- Not supported in Databricks: Test for Analyzer
SELECT split_d.*
from table(
        STRTOK_SPLIT_TO_TABLE(
            3,
            'If23232you452correct5532your577mind235then6878rest131of7897life3448will078fall123into4356place.',
            '123456789'
        ) returns (
            outkey INTEGER,
            token INTEGER,
            result_string VARCHAR(100) CHARACTER SET LATIN
        )
    ) as split_d;


--
-- REGEXP_SPLIT_TO_TABLE
-- Not supported in Databricks: Test for Analyzer
SELECT split_d.*
from table(
        REGEXP_SPLIT_TO_TABLE('City', 'Jaipur&Bangalore&Bhubaneswar', '&', 'c') returns (
            outkey varchar(30),
            token INTEGER,
            result_string varchar(100)
        )
    ) as split_d;

--
-- REGEXP_SPLIT_TO_TABLE
-- Not supported in Databricks: Test for Analyzer
SELECT split_d.*
from table(
        REGEXP_SPLIT_TO_TABLE(
            3,
            'If23232you452correct5532your577mind235then6878rest131of7897life3448will078fall123into4356place.',
            '[0-9]',
            'c'
        ) returns (
            outkey INTEGER,
            token INTEGER,
            result_string VARCHAR(100) CHARACTER SET LATIN
        )
    ) as split_d;
--
-- REGEXP_SPLIT_TO_TABLE
-- Not supported in Databricks: Test for Analyzer
SELECT split_d.*
from table(
        REGEXP_SPLIT_TO_TABLE(
            3,
            'If23232you452correct5532your577mind235then6878rest131of7897life3448will078fall123into4356place.',
            '[0-9]*',
            'c'
        ) returns (
            outkey INTEGER,
            token INTEGER,
            res VARCHAR(100) CHARACTER SET LATIN
        )
    ) as split_d;



-- ####################################################### 
-- Teradata: Split String into multiple columns and Vice Versa
-- souce: https://dbmstutorials.com/random_teradata/teradata-string-to-columns.html
-- ####################################################### 

-- CSVLD function:
-- This functions takes in a delimited string (any delimiter can be passed), parses the string and returns multiple VARCHAR columns.
--

-- CSVLD
-- Ex: Split the string into columns using temporary/permanent table
SELECT *
FROM TABLE (
        CSVLD(csvld_example.code, ',', '') RETURNS (
            col1 varchar(50),
            col2 varchar(50),
            col3 varchar(50)
        )
    ) as T1;

--
-- CSVLD
-- Ex: Split the string into columns using derived table and pipe (|) as delimiter.
WITH delimi as (
    SELECT 'Teradata|Vertica|Oracle' as param
)
SELECT *
FROM TABLE (
        CSVLD(CAST(delimi.param AS VARCHAR(100)), '|', '"') RETURNS (
            col1 varchar(100) character set UNICODE,
            col2 varchar(100) character set UNICODE,
            col3 varchar(100) character set UNICODE
        )
    ) as T1;

-- CSV Function: 
-- This functions accepts multiple input columns as input and returns delimited string value merging all the columns with specified delimiter character.
-- Syntax: 
-- CSV(NEW VARIANT_TYPE(tablename.colum1,tablename.column2 [,tablename.columnN]), delimiter, quote_string)

-- CREATE MULTISET VOLATILE TABLE csv_example
--  (
--   id INTEGER,
--   col1 VARCHAR(10),
--   col2 VARCHAR(10),
--   col3 VARCHAR(10),
--   col4 DATE,
--   col5 INTEGER
-- )
--  PRIMARY INDEX(id)
-- ON COMMIT PRESERVE ROWS;
-- 
-- INSERT INTO csv_example(1,'Teradata','Vertica','Oracle',CURRENT_DATE,100);
-- INSERT INTO csv_example(2,'Spark','Hive','Flume',CURRENT_DATE,100);
-- 
--

-- CSV
-- ex: Merging multiple columns into single column for unloading with characterset as "LATIN"
SELECT *
FROM TABLE(
        CSV(
            NEW VARIANT_TYPE(
                csv_example.col1,
                csv_example.col2,
                csv_example.col3,
                csv_example.col4,
                csv_example.col5
            ),
            ',',
            '"'
        ) RETURNS (Technologies varchar(100) character set LATIN)
    ) as t1;


-- CSV
-- ex: Merging multiple columns into single column for unloading with characterset as "UNICODE" and delimiter as pipe(|).
SELECT *
FROM TABLE(
        CSV(
            NEW VARIANT_TYPE(
                csv_example.col1,
                csv_example.col2,
                csv_example.col3,
                csv_example.col4,
                csv_example.col5
            ),
            '|',
            ''
        ) RETURNS (Technologies varchar(100) character set UNICODE)
    ) as t1;

-- CSV
-- ex: column data contains comma(,) as value and in the final output is enclosed with double quote as specified to differentiate it with the delimiter
-- INSERT INTO csv_example(3,'Quote,Test','Hive','Test,Quote',CURRENT_DATE,100);
SELECT *
FROM TABLE(
        CSV(
            NEW VARIANT_TYPE(
                csv_example.col1,
                csv_example.col2,
                csv_example.col3,
                csv_example.col4,
                csv_example.col5
            ),
            ',',
            '"'
        ) RETURNS (Technologies varchar(100) character set LATIN)
    ) as t1;


--####################################################### 
-- Teradata: Merge Rows on date/timestamps
-- source: https://dbmstutorials.com/random_teradata/teradata-normailze.html

-- Merge rows based on overlapping dates/timestamp using Period datatype. 
-- NORMALIZE operation available for period datatypes will be leveraged to merge rows.
--####################################################### 
-- CREATE MULTISET VOLATILE TABLE normalize_example
-- (
-- Id              INTEGER,
-- type_cd         INTEGER,
-- Start_Dt        DATE,
-- End_Dt          DATE,
-- media_type_id   INTEGER
-- )
-- ON COMMIT PRESERVE ROWS;
-- 
-- 
-- --Data
-- INSERT INTO normalize_example VALUES(1,11,'2009-06-10','2017-07-18',6);
-- INSERT INTO normalize_example VALUES(1,11,'2017-07-18','2017-08-08',6);
-- INSERT INTO normalize_example VALUES(1,11,'2017-08-08','2018-08-08',7);
-- INSERT INTO normalize_example VALUES(1,11,'2018-08-08','9999-12-31',7);
-- 
-- INSERT INTO normalize_example VALUES(3,11,'2009-06-10','2017-07-18',6);
-- INSERT INTO normalize_example VALUES(3,11,'2017-07-18','2017-08-08',6);
-- INSERT INTO normalize_example VALUES(3,11,'2017-08-08','2017-08-10',6);
-- INSERT INTO normalize_example VALUES(3,11,'2017-08-08','2018-08-09',7);
-- INSERT INTO normalize_example VALUES(3,11,'2017-08-09','2018-08-12',7);
-- INSERT INTO normalize_example VALUES(3,11,'2018-08-12','2018-08-16',6);
-- INSERT INTO normalize_example VALUES(3,11,'2018-08-16','9999-12-31',7);

--
-- NORMALIZE 
-- Note: Not Supported - Test for Analyzer
SELECT id,
    type_cd,
    BEGIN(period_datatype) start_dt,
    END(period_datatype) end_dt,
    media_type_id
FROM
(
--Step 1:
  SELECT NORMALIZE
    id,
    type_cd,
    PERIOD(start_dt,end_dt) period_datatype,
    media_type_id
  FROM normalize_example
) X;

-- Output:
--  Id      type_cd    start_dt      end_dt  media_type_id
-- ---  -----------  ----------  ----------  -------------
--   1           11  2009-06-10  2017-08-08              6
--   1           11  2017-08-08  9999-12-31              7
--   3           11  2009-06-10  2017-08-10              6
--   3           11  2018-08-12  2018-08-16              6
--   3           11  2017-08-08  2018-08-12              7
--   3           11  2018-08-16  9999-12-31              7


--####################################################### 
-- Teradata Timestamp/Date Formatting
-- source: https://dbmstutorials.com/random_teradata/teradata-timestamp-formatting.html
--####################################################### 

-------------------+------------------------------------
-- MetaCharacters      Description / Functionality
-------------------+------------------------------------
--                   Display white space in formated timestamp
-- YY                Display year in four digits(example: 1987)
--                   Display year in two digits(example: 87)
--                   Display month of the year in number format(example: 12)
--  or MMM           Display month in 3 characters format(example: Jun)
--  or MMMM          Display full month name(example: June)
--                   Display day of the month in two digits(example: 30)
--  or DDD           Display day of the year(example: 276)
--                   Display hour of the time in two digits(example: 17)
--                   Display minutes of the time in two digits(example: 59)
--                   Display seconds of the time in two digits(example: 58)
--  or EEE           Display day of the week in 3 characters(example: Wed)
--  or EEEE          Display full name of week day(example: Wednesday)
--                   Display time in AM/PM format
-- (Colon)           Other permitted character in format
-- (Hyphen)          Other permitted character in format
-- (Backslash)       Other permitted character in format
-- (Period)          Other permitted character in format
-------------------+------------------------------------



--Example 1: Display timestamp in YYYY/MM/DD HH:MI:SS format
--BTEQ SYNTAX: 
SELECT  CURRENT_TIMESTAMP (format 'YYYY/MM/DDbHH:MI:SS') Formated_timestamp;
--OUTPUT: 2018/10/03 12:49:53

--IDE/Tool SYNTAX: 
SELECT  CAST((CURRENT_TIMESTAMP (format 'YYYY/MM/DDbHH:MI:SS')) AS VARCHAR(50)) Formated_timestamp;


--Example 2: Display timestamp in YY/MM/DD HH:MI:SS format
--BTEQ SYNTAX: 
SELECT  CURRENT_TIMESTAMP (format 'YY/MM/DDbHH:MI:SS') Formated_timestamp;
--OUTPUT: 18/10/03 13:26:22

--IDE/Tool SYNTAX: 
SELECT  CAST((CURRENT_TIMESTAMP (format 'YY/MM/DDbHH:MI:SS')) AS VARCHAR(50)) Formated_timestamp;

--Example 3: Display timestamp in YYYY/MM/DD HH:MI:SS format with AM/PM
--BTEQ SYNTAX: 
SELECT  CURRENT_TIMESTAMP (format 'YYYY/MM/DDbHH:MI:SSBT') Formated_timestamp;
--OUTPUT: 2018/10/03 12:50:46 PM

--IDE/Tool SYNTAX: 
SELECT CAST(CAST(CURRENT_TIMESTAMP as  FORMAT 'M4bDD,YYYYbHH:MI:SSBT') AS VARCHAR(50)) Formated_timestamp;

--Example 4: Display timestamp in YYYY-MM-DD HH:MI:SS format with millisecond or microsecond up to 1 digit. One (1) can be replaced with any number upto 6 to get that many number of microsecond.
--BTEQ SYNTAX: 
SELECT  CURRENT_TIMESTAMP (format 'YYYY-MM-DDbHH:MI:SS.s(1)') Formated_timestamp;
--OUTPUT: 2018-10-03 12:52:23.2


--IDE/Tool SYNTAX: 
SELECT  CAST((CURRENT_TIMESTAMP (format 'YYYY-MM-DDbHH:MI:SS.s(1)')) AS VARCHAR(50)) Formated_timestamp;

--Example 5: Display timestamp in YYYY-MM-DD HH:MI:SS format with millisecond or microsecond up to 5 digit. Five (5) can be replaced with any number upto 6 to get that many number of microsecond.
--BTEQ SYNTAX:  
SELECT CURRENT_TIMESTAMP (format 'YYYY-MM-DDbHH:MI:SS.s(5)') Formated_timestamp;
--OUTPUT: 2018-10-03 12:52:32.32000


--IDE/Tool SYNTAX: 
SELECT CAST((CURRENT_TIMESTAMP (format 'YYYY-MM-DDbHH:MI:SS.s(5)')) AS VARCHAR(50)) Formated_timestamp;

--Example 6: Display formatted timestamp with first 3 characters of month name.
--BTEQ SYNTAX:  
SELECT CAST(CURRENT_TIMESTAMP as  FORMAT 'M3bDD,YYYYbHH:MI:SS') Formated_timestamp;
--OUTPUT: Oct 03,2018 12:05:32

--IDE/Tool SYNTAX: 
SELECT CAST(CAST(CURRENT_TIMESTAMP as  FORMAT 'M3bDD,YYYYbHH:MI:SS') AS VARCHAR(50)) Formated_timestamp;

--Example 7: Display formatted timestamp with complete name of the month.
--BTEQ SYNTAX:  
SELECT CAST(CURRENT_TIMESTAMP as  FORMAT 'M4bDD,YYYYbHH:MI:SS') Formated_timestamp;
--OUTPUT: October 03,2018 11:42:58


--IDE/Tool SYNTAX: 
SELECT CAST(CAST(CURRENT_TIMESTAMP as  FORMAT 'M4bDD,YYYYbHH:MI:SS') AS VARCHAR(50)) Formated_timestamp;

--Example 8: Display formatted timestamp with first 3 characters of weekday name.
--BTEQ SYNTAX:  
SELECT CAST(CURRENT_TIMESTAMP as  FORMAT 'E3bM4bDD,YYYYbHH:MI:SS') Formated_timestamp;
--OUTPUT: Wed October 03,2018 12:05:40


--IDE/Tool SYNTAX: 
SELECT CAST(CAST(CURRENT_TIMESTAMP as  FORMAT 'E3bM4bDD,YYYYbHH:MI:SS') AS VARCHAR(50)) Formated_timestamp;

--Example 9: Display formatted timestamp with complete name of the weekday.
--BTEQ SYNTAX:  
SELECT CAST(CURRENT_TIMESTAMP as  FORMAT 'E4bM4bDD,YYYYbHH:MI:SS') Formated_timestamp;
--OUTPUT: Wednesday October 03,2018 12:05:47


--IDE/Tool SYNTAX: 
SELECT CAST(CAST(CURRENT_TIMESTAMP as  FORMAT 'E4bM4bDD,YYYYbHH:MI:SS') AS VARCHAR(50)) Formated_timestamp;

--Example 10: Display day of year instead of day of month.
SELECT CAST((CURRENT_TIMESTAMP  (FORMAT 'DDD')) AS VARCHAR(20))||' day of '||CAST((CURRENT_TIMESTAMP  (FORMAT 'YYYY')) AS VARCHAR(20))Formated_timestamp;
--OUTPUT: 276 day of 2018

--Example 11: Display given timestamp as custom formatted string.
SELECT 'Today is '||CAST((CURRENT_TIMESTAMP  (FORMAT 'E4,bDD')) AS VARCHAR(20))||' day of '||CAST((CURRENT_TIMESTAMP  (FORMAT 'M4,YYYY')) AS VARCHAR(20))|| ' and time is '||CAST((CURRENT_TIMESTAMP  (FORMAT 'HH:MI:SS')) AS VARCHAR(20))  Formated_timestamp;
--OUTPUT: Today is Wednesday, 03 day of October,2018 and time is 12:22:51


--####################################################### 
-- Teradata String To Date/Timestamp
-- source: https://dbmstutorials.com/random_teradata/teradata-string-to-timestamp.html
--####################################################### 

-- Below tables show most of the metacharacters that can used with TO_DATE / TO_TIMESTAMP function.	
--------------------+------------------------------------------------------------
-- MetaCharacters       Description / Functionality
--------------------+------------------------------------------------------------
-- YYYY                 Convert year in four digits(example: 1987)
-- YY                   Convert year in two digits(example: 87)
-- MM                   Convert month of the year in number format(example: 12)
-- MON                  Convert month in 3 characters format(example: Jun)
-- MONTH                Convert full month name(example: June) format
-- DD                   Convert day of the month in two digits(example: 30)
-- DDD                  Convert day of the year(example: 276)
-- HH                   Convert hour of the time in two digits(example: 17)
-- MI                   Convert minutes of the time in two digits(example: 59)
-- SS                   Convert seconds of the time in two digits(example: 58)
-- DY                   Convert day of the week in 3 characters(example: Wed)
-- DAY                  Convert full name of week day(example: Wednesday)
-- AM                   Convert string timestamp with AM/PM format
--------------------+------------------------------------------------------------

--Example 1: Convert date string which is not in irregular format
SELECT  TO_DATE('1-Oct-19','DD-MON-YY');
--OUTPUT: 2019-10-01

--Example 2: Convert date string in DD-MM-YYYY format to date datatype
SELECT  TO_DATE('1-12-2019','DD-MM-YYYY')
--OUTPUT: 2019-12-01

--Example 3: Convert date string in DD-MON-YY format to date datatype
SELECT  TO_DATE('12-Oct-19','DD-MON-YY');
--OUTPUT: 2019-10-12

--Example 4: Convert date string in DD-MON-YYYY format to date datatype
SELECT  TO_DATE('12-Oct-2019','DD-MON-YYYY');
--OUTPUT: 2019-10-12

--Example 5: Convert date string in DD-MONTH-YY format to date datatype
SELECT  TO_DATE('12-October-19','DD-MONTH-YY');
--OUTPUT: 2019-10-12

--Example 6: Convert date string in DD-MON-YY DY format to date datatype
SELECT TO_DATE('11-Oct-19 Fri','DD-MON-YY DY');
--OUTPUT: 2019-10-11

--Example 7: Convert date string in DD-MON-YY DAY format to date datatype
SELECT TO_DATE('11-Oct-19 Friday','DD-MON-YY DAY');
--OUTPUT: 2019-10-11

--Example 8: Convert date string in DDD-MON-YY format to date datatype, DDD--> Day of year
SELECT TO_DATE('278-Oct-2019','DDD-Mon-YYYY');
--OUTPUT: 2019-10-05

--Example 9: Convert date string in DD-MON-YY HH:MI:SS(12 Hour) format to timestamp datatype
SELECT TO_TIMESTAMP('1-Oct-19 10:12:11','DD-MON-YY HH:MI:SS');
--OUTPUT: 2019-10-01 10:12:11.000000

--Example 10: Convert date string in DD-MON-YY HH:MI:SS(24 Hour) format to timestamp datatype
SELECT TO_TIMESTAMP('01-Oct-19 14:12:11','DD-MON-YY HH24:MI:SS');
--OUTPUT: 2019-10-01 14:12:11.000000

--Example 11: Convert date string in DD-MM-YY HH:MI:SS(12 Hour with AM/PM) format to timestamp datatype
SELECT TO_TIMESTAMP('01-10-19 10:12:11 PM','DD-MM-YY HH:MI:SS AM');
--OUTPUT: 2019-10-01 22:12:11.000000

--Example 12: Convert date string with formatted timestamp with complete name of the weekday.
SELECT TO_TIMESTAMP('Wednesday October 03,2018 12:05:47','DAY MONTH DD,YYYY HH24:MI:SS');
--OUTPUT: 2018-10-03 12:05:47.000000

--####################################################### 
-- Teradata Number Formatting
-- source: https://dbmstutorials.com/random_teradata/teradata-number-formatting.html
--####################################################### 
-- Below tables show most of the metacharacters that can used with FORMAT keyword.	
--------------------+------------------------------------------------------------
-- MetaCharacters      Description / Functionality
--------------------+------------------------------------------------------------
-- 9                   Display decimal digits in specified format but zeros will not be suppressed
-- Z                   Display decimal digits in specified format and zeros will be suppressed
-- $                   Display dollar($) sign in front of the formatted number (example: 34343.02 to $34343.02)
-- ,                   Display comma(,) at the specifed position of formatted number (example: 343234343.02 to 343,234,343.02)
-- -                   Display hyphen(-) at the specifed position of formatted number (example: 4083434448 to 408-3434-448)
-- %                   Display percent(%) sign at the specifed position of formatted number (example: 79.02 to 79.02%)
-- /                   Display slash(/) sign at the specifed position of formatted number (example: 20181212 to 2018/12/12)
-- .                   Period(.) sign reflect the position of decimal point
--------------------+------------------------------------------------------------


-- Usage of period('.'):
-- Period in the format string will reflect the position of decimal point.
-- Format will round off the decimal points as shown in example 2.

-- Example 1:  
SELECT CAST(453453453.435 AS FORMAT '999999,999.9999');
-- Output: 453453,453.4350

-- Example 2:  
SELECT CAST(453453453.435 AS FORMAT '999999,999.99');
-- Output: 453453,453.44    <--Round off happened here 


--  '9' Metacharacter
-- Displaying formtted decimal digits with extra zeros at the starting position.
-- Extra zeros will be added to make size of output formatted number equal to number of metacharacter '9' specified in format string.
-- In the below example 2, since eight digits of '9' metacharacter is used in the format but only six digits(before decimal point) are present in source number therefore 2 zeros are prefixed in output.

-- Example 1: 
SELECT CAST(512453453.435 AS FORMAT '999999,999.9999');
-- Output: 512453,453.4350

-- Example 2: 
SELECT CAST(453453.435 AS FORMAT '99999,999.9999');
-- Output: 00453,453.4350

-- Example 3: 
SELECT 453453.435  (FORMAT '99999,999.9999');
-- Output: 00453,453.4350


-- 'Z' Metacharacter
-- Displaying formtted decimal digits with no extra zeros at the starting position.
-- In the below example, even though eight digits of 'Z' metacharacter is used in the format and only six digits(before decimal point) are present in source number therefore six digits(before decimal point) are present in output.

-- Example 1: 
SELECT CAST(453453.435 AS FORMAT 'ZZZZZZ,ZZZ.ZZZZ');
-- Output: 453,453.4350

-- Example 2: 
SELECT 453453.435  (FORMAT 'ZZZZZZ,ZZZ.ZZZZ');
-- Output: 453,453.4350


-- Usage of comma(','): As shown in the below examples, comma(,) can be used to place comma in the desired location of formatted number.
-- Example 1:  
SELECT CAST(453453453.435 AS FORMAT '999,999,999.99');
-- Output: 453,453,453.44

-- Example 2: 
SELECT CAST(453453453.435 AS FORMAT '999999,999.99');
-- Output: 453453,453.44

-- Example 3: 
SELECT 453453453.435  (FORMAT '999999,999.99');
-- Output: 453453,453.44


-- Usage of hyphen('-'): As shown in the below examples, hyphen(-) can be used to place hyphen in the desired location of formatted number. Popularly used for formatting phone numbers.
-- Example 1:  
SELECT CAST(4534534532 AS FORMAT '9999-999-999');
-- Output: 4534-534-532

-- Example 2:  
SELECT 4534534532  (FORMAT '9999-999-999');
-- Output: 4534-534-532

-- Usage of slash('/'): As shown in the below examples, slash(/) can be used to place slash in the desired location of formatted number.
-- Example 1:  
SELECT CAST(19870606 AS FORMAT '9999/99/99');
-- Output: 1987/06/06

-- Example 2:  
SELECT 19870606 (FORMAT '9999/99/99');
-- Output: 1987/06/06


-- Usage of percent('%'):
-- As shown in the below examples, percent(%) can be used to place percent in the desired location of formatted number.
-- Mostly this is used to display number as percentage with percent sign as shown in example 2 & 3.

-- Example 1:  
SELECT CAST(19870606 AS FORMAT '9999%99%99');
-- Output: 1987%06%06

-- Example 2:  
SELECT (4/5.0)* 100 (FORMAT 'ZZ9%');
-- Output: 80%

-- Example 3:  
SELECT (4.790/5.000)* 100 (FORMAT 'ZZ9.99%');
-- Output: 95.80%


-- Usage of dollar('$'): Mostly this is used to display number as amount with dollar sign in front. Below example displays the same.
-- Example 1:  
SELECT 34343 (FORMAT '$999,99.99');
-- Output: $343,43.00

-- Careful! always ensure formatting string is bigger than the source number else format will return asterisk instead of formatted number.
-- In the below example, format string is of size 4 (9,999)(before decimal point) and source number is of size 5 (53453). Since the size of format string is smaller than source number, output returned is asterisks.
-- Example 1:  
SELECT CAST(53453.435 AS FORMAT '9,999.99');
-- Output: ********


--####################################################### 
-- Teradata: First and Last Day
-- source: https://dbmstutorials.com/random_teradata/teradata-first-and-last-day.html
-- Syntax: TRUNC(date_column, Trunc_keyword) 
--####################################################### 
-- Below tables show most of the metacharacters that can used for Trunc_keyword.	
--------------------+------------------------------------------------------------
-- Trunc_keyword      Description
--------------------+------------------------------------------------------------
-- Y                  Truncate date to start of the year (Example: 2018-09-10 to 2018-01-01)
-- YEAR               Truncate date to start of the year (Example: 2018-09-10 to 2018-01-01)
-- Q                  Truncate day to start of the Quarter (Example: 2018-09-10 to 2018-07-01)
-- RM                 Truncate day to start of the month (Example: 2018-09-10 to 2018-09-01)
-- MON                Truncate day to start of the month (Example: 2018-09-10 to 2018-09-01)
-- MONTH              Truncate day to start of the month (Example: 2018-09-10 to 2018-09-01)
-- DAY                Truncate day to start of the week
-- D                  Truncate day to start of the week
-- W                  Truncate date to day of the week which is same as first day of month
-- WW                 Truncate date to day of the week which is same as first day of year
--------------------+------------------------------------------------------------

-- First Day of Year
-- --Example 1
SELECT TRUNC(CURRENT_DATE, 'YEAR'),CURRENT_DATE;
-- 
-- Output:
-- TRUNC(Current Date,'YEAR')  Current Date
-- --------------------------  ------------
--                 2018-01-01    2018-10-10

 
-- --Example 2
SELECT TRUNC(CURRENT_DATE, 'Y'),CURRENT_DATE;
-- 
-- Output:
-- TRUNC(Current Date,'Y')  Current Date
-- -----------------------  ------------
--              2018-01-01    2018-10-10
-- 
-- Last Day of Year
-- --Example 1
SELECT ADD_MONTHS(TRUNC(CURRENT_DATE, 'YEAR'),12)-1 Last_day_of_year ,CURRENT_DATE;
-- 
-- Output:
-- Last_day_of_year  Current Date
-- ----------------  ------------
--       2018-12-31    2018-10-10

 --Example 2
SELECT ADD_MONTHS(TRUNC(CAST('2018-05-23' AS DATE), 'YEAR'),12)-1 Last_day_of_year;
-- 
-- Last_day_of_year
-- ----------------
--       2018-12-31

 
-- First Day of Quarter
SELECT TRUNC(CURRENT_DATE, 'Q'),CURRENT_DATE;
-- 
-- Output:
-- TRUNC(Current Date,'Q')  Current Date
-- -----------------------  ------------
--              2018-10-01    2018-10-10
-- 
-- Last Day of Quarter
SELECT ADD_MONTHS(TRUNC(CURRENT_DATE, 'Q'),3)-1 Last_day_of_quarter, CURRENT_DATE;
-- 
-- Output:
-- Last_day_of_quarter  Current Date
-- -------------------  ------------
--          2018-12-31    2018-10-10

 
-- First Day of Month
-- --Example 1
SELECT TRUNC(CURRENT_DATE, 'MON'), CURRENT_DATE;
-- 
-- Output:
-- TRUNC(Current Date,'RM')  Current Date
-- ------------------------  ------------
--               2018-10-01    2018-10-10

 --Example 2
SELECT TRUNC(CURRENT_DATE, 'MONTH'), CURRENT_DATE;
-- 
-- Output:
-- TRUNC(Current Date,'RM')  Current Date
-- ------------------------  ------------
--               2018-10-01    2018-10-10

 --Example 3
SELECT TRUNC(CURRENT_DATE, 'RM'), CURRENT_DATE;
-- 
-- Output:
-- TRUNC(Current Date,'RM')  Current Date
-- ------------------------  ------------
--               2018-10-01    2018-10-10
-- 
-- First Day of Last Month
SELECT TRUNC(ADD_MONTHS(CURRENT_DATE, -1), 'MONTH') First_day_of_last_month, CURRENT_DATE;
-- 
-- Output:
-- First_day_of_last_month  Current Date
-- -----------------------  ------------
--              2018-09-01    2018-10-10
-- 
-- Last Day of Month
SELECT LAST_DAY(CURRENT_DATE) Last_day_of_month, CURRENT_DATE;
-- 
-- Output:
-- Last_day_of_month  Current Date
-- -----------------  ------------
--        2018-10-31    2018-10-10
-- 
-- Last Day of Last Month
SELECT TRUNC(CURRENT_DATE, 'MONTH')-1 Last_day_of_last_month, CURRENT_DATE;
-- 
-- Output:
-- Last_day_of_last_month  Current Date
-- ----------------------  ------------
--             2018-09-30    2018-10-10

 
-- First Day of Week
-- --Example 1
SELECT TRUNC(CURRENT_DATE, 'D'), CURRENT_DATE;
-- 
-- Output:
-- TRUNC(Current Date,'D')  Current Date
-- -----------------------  ------------
--              2018-10-07    2018-10-10

 --Example 2
SELECT TRUNC(CURRENT_DATE, 'DAY'), CURRENT_DATE;
-- 
-- Output:
-- TRUNC(Current Date,'DAY')  Current Date
-- -------------------------  ------------
--                2018-10-07    2018-10-10
-- 
-- Last Day of Week
-- --Example 1
SELECT TRUNC(CURRENT_DATE + 7, 'D') - 1 Last_day_week, CURRENT_DATE;
-- 
-- Output:
-- Last_day_week  Current Date
-- -------------  ------------
--    2018-10-13    2018-10-10
-- 


--####################################################### 
-- Teradata: Teradata: Numeric or Alphabetic data in Alphanumeric Column
-- source: https://dbmstutorials.com/random_teradata/teradata-alphanumeric-data.html
-- use cases:
--              Find Only Numeric Data
--              Find Only Character Data
--              Find Only Alphanumeric Data
--####################################################### 

--Creating Sample Table
CREATE MULTISET TABLE alphanumeric_test(
   id INTEGER,
   user_id VARCHAR(50),
   Name VARCHAR(100)
)
PRIMARY INDEX(id);

--Insert Alphanumeric data in Table
INS alphanumeric_test(1,'alpha','Teradata');
INS alphanumeric_test(2,'beta','Oracle');
INS alphanumeric_test(3,'gamma','Vertica');
INS alphanumeric_test(4,'12345','Mysql');
INS alphanumeric_test(5,'123gamma','DB2');
INS alphanumeric_test(6,'54321','Python');
INS alphanumeric_test(7,'433alpha','Scala');
INS alphanumeric_test(8,'alpha4532','R');
INS alphanumeric_test(9,'24343','Hive');
INS alphanumeric_test(10,'PETA','Pig');
INS alphanumeric_test(11,'beta2322','Hbase');
INS alphanumeric_test(12,'324BETA','Hbase');
INS alphanumeric_test(12,'324GAMMA6545','Hbase');

--
-- Finding Numeric Data in Alphanumeric Column
--
--Approach 1: Simplest approach which may work in any of the database, here we have to specifically add "CASESPECIFIC" since Teradata is case insensitive.
SELECT  id, user_id  FROM  alphanumeric_test
WHERE UPPER(user_id)=LOWER(user_id)(CASESPECIFIC);

-- Output:
--  Id  User_Id
-- ---  --------
--   6  54321
--   9  24343
--   4  12345

--Approach 2: In this approach, REGEXP_INSTR function is used to identify the position of any character in the String. And if any alphabetic character is not present then function will return 0.
SELECT  id, user_id  FROM  alphanumeric_test
WHERE REGEXP_INSTR(user_id,'[a-zA-Z]+')=0;

-- Output:
--  Id  User_Id
-- ---  --------
--   6  54321
--   9  24343
--   4  12345

--Approach 3: In this approach, OTRANSLATE function is used to remove all the numeric value and if length of output string is Zero after removing all numeric values. That means it contains only numeric data.
SELECT  id, user_id  FROM  alphanumeric_test
WHERE CHARACTER_LENGTH(OTRANSLATE(user_id,'0123456789',''))=0;

-- Output:
--  Id  User_Id
-- ---  --------
--   6  54321
--   9  24343
--   4  12345

--Approach 4: In this approach, OTRANSLATE function is used to remove all the alphabetic values and if length of output string is equal to length of original string after removing all alphabetic value. That means it contains only numeric data.
SELECT  id, user_id  FROM  alphanumeric_test
WHERE CHARACTER_LENGTH(OTRANSLATE(LOWER(user_id),'abcdefghijklmnopqrstuvwxyz',''))=CHARACTER_LENGTH(user_id);

-- Output:
--  Id  User_Id
-- ---  --------
--   6  54321
--   9  24343
--   4  12345

--Approach 5: In this approach, OTRANSLATE function is used to remove all the alphabetic values and if output string is equal to original string after removing all alphabetic value. That means it contains only numeric data.
SELECT  id, user_id  FROM  alphanumeric_test
WHERE OTRANSLATE(LOWER(user_id),'abcdefghijklmnopqrstuvwxyz','') = user_id;

-- Output:
--  Id  User_Id
-- ---  --------
--   6  54321
--   9  24343
--   4  12345


--
--Finding Alphabetic Data in Alphanumeric Column
--

--Approach 1 :In this approach, REGEXP_INSTR function is used to identify the position of any numeric value in the String. And if any numeric character is not present then function will return 0.
SELECT  id, user_id  FROM  alphanumeric_test
WHERE REGEXP_INSTR(user_id,'[0-9]')=0;

-- Output:
--  Id  User_Id
-- ---  --------
--   3  gamma
--  10  PETA
--   1  alpha
--   2  beta

Approach 2: In this approach, REGEXP_SUBSTR function is used to get first any numeric value in the String. And if output string is null that means data contains only Alphabetic data.
SELECT  id, user_id,REGEXP_SUBSTR(user_id,'[0-9]') FROM  alphanumeric_test
WHERE REGEXP_SUBSTR(user_id,'[0-9]') IS NULL;

-- Output:
--  Id  User_Id
-- ---  --------
--   3  gamma
--  10  PETA
--   1  alpha
--   2  beta

--Approach 3: In this approach, OTRANSLATE function is used to remove all the numeric values and if length of output string is equal to length of original string after removing all numeric value. That means it contains only Alphabetic data.
SELECT  id, user_id  FROM  alphanumeric_test
WHERE CHARACTER_LENGTH(OTRANSLATE(user_id,'0123456789','')) = CHARACTER_LENGTH(user_id);

-- Output:
--  Id  User_Id
-- ---  --------
--   3  gamma
--  10  PETA
--   1  alpha
--   2  beta

--Approach 4: In this approach, OTRANSLATE function is used to remove all the numeric values and if output string is equal to original string after removing all numeric value. That means it contains only Alphabetic data.
SELECT  id, user_id  FROM  alphanumeric_test
WHERE OTRANSLATE(user_id,'0123456789','') = user_id;

-- Output:
--  Id  User_Id
-- ---  --------
--   3  gamma
--  10  PETA
--   1  alpha
--   2  beta

--Approach 5: In this approach, OTRANSLATE function is used to remove all the Alphabetic values and if length of output string is Zero after removing all Alphabetic values. That means it contains only Alphabetic data.
SELECT  id, user_id  FROM  alphanumeric_test
WHERE CHARACTER_LENGTH(OTRANSLATE(LOWER(user_id),'abcdefghijklmnopqrstuvwxyz',''))=0;

-- Output:
--  Id  User_Id
-- ---  --------
--   3  gamma
--  10  PETA
--   1  alpha
--   2  beta


--
-- Finding only Alphanumeric data
-- 

--Approach 1: This approach is combination of 2 OTRANSLATE functions to identify data with numeric values & to identify data with alphabetic values.
SELECT  id, user_id  FROM  alphanumeric_test
WHERE CHARACTER_LENGTH(OTRANSLATE(user_id,'0123456789',''))>0 
AND CHARACTER_LENGTH(OTRANSLATE(LOWER(user_id),'abcdefghijklmnopqrstuvwxyz',''))>0;

-- Output:
--  Id  User_Id
-- ---  ---------
--  7   433alpha
--  11  beta2322
--  5   123gamma
--  12  324BETA
--  8   alpha4532

--Approach 2: This approach is combination of 2 REGEXP_INSTR functions to identify data with numeric values & to identify data with alphabetic values.
SELECT  id, user_id  FROM  alphanumeric_test
WHERE REGEXP_INSTR(user_id,'[0-9]')>0 
AND REGEXP_INSTR(user_id,'[a-zA-Z]')>0;

-- Output:
--  Id  User_Id
-- ---  ---------
--  7   433alpha
--  11  beta2322
--  5   123gamma
--  12  324BETA
--  8   alpha4532



--####################################################### 
-- Teradata: Transpose Column To Rows
-- source: https://dbmstutorials.com/random_teradata/teradata_transpose_column_to_rows.html
--####################################################### 

-- Sample table and test data
CREATE  VOLATILE TABLE student
( 
  id      INTEGER,
  name    VARCHAR(10),
  english INTEGER,
  maths   INTEGER,
  science INTEGER
)
ON COMMIT PRESERVE ROWS;

INSERT INTO student(123,'Harry',90,95,95);
INSERT INTO student(345,'Porter',70,80,90);

SELECT * FROM student;

-- Output:
-- id  name   english maths science
-- 123 Harry   90       95       95
-- 345 Porter  70       80       90

--
-- Approach 3: Using Teradata's Unpivot function
-- Below query using TD_UNPIVOT will also transpose columns to row and will give exactly same output as with other 2 approaches.
--

SELECT * FROM TD_UNPIVOT(
    ON( SELECT * FROM student)
    USING
    VALUE_COLUMNS('Marks')
    UNPIVOT_COLUMN('subject')
    COLUMN_LIST('english', 'maths', 'science')
    COLUMN_ALIAS_LIST('english', 'maths', 'science' )
) X;


-- Output:
  id  name     subject   marks
-- ----  -------  --------  -----
--  123  Harry    english      90
--  123  Harry    maths        95
--  123  Harry    science      95
--  345  Porter   english      70
--  345  Porter   maths        80
--  345  Porter   science      90


-- Using TD_UNPIVOT function with more groups of columns

--Student Table: Creating a sample volatile table student with 2 columns for different pattern to be transposed as shown below.
CREATE  VOLATILE TABLE student
( 
  id             INTEGER,
  name           VARCHAR(10),
  english_marks  INTEGER,
  maths_marks    INTEGER,
  science_marks  INTEGER,
  english_grade  CHAR(1),
  maths_grade    CHAR(1),
  science_grade CHAR(1)
)
ON COMMIT PRESERVE ROWS;

--Data Population: Inserting couple of records in the table for transposing them to rows.
INSERT INTO student(123,'Harry',90,95,95,'A','B','B');
INSERT INTO student(345,'Porter',70,80,90,'C','D','B');

--Approach Solution: Below query using TD_UNPIVOT will also transpose columns to rows for the multi-columns.
SELECT * FROM TD_UNPIVOT(
    ON( SELECT * FROM student)
    USING
    VALUE_COLUMNS('Marks','Grades')
    UNPIVOT_COLUMN('subject')
    COLUMN_LIST('english_marks,english_grade', 'maths_marks,maths_grade', 'science_marks,science_grade')
    COLUMN_ALIAS_LIST('english', 'maths', 'science' )
)X;

-- Output:
--    id  name     subject   marks Grades
--  ----  -------  --------  ----- ------
--   123  Harry    english      90      A
--   123  Harry    maths        95      B
--   123  Harry    science      95      B
--   345  Porter   english      70      C
--   345  Porter   maths        80      D
--   345  Porter   science      90      B


--####################################################### 
-- Teradata: Transpose Rows to Column
-- source: https://dbmstutorials.com/random_teradata/teradata_transpose_rows_to_columns.html
--####################################################### 

-- Sample table (Ledger) and test data
CREATE  VOLATILE TABLE ledger
( 
  year_nr          INTEGER,
  Quarter          VARCHAR(10),
  Sales            DECIMAL(18,0)
)
ON COMMIT PRESERVE ROWS;

INSERT INTO ledger VALUES(2015,'Q1',90);
INSERT INTO ledger VALUES(2015,'Q2',70);
INSERT INTO ledger VALUES(2015,'Q3',130);
INSERT INTO ledger VALUES(2015,'Q4',30);
INSERT INTO ledger VALUES(2016,'Q1',40);
INSERT INTO ledger VALUES(2016,'Q2',50);
INSERT INTO ledger VALUES(2016,'Q3',120);
INSERT INTO ledger VALUES(2016,'Q4',20);

SELECT * FROM ledger;

-- Output:
-- year  Quarter   Sales
-- 2015  Q1        90
-- 2015  Q2        70
-- 2015  Q3        130
-- 2015  Q4        30
-- 2016  Q1        40
-- 2016  Q2        50
-- 2016  Q3        120
-- 2016  Q4        20

--
-- Solution 1: Below query can transpose row to column for the given table 'ledger' using case statement.
--
Select year_nr,
    SUM(CASE WHEN Quarter='Q1' THEN Sales END) Q1,
    SUM(CASE WHEN Quarter='Q2' THEN Sales END) Q2,
    SUM(CASE WHEN Quarter='Q3' THEN Sales END) Q3,
    SUM(CASE WHEN Quarter='Q4' THEN Sales END) Q4
FROM Ledger
GROUP BY year_nr;

-- Output:
-- year_nr  Q1     Q2       Q3      Q4
-- -------  -----  -------  ------  ------
-- 2015     90     70       130     30
-- 2016     40     50       120     20

--
-- Solution 2: Same result can be achieved using Teradata PIVOT function (introduced in TD 16).
--
SELECT *
FROM ledger PIVOT (
SUM(sales)
FOR Quarter IN ('Q1' AS Q1,
                'Q2' AS Q2,
                'Q3' AS Q3,
                'Q4' AS Q4)
)Temp_pivot;

-- Output:
-- year_nr  Q1     Q2       Q3      Q4
-- -------  -----  -------  ------  ------
-- 2015     90     70       130     30
-- 2016     40     50       120     20

--
-- Using PIVOT function with more groups of columns
-- 
CREATE  VOLATILE TABLE ledger_multigroup
( 
  year_nr          INTEGER,
  Quarter          VARCHAR(10),
  Sales            DECIMAL(18,0),
  profit           DECIMAL(18,0)
)
ON COMMIT PRESERVE ROWS;

--Data
INSERT INTO ledger_multigroup VALUES(2015,'Q1',90,3);
INSERT INTO ledger_multigroup VALUES(2015,'Q2',70,6);
INSERT INTO ledger_multigroup VALUES(2015,'Q3',130,2);
INSERT INTO ledger_multigroup VALUES(2015,'Q4',30,6);
INSERT INTO ledger_multigroup VALUES(2016,'Q1',40,1);
INSERT INTO ledger_multigroup VALUES(2016,'Q2',50,8);
INSERT INTO ledger_multigroup VALUES(2016,'Q3',120,9);
INSERT INTO ledger_multigroup VALUES(2016,'Q4',20,7);

--
-- Solution 1: It will be easier to use Teradata PIVOT (introduced in TD 16) function for more groups of columns.
--
SELECT *
FROM ledger_multigroup PIVOT (
SUM(sales) AS sales, SUM(profit) as profit
FOR Quarter IN ('Q1' AS Q1,
                'Q2' AS Q2,
                'Q3' AS Q3,
                'Q4' AS Q4)
)Temp_pivot;

-- Output:
-- year_nr  Q1_sales  Q1_profit  Q2_sales  Q2_profit  Q3_sales  Q3_profit  Q4_sales  Q4_profit
-- -------  --------  ---------  --------  ---------  --------  ---------  --------  ---------
--    2015       90         3       70         6      130         2       30         6
--    2016       40         1       50         8      120         9       20         7

-- Solution 2: Same result can be achieved using case statemen
Select year_nr,
    SUM(CASE WHEN Quarter='Q1' THEN Sales END) Q1_Sales,
    SUM(CASE WHEN Quarter='Q2' THEN Sales END) Q2_Sales,
    SUM(CASE WHEN Quarter='Q3' THEN Sales END) Q3_Sales,
    SUM(CASE WHEN Quarter='Q4' THEN Sales END) Q4_Sales,
    SUM(CASE WHEN Quarter='Q1' THEN profit END) Q1_profit,
    SUM(CASE WHEN Quarter='Q2' THEN profit END) Q2_profit,
    SUM(CASE WHEN Quarter='Q3' THEN profit END) Q3_profit,
    SUM(CASE WHEN Quarter='Q4' THEN profit END) Q4_profit
FROM Ledger
GROUP BY year_nr;

-- Output:
-- year_nr   Q1_Sales   Q2_Sales    Q3_Sales   Q4_Sales   Q1_profit   Q2_profit  Q3_profit   Q4_profit
-- --------  ---------  ---------  ----------  ---------  ----------  ---------- ----------  ----------
--     2015        90        70        130        30          3          6         2          6
--     2016        40        50        120        20          1          8         9          7



--####################################################### 
-- Teradata: Byte Comparing
-- source: https://dbmstutorials.com/random_teradata/teradata_comparing_bytes.html
--####################################################### 

-- Sample Table with Test Data
CREATE MULTISET VOLATILE TABLE byte_users
( 
  id      INTEGER,
  userId  Byte(4)
)
ON COMMIT PRESERVE ROWS;

-- Data Population : Inserting couple of records in the table for testing query
INSERT INTO byte_users(1, '00003b77'XB);
INSERT INTO byte_users(2, '00007b23'XB);

SELECT * FROM byte_users;

-- Output:
-- id  userId
-- 1   00003b77  
-- 2   00007b23 

-- Example Query
-- 'x' indicates that the value of literal is hexadecimal and 'b' indicates that the datatype is byte.
SELECT * FROM byte_users WHERE userId='00003b77'XB;

-- Output:
-- id  userId
-- 1   00003b77 