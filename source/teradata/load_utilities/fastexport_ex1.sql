/** source: https://docs.teradata.com/r/Teradata-FastExport-Reference/May-2017/Overview/FastExport-Commands/Teradata-SQL-Statements
*/

.LOGTABLE utillog ;                 /* define restart log            */

.LOGON tdpz/user,pswd ;             /* DBC logon string              */

.BEGIN EXPORT                       /* specify export function       */
   SESSIONS 20;                     /* number of sessions to be used */

.LAYOUT UsingData ;                 /* define the input data         */
  .FIELD ProjId * Char(8) ;         /* values for the SELECT         */
  .FIELD WkEnd * Date ;             /* constraint clause.            */
  
.IMPORT INFILE ddname1              /* identify the file that        */
   LAYOUT UsingData ;               /* contains the input data       */
   
.EXPORT OUTFILE ddname2 ;           /* identify the destination      */
                                    /* file for exported data        */
SELECT EmpNo, Hours FROM CHARGES    /* provide the SQL SELECT        */
   WHERE WkEnd = :WkEnd             /* statement with values         */
   AND Proj_ID = :ProjId            /* provided by the IMPORT        */
   ORDER BY EmpNo ;                 /* command                       */
.END EXPORT ;                       /* terminate the export          */

                                    /* operation                     */
.LOGOFF ;                           /* disconnect from the DBS       */