--
-- Example: Associating a Handler Action with Multiple Condition Names
--

CREATE PROCEDURE condsp2 (INOUT IOParam2 INTEGER,
                             OUT OParam3 CHAR(30))
   Cs1: BEGIN
      DECLARE divide_by_zero CONDITION FOR SQLSTATE '22012';
      DECLARE table_does_not_exist CONDITION FOR SQLSTATE '42000';
      DECLARE CONTINUE HANDLER
         FOR divide_by_zero, table_does_not_exist
            SET OParam3 = 0;
      SET IOParam2=0;
      SET OParam3 = 20/IOParam2;    /* raises exception 22012 */
      INSERT notab VALUES (IOParam2 + 20); /* raises exception 42000 */
   END Cs1;