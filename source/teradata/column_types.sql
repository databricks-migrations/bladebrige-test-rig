-- Teradata supported Data types:
--  Source: https://docs.teradata.com/r/iRq_F~XxKYWu7Kv~HRd~ew/D_RBrANpKte9E5uvWjq8~Q
--
-- Common 
--


-- ARRAY/VARRAY : One-dimensional (1-D) ARRAY
--                Multidimensional (n-D) ARRAY
-- Byte         : BYTE
--                VARBYTE
--                BLOB (Binary Large Object)
-- Character    : CHAR
--                VARCHAR
--                CLOB
-- DATASET      : AVRO
--
-- https://docs.teradata.com/r/S0Fw2AVH8ff3MDA0wDOHlQ/1tP2SXzgK9fDfRaZzILb3A
-- DateTime     : DATE
--                TIME
--                TIMESTAMP
--                TIME WITH TIME ZONE
--                TIMESTAMP WITH TIME ZONE
-- Geospatial   : ST_Geometry
--                MBR
-- Interval     : INTERVAL YEAR
--                INTERVAL YEAR TO MONTH
--                INTERVAL MONTH
--                INTERVAL DAY
--                INTERVAL DAY TO HOUR
--                INTERVAL DAY TO MINUTE
--                INTERVAL DAY TO SECOND
--                INTERVAL HOUR
--                INTERVAL HOUR TO MINUTE
--                INTERVAL HOUR TO SECOND
--                INTERVAL MINUTE
--                INTERVAL MINUTE TO SECOND
--                INTERVAL SECOND
-- JSON         : JSON
-- Numeric      : BYTEINT
--                 SMALLINT
--                 INTEGER
--                 BIGINT
--                 DECIMAL/NUMERIC
--                 FLOAT/REAL/DOUBLE PRECISION
--                 NUMBER
-- Parameter     : TD_ANYTYPE
--                 VARIANT_TYPE
-- Period        : PERIOD(DATE)
--                 PERIOD(TIME)
--                 PERIOD(TIME WITH TIME ZONE)
--                 PERIOD(TIMESTAMP)
--                 PERIOD(TIMESTAMP WITH TIME ZONE)
-- UDT           : Distinct
--                 Structured
-- XML           : XML


-- Data Type Attributes:
--  NOT NULL
--  UPPERCASE
--  [NOT] CASESPECIFIC
--  DEFAULT
--  WITH DEFAULT
--  WITH TIME ZONE
--  CHARACTER SET


CREATE SET TABLE CommonColumnTypes_Byte_Test, FALLBACK
(
    id int,
    --Byte
    byte_type_col       BYTE(4),
    varbyte_type_col    VARBYTE(1024),
    blob_type_col       BLOB(128K)
)
UNIQUE PRIMARY INDEX (id)
;

CREATE SET TABLE CommonColumnTypes_Character_Test, FALLBACK
(
    id int,
    --Character
    char_type_col1      CHAR(3),
    char_type_col2      CHARACTER NOT NULL UPPERCASE,
    char_type_col3      CHARACTER(3) CHARACTER SET GRAPHIC,    
    varchar_type_col1   VARCHAR(10) NOT NULL,
    varchar_type_col2   VARCHAR(1000) NULL,
    varchar_type_col3   LONG VARCHAR,
    clob_type_col1      CLOB,
    clob_type_col2      CLOB(2K) CHARACTER SET UNICODE
)
UNIQUE PRIMARY INDEX (id)
;

CREATE SET TABLE CommonColumnTypes_DateTime_Test, FALLBACK
(
    id int,
    --DateTime
    date_type_col1      DATE FORMAT 'YYYY-MM-DD' NOT NULL,
    date_type_col2      DATE NOT NULL FORMAT 'YYYY-MM-DD' DEFAULT DATE '2000-01-01',
    time_type_col1      TIME(0),
    time_type_col2      TIME(6),
    time_type_col3      TIME(6)  WITH TIME ZONE,
    timestamp_type_col1 TIMESTAMP(0),
    timestamp_type_col2 TIMESTAMP(6),
    timestamp_type_col3 TIMESTAMP(6) WITH TIME ZONE
)
UNIQUE PRIMARY INDEX (id)
;

