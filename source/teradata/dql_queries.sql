
--
-- source: https://www.tutorialspoint.com/teradata/teradata_select_statement.htm

--
-- Select
SELECT EmployeeNo,
    FirstName,
    LastName
FROM db_schema.dql_test_table1;


--
-- Order By
SELECT *
FROM db_schema.dql_test_table1
ORDER BY FirstName,
    LastName;

--
-- Group By
SELECT DepartmentNo,
    Count(*)
FROM db_schema.dql_test_table1
GROUP BY DepartmentNo;


--
-- BETWEEN
SELECT EmployeeNo,
    FirstName
FROM db_schema.dql_test_table1
WHERE EmployeeNo BETWEEN 101 AND 103;

--
-- IN
SELECT EmployeeNo,
    FirstName
FROM db_schema.dql_test_table1
WHERE EmployeeNo in (101, 102, 103);

--
-- NOT IN
SELECT * FROM  
FROM db_schema.dql_test_table1
WHERE EmployeeNo not in (101,102,103);

-- ####################################################### 
-- Set Operations
-- ####################################################### 

--
-- UNION

SELECT EmployeeNo
FROM db_schema.dql_test_table1
UNION
SELECT EmployeeNo
FROM db_schema.dql_test_table2;


--
-- UNION ALL
SELECT EmployeeNo
FROM db_schema.dql_test_table1
UNION ALL
SELECT EmployeeNo
FROM db_schema.dql_test_table2;


--
-- INTERSECT
SELECT EmployeeNo
FROM db_schema.dql_test_table1
INTERSECT
SELECT EmployeeNo
FROM db_schema.dql_test_table2; 


--
-- INTERSECT ALL
SELECT EmployeeNo
FROM db_schema.dql_test_table1
INTERSECT ALL
SELECT EmployeeNo
FROM db_schema.dql_test_table2; 

--
-- MINUS
SELECT EmployeeNo
FROM db_schema.dql_test_table1
MINUS
SELECT EmployeeNo
FROM db_schema.dql_test_table2;

--
-- MINUS ALL
SELECT EmployeeNo
FROM db_schema.dql_test_table1
MINUS ALL
SELECT EmployeeNo
FROM db_schema.dql_test_table2;


-- ####################################################### 
-- String and Date Manipulation
-- ####################################################### 

--
--
SELECT SUBSTRING('warehouse' FROM 1 FOR 4);
SELECT SUBSTR('warehouse',1,4);
SELECT 'data' || ' ' || 'warehouse';
SELECT UPPER('data');
SELECT LOWER('DATA');


SELECT EXTRACT(YEAR FROM CURRENT_DATE);  
SELECT EXTRACT(MONTH FROM CURRENT_DATE); 
SELECT EXTRACT(DAY FROM CURRENT_DATE);
SELECT EXTRACT(HOUR FROM CURRENT_TIMESTAMP);
SELECT EXTRACT(MINUTE FROM CURRENT_TIMESTAMP);
SELECT EXTRACT(SECOND FROM CURRENT_TIMESTAMP);

SELECT CURRENT_DATE, CURRENT_DATE + INTERVAL '03' YEAR;
SELECT CURRENT_DATE, CURRENT_DATE + INTERVAL '03-01' YEAR TO MONTH;
SELECT CURRENT_TIMESTAMP,CURRENT_TIMESTAMP + INTERVAL '01 05:10' DAY TO MINUTE;

--
-- Epoch Time to TIMESTAMP
SELECT CAST(
        (date '1970-01-01' + 1541001734 / 86400) AS TIMESTAMP(0)
    ) + (1541001734 MOD 86400) * INTERVAL '00:00:01' HOUR TO SECOND;

--
-- Epoch Time to TIMESTAMP
SELECT CAST(
        (date '1970-01-01' + epcho_time_column / 86400) AS TIMESTAMP(0)
    ) + (epcho_time_column MOD 86400) * INTERVAL '00:00:01' HOUR TO SECOND
FROM db_schema.dql_test_table1;

--
-- Epoch Time to TIMESTAMP
SELECT CAST(
        (
            date '1970-01-01' + CAST(1541001734342 / 1000 AS INTEGER) / 86400
        ) AS TIMESTAMP(6)
    ) + (CAST(1541001734342 / 1000 AS INTEGER) MOD 86400) * INTERVAL '00:00:01' HOUR TO SECOND + (1541001734342 MOD 1000) * INTERVAL '00:00:00.001' HOUR TO SECOND;

