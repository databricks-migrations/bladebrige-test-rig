--
-- source: https://docs.teradata.com/r/CeAGk~BNtx~axcR0ed~5kw/qkt9pvPjUNPQbCaRXlerBQ
--
-- Example: Dynamic Form of the DECLARE Statement
--
CREATE PROCEDURE sp1 (IN SqlStr VARCHAR(50), IN a INT)
   DYNAMIC RESULT SETS 1
   BEGIN
     DECLARE c1 CURSOR WITH RETURN ONLY FOR s1;
     PREPARE s1 FROM SqlStr;
     OPEN c1 USING a;
   END;
