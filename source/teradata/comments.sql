--
-- Comments handling, Ideally we need to retain both line comments and column level comments
-- Line comments before SQL statements/queries can be converted to 
--    single lines to Notebook cell title
--    Multiple lines to Notebook markdown cell 
--


-- DDL with ANSI style Comments
CREATE TABLE table_ddl_with_comments_test1 (
    --lineitem
      l_orderkey      INTEGER NOT NULL, -- order key
      l_partkey       INTEGER NOT NULL, -- part key
      l_suppkey       INTEGER,  -- supplier key
    --lineitem details
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
      l_comment       VARCHAR(44) -- remarks
)


/* DDL with C style Comments 
   Multiline
*/
CREATE TABLE table_ddl_with_comments_test2 (
    /*lineitem */
      l_orderkey      INTEGER NOT NULL, /* order key */
      l_partkey       INTEGER NOT NULL, /* part key */
      l_suppkey       INTEGER,
    --lineitem details
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
      l_comment       VARCHAR(44) -- remarks
)