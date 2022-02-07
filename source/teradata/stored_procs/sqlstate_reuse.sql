--
-- Example: Reusing the SQLSTATE Code
--
CREATE PROCEDURE spSample (OUT po1 VARCHAR(50),
                            OUT po2 VARCHAR(50))
BEGIN
    DECLARE i INTEGER DEFAULT 0;
    L1: BEGIN
        DECLARE var1 VARCHAR(25) DEFAULT 'ABCD';
        DECLARE CONTINUE HANDLER FOR SQLSTATE '42000'
            SET po1 = "Table does not exist in L1";
        INSERT INTO tDummy (10, var1);
        -- Table does not exist.
        L2: BEGIN
            DECLARE var1 VARCHAR(25) DEFAULT 'XYZ';
            DECLARE CONTINUE HANDLER FOR SQLSTATE '42000'
                SET po2 = "Table does not exist in L2";
            INSERT INTO tDummy (i, var1);
        -- Table does not exist.
        END L2;
    END L1;
END;