--
-- Example: Using a Condition Name and Its Associated SQLSTATE Value in a Handler
-- 
CREATE PROCEDURE condsp1 (INOUT IOParam2 INTEGER,
                            OUT OParam3 INTEGER)
cs1: BEGIN
    DECLARE divide_by_zero CONDITION FOR SQLSTATE '22012';
    DECLARE EXIT HANDLER
        FOR divide_by_zero, SQLSTATE '42000'
        SET OParam3 = 0;
    SET IOParam2 = 0;
    SET OParam3 = 20/IOParam2;    /* raises exception 22012 */
END cs1;
