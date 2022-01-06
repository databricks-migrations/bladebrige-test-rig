
-- Column Attributes: Col Attributes to test
--                      NOT NULL
--                      UPPERCASE
--                      NOT CASESPECIFIC
--                      DEFAULT
--                      WITH DEFAULT
--                      WITH TIME ZONE
--                      CHARACTER SET

CREATE  TABLE ColumnAttributes_Test1
(
    id INTEGER,
    col1 VARCHAR(40) NOT NULL UPPERCASE,
    col2 VARCHAR(40) UPPERCASE,
    col3 VARCHAR(40) NOT CASESPECIFIC,
    col4 VARCHAR(40) CASESPECIFIC,
    col5 VARCHAR(40) NOT CS,
    col6 VARCHAR(40) CS,
    col7 DATE NOT NULL FORMAT 'YYYY-MM-DD' DEFAULT DATE '2000-01-01',
    col8 BYTEINT FORMAT 'Z9' NOT NULL WITH DEFAULT,
    col9  timestamp(0) with time zone,
    col10 CHARACTER(3) CHARACTER SET GRAPHIC
)
;
