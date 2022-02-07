--
-- source: https://docs.teradata.com/r/CeAGk~BNtx~axcR0ed~5kw/qkt9pvPjUNPQbCaRXlerBQ
-- Example: Static Form of the DECLARE CURSOR Statement
--
CREATE PROCEDURE Sample_p (INOUT c INTEGER)
       DYNAMIC RESULT SETS 2
    BEGIN
       DECLARE cur1 CURSOR WITH RETURN ONLY FOR
          SELECT * FROM m1;
       DECLARE cur2 CURSOR WITH RETURN ONLY FOR
          SELECT * FROM m2 WHERE m2.a > c;
       SET c = c +1;
       OPEN cur1;
       OPEN cur2;
    END;