--
-- Epoch Time to TIMESTAMP
SELECT CAST(
        (
            date '1970-01-01' + CAST(
                epcho_time_column_with_milliseconds / 1000 AS INTEGER
            ) / 86400
        ) AS TIMESTAMP(6)
    ) + (
        CAST(
            epcho_time_column_with_milliseconds / 1000 AS INTEGER
        ) MOD 86400
    ) * INTERVAL '00:00:01' HOUR TO SECOND + (epcho_time_column_with_milliseconds MOD 1000) * INTERVAL '00:00:00.001' HOUR TO SECOND
FROM db_schema.dql_test_table1;

-- Subtract Timestamps
-- source: https://dbmstutorials.com/random_teradata/teradata-timestamp-difference.html
-- CREATE volatile table dateTable
-- (    DateTimeField1  TIMESTAMP(0),
--      DateTimeField2  TIMESTAMP(0),
--      DateTimeField3 TIMESTAMP(0),
--      DateTimeField4 TIMESTAMP(0)
-- )
-- ON COMMIT PRESERVE ROWS;
-- 
-- INSERT INTO dateTable VALUES ('2018-08-05 11:11:23','2018-08-03 04:15:23','2018-08-04 12:11:23','2018-08-04 13:13:53');

--
-- ex: Days between 2 Dates: Date can be directly subtrated and return output as integer value in days, can be compared with datediff function
SELECT CAST('2017-07-18' AS DATE) End_Dt, CAST('2009-06-10' AS DATE) Start_Dt, End_Dt-Start_Dt;
-- Output:
--     End_Dt    Start_Dt  (End_Dt-Start_Dt)
-- ----------  ----------  -----------------
-- 2017-07-18  2009-06-10               2960

--
-- ex: Difference in Days to Seconds: Returns output difference values in days, hour, minutes & seconds.
SELECT (DateTimeField1 - DateTimeField2) DAY(4) to SECOND(4) FROM dateTable;
--tput:--> 2 6:56:00  
--ove output is 2 days, 6 hours, 56 minutes & 0 seconds
--
-- ex:Difference in Hours to Seconds: Returns output difference values in hour, minutes & seconds.
SELECT (DateTimeField1 - DateTimeField2) DAY(4) to SECOND(4) FROM dateTable;
--Output:--> 54:56:00
--Above output is 54 hours, 56 minutes & 0 seconds

--
-- ex: Difference in Minutes to Seconds: Returns output difference values in minutes & seconds.
SELECT (DateTimeField1 - DateTimeField2) MINUTE(4) to SECOND(4) FROM dateTable;
--Output:--> 3296:00
--Above output is 3296 minutes  & 0 seconds

--
-- ex: Difference in Seconds: Returns output difference values in seconds.
SELECT (DateTimeField1 - DateTimeField2) SECOND(4) FROM dateTable;
--Output:--> will fail since timestamp difference(197,760) is more than 9999 seconds

SELECT (DateTimeField4 - DateTimeField3) SECOND(4) FROM dateTable;
--Output:--> 3750
--Above output is 3750 seconds


-- ####################################################### 
-- CASE
-- ####################################################### 

SELECT EmployeeNo,
    CASE
        DepartmentNo
        WHEN 1 THEN 'Admin'
        WHEN 2 THEN 'IT'
        ELSE 'Invalid Dept'
    END AS Department
FROM db_schema.dql_test_table1;


SELECT EmployeeNo,
    CASE
        WHEN DepartmentNo = 1 THEN 'Admin'
        WHEN DepartmentNo = 2 THEN 'IT'
        ELSE 'Invalid Dept'
    END AS Department
FROM db_schema.dql_test_table1;


SELECT 
   EmployeeNo, 
   COALESCE(dept_no, 'Department not found') 
FROM  
   db_schema.dql_test_table1;


SELECT 
   EmployeeNo,  
   NULLIF(DepartmentNo,3) AS department 
FROM db_schema.dql_test_table1;



-- ####################################################### 
-- JOINS
-- ####################################################### 

