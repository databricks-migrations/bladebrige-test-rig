
-- Tables
--

-- Table Kind SET or MULTISET
--SET Tables

--##############################################################
--@ Constraints: Column level and Table level
--##############################################################
-- 1. UNIQUE
-- CONSTRAINT constraint_name UNIQUE (column_name)


-- 2. PRIMARY KEY ( Unique)
-- CONSTRAINT constraint_name PRIMARY KEY (Columns..)


-- 3. FOREIGN KEY
-- CONSTRAINT reference_1
--      FOREIGN KEY (column_5, column_6) 
--      REFERENCES parent_1 (column_2, column_3)

-- 4. CHECK
-- CONSTRAINT check_1 CHECK (column_3 > 0 OR column_4 IS NOT NULL),

-- source: https://docs.teradata.com/r/eWpPpcMoLGQcZEoyt5AjEg/IEGchL9GChJgIJTiksS7tQ
CREATE TABLE table_ddl_with_constraints_test1 (
      column_1 INTEGER NOT NULL,
      column_2 INTEGER NOT NULL,
      column_3 INTEGER NOT NULL,
      column_4 INTEGER NOT NULL,
      column_5 INTEGER,
      column_6 INTEGER, 
      CONSTRAINT primary_1
      PRIMARY KEY (column_1, column_2),
      CONSTRAINT unique_1
      UNIQUE (column_3, column_4),
      CONSTRAINT check_1
      CHECK (column_3 > 0 OR column_4 IS NOT NULL),
      CONSTRAINT reference_1
      FOREIGN KEY (column_5, column_6) 
      REFERENCES parent_1 (column_2, column_3)
);

CREATE TABLE table_ddl_with_constraints_test2 (
      column_1 INTEGER NOT NULL
      CONSTRAINT primary_1 
      PRIMARY KEY,
      column_2 INTEGER NOT NULL
      CONSTRAINT unique_1 UNIQUE
      CONSTRAINT check_1
       CHECK (column_2 <> 3)
      CONSTRAINT reference_1
       REFERENCES parent_1
       CHECK (column_2 > 0)
       REFERENCES parent_1 (column_4),
      column_3 INTEGER NOT NULL,
      column_4 INTEGER NOT NULL,
      column_5 INTEGER,
       CONSTRAINT unique_2 UNIQUE (column_3),
       CONSTRAINT check_2
       CHECK (column_3 > 0 AND column_3 < 100),
       CONSTRAINT reference_2
     FOREIGN KEY (column_3)
     REFERENCES parent_1 (column_5), UNIQUE (column_4),
       CHECK (column_4 > column_5),
     FOREIGN KEY (column_4, column_5)
     REFERENCES parent_1 (column_6, column_7)
);

--##############################################################
--@ IDENTITY columns
--##############################################################
-- GENERATED ALWAYS AS IDENTITY
-- GENERATED BY DEFAULT AS IDENTITY

-- source: https://www.teradatapoint.com/teradata/teradata-identity-column.htm
CREATE TABLE table_ddl_with_identity_column_test1
(
    roll_no INT GENERATED ALWAYS AS IDENTITY
    (START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 99999
    NO CYCLE),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender CHAR(1) NOT NULL
);

--##############################################################
--@ PRIMARY INDEX (Unique|Non Unique)
--##############################################################
-- source: https://docs.teradata.com/r/eWpPpcMoLGQcZEoyt5AjEg/q782gR8d7ApfIwWYj_JIdQ
 CREATE TABLE table_ddl_with_unique_primary_index_test1 (
       emp_no    SMALLINT FORMAT '9(5)' 
                 CHECK (emp_no >= 10001 AND emp_no <= 32001) NOT NULL, 
       name      VARCHAR(12) NOT NULL, 
       dept_no   SMALLINT FORMAT '999' 
                 CHECK (dept_no >= 100 AND dept_no <= 900), 
       job_title VARCHAR(12), 
       salary    DECIMAL(8,2) FORMAT 'ZZZ,ZZ9.99' 
                 CHECK (salary >= 1.00 AND salary <= 999000.00), 
       yrs_exp   BYTEINT FORMAT 'Z9' 
                 CHECK(yrs_exp >= -99 AND yrs_exp <=99), 
       dob       DATE FORMAT 'MMMbDDbYYYY' NOT NULL, 
       sex       CHARACTER UPPERCASE NOT NULL 
                 CHECK (sex IN ('M','F')),
       race      CHARACTER UPPERCASE, 
       m_stat    CHARACTER UPPERCASE 
                 CHECK (m_stat IN ('S','M','D','U')),
       ed_lev     BYTEINT FORMAT 'Z9' 
                 CHECK (ed_lev >=0 AND ed_lev <=22) NOT NULL, 
       h_cap     BYTEINT FORMAT 'Z9' 
                 CHECK (h_cap >= -99 AND h_cap <= 99)
                 )
    UNIQUE PRIMARY INDEX (emp_no), 
    UNIQUE INDEX (name)
;

CREATE TABLE table_ddl_with_nonunique_primary_index_test1 (
    storeid         INTEGER NOT NULL,
    productid       INTEGER NOT NULL,
    salesdate       DATE FORMAT 'yyyy-mm-dd' NOT NULL,
    totalrevenue    DECIMAL(13,2),
    note            VARCHAR(256)
  )
  PRIMARY INDEX (storeid, productid)
  ;

