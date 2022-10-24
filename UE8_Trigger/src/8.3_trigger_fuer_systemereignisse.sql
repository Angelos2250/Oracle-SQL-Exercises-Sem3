CREATE TABLE user_logging (
    sessionid NUMBER PRIMARY KEY,
    login_time DATE,
    db_user VARCHAR2(128),
    os_user varchar2(128),
    ip varchar2(256),
    host_name varchar2(256)
);

SELECT SYS_CONTEXT('userenv', 'ip_address') FROM dual;

CREATE OR REPLACE TRIGGER user_logging_trg
   AFTER LOGON ON SCHEMA
BEGIN
    INSERT INTO user_logging (sessionid, login_time, db_user, os_user, ip, host_name)
    VALUES(SYS_CONTEXT('userenv', 'sid'), SYSDATE, USER, SYS_CONTEXT('userenv', 'os_user'),  SYS_CONTEXT('userenv', 'ip_address'), SYS_CONTEXT('userenv', 'host'));
END;
/
SELECT * from user_logging;