CREATE SET TABLE CommonColumnTypes_Numeric_Test, FALLBACK
(
    id int,
    -- Numeric
    byteint_type_col    BYTEINT FORMAT 'Z9',
    smallint_type_col   SMALLINT FORMAT '999' BETWEEN 10 AND 500,
    int_type_col        INTEGER,
    int_type_col2       INT,
    bigint_type_col     BIGINT,
    decimal_type_col1    DECIMAL(8,2) FORMAT 'ZZZ,ZZ9.99',
    decimal_type_col2    DECIMAL(8),
    decimal_type_col3    DEC(8,2),
    numeric_type_col1    NUMERIC(8,2),
    numeric_type_col2    NUMERIC(8),
    float_type_col1     FLOAT BETWEEN .1 AND 1E1,
    real_type_col1      REAL,
    double_precision_type_col1      DOUBLE PRECISION
)
UNIQUE PRIMARY INDEX (id)
;

CREATE SET TABLE CommonColumnTypes_Number_Test, FALLBACK
(
    id int,
    --number
    number_type1 NUMBER(*,3),
    number_type2 NUMBER,
    number_type3 NUMBER(*),
    number_type4 NUMBER(5,1),
    number_type5 NUMBER(3)    
)
UNIQUE PRIMARY INDEX (id)
;



-- Interval
CREATE SET TABLE AdvancedColumnTypes_Interval_Test1
(
    id INTEGER,
    -- YEAR
    i_year_type_col1            INTERVAL YEAR,
    i_year_type_col2            INTERVAL YEAR(4),
    i_year_to_month_type_col1   INTERVAL YEAR TO MONTH,
    i_year_to_month_type_col2   INTERVAL YEAR (4) TO MONTH,
    -- MONTH
    i_month_type_col1   INTERVAL MONTH,
    i_month_type_col2   INTERVAL MONTH (4),
    -- DAY
    i_day_type_col1   INTERVAL DAY,
    i_day_type_col2   INTERVAL DAY (4),
    i_day_to_hour_type_col1  INTERVAL DAY TO HOUR,
    i_day_to_hour_type_col2  INTERVAL DAY(4) TO HOUR,
    i_day_to_min_type_col1   INTERVAL DAY TO MINUTE,
    i_day_to_min_type_col2   INTERVAL DAY(4) TO MINUTE,
    i_day_to_sec_type_col1   INTERVAL DAY TO SECOND,
    i_day_to_sec_type_col2   INTERVAL DAY TO SECOND(6),
    i_day_to_sec_type_col3   INTERVAL DAY(4) TO SECOND(6),
    i_day_to_sec_type_col4   INTERVAL DAY(4) TO SECOND,
    -- HOUR
    i_hour_type_col1   INTERVAL HOUR,
    i_hour_type_col2   INTERVAL HOUR (4),
    i_hour_to_min_type_col1   INTERVAL HOUR TO MINUTE,
    i_hour_to_min_type_col2   INTERVAL HOUR (4) TO MINUTE,
    i_hour_to_sec_type_col1   INTERVAL HOUR TO SECOND,
    i_hour_to_sec_type_col2   INTERVAL HOUR TO SECOND(6),
    i_hour_to_sec_type_col3   INTERVAL HOUR(4) TO SECOND(6),
    i_hour_to_sec_type_col4   INTERVAL HOUR(4) TO SECOND,
    -- MINUTE
    i_min_type_col1   INTERVAL MINUTE,
    i_min_type_col2   INTERVAL MINUTE (4),
    i_min_to_sec_type_col1   INTERVAL MINUTE TO SECOND,
    i_min_to_sec_type_col2   INTERVAL MINUTE TO SECOND(6),
    i_min_to_sec_type_col3   INTERVAL MINUTE(4) TO SECOND(6),
    i_min_to_sec_type_col4   INTERVAL MINUTE(4) TO SECOND,
    -- SECOND
    i_sec_type_col1   INTERVAL SECOND,
    i_sec_type_col2   INTERVAL SECOND (4, 6)
)
;