--##############################################################
--@ PRIMARY INDEX (Unique|Non Unique)
--##############################################################
-- https://docs.teradata.com/r/eWpPpcMoLGQcZEoyt5AjEg/e0GX8Iw16u1SCwYvc5qXzg


-- Partitioned primary indexes (PPI):
--- (PPI) permits rows to be assigned to user-defined data partitions on the AMPs. A PPI is defined to be either single-level or multilevel. Multilevel partitioning allows each partition to be subpartitioned.
CREATE TABLE table_ddl_with_nonunique_pprimary_index_test1 (
 (
   StoreNo SMALLINT, 
   OrderNo INTEGER, 
   OrderDate DATE FORMAT 'YYYY-MM-DD', 
   OrderTotal INTEGER 
) 
PRIMARY INDEX(OrderNo) 
PARTITION BY RANGE_N  (
   OrderDate BETWEEN DATE '2010-01-01' AND '2016-12-31' EACH INTERVAL '1' DAY
);


-- primary AMP index
-- What is the signifcance of this - probably distribute by clause in selects
-- Don't need this

-- Partition by Expression
-- CASE_N partitioning
CREATE TABLE table_ddl_with_partition_by_test1 (
       cust_name              CHARACTER(8),
       policy_number          INTEGER,
       policy_expiration_date DATE FORMAT 'YYYY/MM/DD')
     PRIMARY INDEX (cust_name, policy_number)
     PARTITION BY CASE_N(policy_expiration_date>= CURRENT_DATE, NO CASE)
     ;

CREATE TABLE table_ddl_with_partition_by_test2 (
    -- store_revenue
      store_id      INTEGER NOT NULL,
      product_id    INTEGER NOT NULL,
      sales_date    DATE FORMAT 'yyyy-mm-dd' NOT NULL,
      total_revenue DECIMAL(13,2)
      total_sold    INTEGER
      note          VARCHAR(256))
    UNIQUE PRIMARY INDEX (store_id, product_id, sales_date)
    PARTITION BY CASE_N(total_revenue <   10000, 
                        total_revenue <  100000, 
                        total_revenue < 1000000, 
                        NO CASE, UNKNOWN);

-- RANGE_N paritioning
CREATE TABLE table_ddl_with_partition_by_test3 (
    --sales
      store_id      INTEGER NOT NULL,
      product_id    INTEGER NOT NULL,
      sales_date    DATE FORMAT 'yyyy-mm-dd' NOT NULL,
      total_revenue DECIMAL(13,2),
      total_sold    INTEGER,
      note          VARCHAR(256))
    UNIQUE PRIMARY INDEX (store_id, product_id, sales_date)
    PARTITION BY RANGE_N(sales_date BETWEEN DATE '2001-01-01' 
                                    AND     DATE '2001-05-31' 
                                    EACH INTERVAL '1' DAY);

-- RANGE_N paritioning
--
CREATE TABLE table_ddl_with_partition_by_test4 (
    --lineitem
      l_orderkey      INTEGER NOT NULL,
      l_partkey       INTEGER NOT NULL,
      l_suppkey       INTEGER,
      l_linenumber    INTEGER,
      l_quantity      INTEGER NOT NULL,
      l_extendedprice DECIMAL(13,2) NOT NULL,
      l_discount      DECIMAL(13,2),
      l_tax           DECIMAL(13,2),
      l_returnflag    CHARACTER(1),
      l_linestatus    CHARACTER(1),
      l_shipdate      DATE FORMAT 'yyyy-mm-dd',
      l_commitdate    DATE FORMAT 'yyyy-mm-dd',
      l_receiptdate   DATE FORMAT 'yyyy-mm-dd',
      l_shipinstruct  VARCHAR(25),
      l_shipmode      VARCHAR(10),
      l_comment       VARCHAR(44))
    PRIMARY INDEX (l_orderkey)
    PARTITION BY RANGE_N(l_shipdate BETWEEN DATE '1992-01-01' 
                                    AND     DATE '1998-12-31' 
                                    EACH INTERVAL '1' MONTH);

-- Partition by EXTRACT a.k.a expression
--
 CREATE TABLE table_ddl_with_partition_by_test5 (
     -- sales_by_month
      store_id      INTEGER NOT NULL,
      product_id    INTEGER NOT NULL,
      sales_date    DATE FORMAT 'yyyy-mm-dd' NOT NULL,
      total_revenue DECIMAL(13,2),
      total_sold    INTEGER,
      note          VARCHAR(256))
    UNIQUE PRIMARY INDEX (store_id, product_id, sales_date)
    PARTITION BY EXTRACT(MONTH FROM sales_date)
    ;

CREATE TABLE table_ddl_with_partition_by_test6 (
      store_id      INTEGER NOT NULL BETWEEN 0 AND 64,
      product_id    INTEGER NOT NULL BETWEEN 0 and 999,
      sales_date    DATE FORMAT 'yyyy-mm-dd' NOT NULL,
      total_revenue DECIMAL(13,2),
      total_sold    INTEGER,
      note          VARCHAR(256))
    UNIQUE PRIMARY INDEX (store_id, product_id, sales_date)
    PARTITION BY store_id*1000 + product_id + 1
    ;

-- Multi level Partitioning
-- Just Skip it

-- Secondary indexes
--  Not a big deal
Join indexes (materialized views)



-- CTAS tables
--