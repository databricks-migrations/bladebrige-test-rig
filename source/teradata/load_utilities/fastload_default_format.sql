.SESSIONS 2;
.logon NODEID/fluser,
.SHOW VERSION;
DEFINE
     FIELD1 (integer),
     FIELD2 (char(10)),
     FILE=FDAT02;
BEGIN LOADING FL0020
     ERRORFILES FL0020e1,FL0020e2 checkpoint 100;
SHOW;
INSERT INTO FL0020(A,B)
     VALUES (:field1,:FIELD2);
LOGOFF;