-- DATASET
CREATE SET TABLE AdvancedColumnTypes_Dataset_Test1
(
    id INTEGER,
    --DataSet
    avroFile DATASET STORAGE FORMAT Avro
)
;

-- DATASET
CREATE SET TABLE AdvancedColumnTypes_Dataset_Test2
(
    id INTEGER,
    --DataSet
    avroFile DATASET STORAGE FORMAT Avro WITH SCHEMA xDatasetSchema
)
;

-- DATASET
CREATE SET TABLE AdvancedColumnTypes_Dataset_Test3
(
    id INTEGER,
    --DataSet
    compressibleAvroFile DATASET STORAGE FORMAT AVRO
		COMPRESS USING SNAPPY_COMPRESS
		DECOMPRESS USING SNAPPY_DECOMPRESS
)
;

-- Geospatial
CREATE SET TABLE AdvancedColumnTypes_Geospatial_Test3
(
    id INTEGER,
    cityName VARCHAR(40),
    cityShape ST_GEOMETRY,
    cityShapeMbr MBR
)
;

-- JSON
CREATE SET TABLE AdvancedColumnTypes_Json_Test
(
    id INTEGER,
    json_1 JSON,
    json_2 JSON(1024),
    json_3 JSON(512) STORAGE FORMAT BSON,
    json_4 JSON(512) STORAGE FORMAT UBJSON,
    json_5 JSON(100) CHARACTER SET UNICODE
)
;

-- Period
CREATE TABLE AdvancedColumnTypes_Period_Test
(
    id INTEGER ,
    period_date_type_col   PERIOD(DATE) DEFAULT PERIOD '(2001-01-01, 2010-12-31)',
    period_time_type_col   PERIOD(TIME),
    period_time_zone_type_col   PERIOD(TIME WITH TIME ZONE),
    period_timestamp_type_col   PERIOD(TIMESTAMP),
    period_timestamp_zone_type_col   PERIOD(TIMESTAMP WITH TIME ZONE)
);

-- UDT 
--
-- CREATE TYPE xEuro
--   AS DECIMAL(8,2)
--   FINAL;
-- 
-- GRANT UDTUSAGE ON SYSUDTLIB TO bladebridge;

CREATE TABLE AdvancedColumnTypes_UDT_Test
(
    id INTEGER ,
    sales xEuro
);


-- ARRAY
-- Same as UDT
CREATE TYPE clothing_inv_ARY AS INTEGER ARRAY [2][4][3]
;

CREATE TABLE AdvancedColumnTypes_Array_Test (
   Clothing_Type VARCHAR(10),
   Clothing_Inventory clothing_inv_ARY
)
;

UPDATE AdvancedColumnTypes_Array_Test
   SET clothing_inventory [2][2][3] = 999
   WHERE clothing_type = 'Sweatpants'
   ;

SELECT clothing_inventory [2][2][3]
   FROM AdvancedColumnTypes_Array_Test
   WHERE clothing_type = 'Sweatpants'
   ;

SELECT ARRAY_SUM(clothing_inventory, NEW arrayVec(1,1,1), NEW arrayVec(1,1,3))
   FROM AdvancedColumnTypes_Array_Test 
   WHERE clothing_type = 'Sweatpants'
   ;

-- XML Type
CREATE TABLE AdvancedColumnTypes_XML_Test
(
    id INTEGER ,
    xml_payload XML
);

-- XML Operations: FIXME 
--