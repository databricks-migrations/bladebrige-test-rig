--
-- source: https://docs.teradata.com/r/RtERtp_2wVEQWNxcM3k88w/8Rgb8GYoz2y7mr3lpH4NLQ

-- USI
CREATE UNIQUE INDEX (customer_number) 
ON customer_table
;

-- NUSI
CREATE INDEX (customer_name) 
ON customer_table
;


CREATE INDEX (department_number) ON EMPLOYEE
;
CREATE INDEX (job_code) ON EMPLOYEE
;


--  How handle the the join indexes a.k.a Materialized views 
--  Not sure if we need to convert these
--      if users cannot query the join indexes directlt and used only for query performance - we don't need these
--  One option is to convert them to CTAS syntax and obviously no auto refresh supported on Databricks
--  

--
-- source: https://docs.teradata.com/r/RtERtp_2wVEQWNxcM3k88w/3FK~sG6BR~GxTC~M8BvlCA

CREATE JOIN INDEX cust_ord2
   AS SELECT cust.customerid,cust.loc,ord.ordid,item,qty,odate
   FROM cust, ord, orditm
   WHERE cust.customerid = ord.customerid
   AND ord.ordid = orditm.ordid
   ;