--
-- INNER JOIN 
SELECT A.EmployeeNo,
    A.DepartmentNo,
    B.NetPay
FROM db_schema.dql_test_table1 A
    INNER JOIN db_schema.dql_test_table2 B ON (A.EmployeeNo = B.EmployeeNo);

--
-- INNER JOIN 
SELECT A.EmployeeNo,
    A.DepartmentNo,
    B.NetPay
FROM db_schema.dql_test_table1 A, db_schema.dql_test_table2 B 
WHERE A.EmployeeNo = B.EmployeeNo;


--
-- LEFT OUTER JOIN 
SELECT A.EmployeeNo,
    A.DepartmentNo,
    B.NetPay
FROM db_schema.dql_test_table1 A
    LEFT OUTER JOIN db_schema.dql_test_table2 B ON (A.EmployeeNo = B.EmployeeNo)
ORDER BY A.EmployeeNo;

--
-- RIGHT OUTER JOIN
SELECT A.EmployeeNo,
    A.DepartmentNo,
    B.NetPay
FROM db_schema.dql_test_table1 A
    RIGHT OUTER JOIN db_schema.dql_test_table2 B ON (A.EmployeeNo = B.EmployeeNo)
ORDER BY A.EmployeeNo;

--
-- FULL OUTER JOIN 
SELECT A.EmployeeNo,
    A.DepartmentNo,
    B.NetPay
FROM db_schema.dql_test_table1 A
    FULL OUTER JOIN db_schema.dql_test_table2 B ON (A.EmployeeNo = B.EmployeeNo)
ORDER BY A.EmployeeNo;


--
-- CROSS JOIN 
SELECT A.EmployeeNo,
    A.DepartmentNo,
    B.EmployeeNo,
    B.NetPay
FROM db_schema.dql_test_table1 A
    CROSS JOIN db_schema.dql_test_table2 B
WHERE A.EmployeeNo = 101
ORDER BY B.EmployeeNo;


-- ####################################################### 
-- SubQueries
-- ####################################################### 

SELECT EmployeeNo,
    NetPay
FROM db_schema.dql_test_table2
WHERE NetPay = (
        SELECT MAX(NetPay)
        FROM db_schema.dql_test_table2
    );


SELECT Emp.EmployeeNo,
    Emp.FirstName,
    Empsal.NetPay
FROM db_schema.dql_test_table1 Emp,
    (
        select EmployeeNo,
            NetPay
        from db_schema.dql_test_table2
        where NetPay >= 75000
    ) Empsal
where Emp.EmployeeNo = Empsal.EmployeeNo;  


-- ####################################################### 
-- OLAP Queries
-- ####################################################### 

--
--
SELECT EmployeeNo,
    NetPay,
    SUM(Netpay) OVER(
        ORDER BY EmployeeNo ROWS UNBOUNDED PRECEDING
    ) as TotalSalary
FROM db_schema.dql_test_table2;

--
-- RANK
SELECT EmployeeNo,
    JoinedDate,
    RANK() OVER(
        ORDER BY JoinedDate
    ) as Seniority
FROM db_schema.dql_test_table1;

--
-- PARTITION BY
SELECT EmployeeNo,
    JoinedDate,
    RANK() OVER(
        PARTITION BY DeparmentNo
        ORDER BY JoinedDate
    ) as Seniority
FROM Employee;


--
-- Cumulative Distinct Count
-- source: https://dbmstutorials.com/random_teradata/teradata-cumulative-distinct-count.html
SELECT rptg_dt,
    cum_distinct_cnt
FROM (
        --Step 2:
        SELECT id,
            rptg_dt,
            COUNT(id) OVER (
                ORDER BY rptg_dt ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS cum_distinct_cnt
        FROM (
                --Step 1:
                SELECT id,
                    rptg_dt,
                    ROW_NUMBER() OVER (
                        PARTITION BY id
                        ORDER BY rptg_dt
                    ) row_num
                FROM product_sale QUALIFY (
                        ROW_NUMBER() OVER (
                            PARTITION BY id
                            ORDER BY rptg_dt
                        )
                    ) = 1
            ) innerTab1
    ) innerTab2 QUALIFY ROW_NUMBER() OVER (
        PARTITION BY rptg_dt
        ORDER BY cum_distinct_cnt DESC
    ) = 1;


