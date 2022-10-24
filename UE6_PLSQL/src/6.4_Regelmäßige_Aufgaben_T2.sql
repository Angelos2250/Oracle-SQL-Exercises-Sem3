INSERT INTO monitor_sessions(MS_ID,COUNT,LAST_CHECK)
VALUES (
DEFAULT,
(SELECT COUNT(SID)
FROM V$SESSION
WHERE SCHEMANAME <> 'SYS'),
SYSDATE
);
ALTER SESSION SET NLS_DATE_FORMAT = 'yyyy-mm-dd hh24:mi:ss';

BEGIN
  DBMS_SCHEDULER.CREATE_SCHEDULE(
      schedule_name => 'weekcycle'
    , start_date =>  '14/11/2021 09:30:00'      -- frühester Start
    , repeat_interval => 'FREQ=MINUTELY; INTERVAL=30;'           -- jeden Tag um 15, 16, 17 und 18 Uhr
    ,end_date        => SYSDATE + 7
    , comments => 'every 30 minutes');
END;

BEGIN
  DBMS_SCHEDULER.CREATE_JOB(
       job_name      => 'Countsessionsweekly'
     , job_type      => 'PLSQL_BLOCK'
     , job_action    => '   DECLARE INSERT INTO monitor_sessions(MS_ID,COUNT,LAST_CHECK)
                            VALUES (
                            DEFAULT,
                            (SELECT COUNT(SID)
                            FROM V$SESSION
                            WHERE USERNAME IS NOT NULL,
                            SYSDATE
                            );'         -- Name der Prozedur
     , schedule_name => 'weekcycle'     -- Schedule verwenden
     , enabled => TRUE
     , comments => 'Insert Session count every 30 Minutes');
END;

SELECT *
FROM monitor_sessions;

SELECT MS_ID,LAST_CHECK,COUNT,AVG(COUNT) OVER (ORDER BY LAST_CHECK ROWS BETWEEN 6 PRECEDING AND 6 FOLLOWING) AS AVG
FROM MONITOR_SESSIONS;

