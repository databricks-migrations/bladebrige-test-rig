.SET width 64000;
.SET session transaction btet;
.logmech ldap
.logon XXXXXXX/XXXXXXXX,********;

DATABASE corecm;

-- When you define VARTEXT all input columns must be defined as VARCHAR
.PACK 1000
.IMPORT VARTEXT '~' FILE=/v/global/user/application_event_bus_evt
.REPEAT *
USING(
    iAPPLICATION_EVENT_ID VARCHAR(24),
    iBUS_EVT_RESTATE_IN VARCHAR(7),    
    iBUS_EVT_ID VARCHAR(24),
    iBUS_EVT_VID VARCHAR(19)
)

insert into corecm.application_event_bus_evt (
  APPLICATION_EVENT_ID
, BUS_EVT_ID
, BUS_EVT_VID
, BUS_EVT_RESTATE_IN
)
values
( COALESCE(:iAPPLICATION_EVENT_ID,1)
, COALESCE(:iBUS_EVT_ID,1)
, COALESCE(:iBUS_EVT_VID,1)
, COALESCE(:iBUS_EVT_RESTATE_IN,1)
) ;
.LOGOFF;
.EXIT;