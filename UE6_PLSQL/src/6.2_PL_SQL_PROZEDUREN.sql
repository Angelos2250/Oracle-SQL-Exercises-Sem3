-- Für die Datensätze in der Tabelle top_salaries werden Logging-Daten von der Erstellung sowie
-- von der letzten Änderung benötigt. Erweitern Sie dazu die Tabelle top_salaries um die Felder
-- createdBy, dateCreated, modifiedBy und dateModified. Bei der Anlage eines Datensatzes sind die
-- Created- und Modifed-Felder ident.
DELETE FROM top_salaries;
ALTER TABLE top_salaries ADD
(
    createdBy VARCHAR2(30),
    dateCreated TIMESTAMP,
    modifiedBy VARCHAR2(30),
    dateModified TIMESTAMP
);
-- Erstellen Sie eine Datenbank-Prozedur InsertTopSalaries, die einen Datensatz in der Tabelle
-- top_salaries anlegt und die Logging-Felder befüllt. Für die Logging-Felder verwenden Sie die
-- Systemfunktionen USER und SYSDATE. Die Systemfunktion USER liefert den Namen des
-- angemeldeten Benutzers. Die Systemfunktion SYSDATE liefert das aktuelle Systemdatum. Die
-- Prozedur soll folgende Spezifikation aufweisen:
CREATE OR REPLACE PROCEDURE InsertTopSalaries(pSalary IN NUMBER,pEmp_cnt IN NUMBER)
IS
    cBy TOP_SALARIES.createdBy%type := USER;
--     modBy TOP_SALARIES.modifiedBy%type := USER;
    daCr TOP_SALARIES.dateCreated%type := SYSDATE;
--     daMod TOP_SALARIES.dateModified%type := SYSDATE;
BEGIN
    INSERT INTO TOP_SALARIES(SALARY, ID ,EMP_COUNT, CREATEDBY, DATECREATED, MODIFIEDBY, DATEMODIFIED)
    VALUES (pSalary,DEFAULT,pEmp_cnt,cby,daCr,cBy,daCr);
end;

CALL InsertTopSalaries(2000,1);

SELECT * FROM TOP_SALARIES;
-- Ersetzen Sie die INSERT-Anweisung im Skript UE06_01_02 durch die in der vorherigen
-- Aufgabe erstellten Prozedur InsertTopSalaries und überprüfen Sie das Ergebnis.
-- Hinweis: Um auch die Uhrzeit zu sehen, können Sie das Datumsformat mit folgendem
-- Kommando festlegen.
DELETE FROM top_salaries;
DECLARE
    num NUMBER(3) := &p_num;
    CURSOR emp_cursor IS
        SELECT salary, count(*) as emp_cnt
        FROM employees
        GROUP BY salary
        ORDER BY salary DESC;
    sal top_salaries.salary%TYPE;
    emp_cnt top_salaries.emp_count%TYPE;
BEGIN
    OPEN emp_cursor;
    FETCH emp_cursor INTO sal, emp_cnt;
    WHILE emp_cursor%ROWCOUNT <= num AND emp_cursor%FOUND LOOP
        InsertTopSalaries(sal,emp_cnt);
        FETCH emp_cursor INTO sal, emp_cnt;
    END LOOP;
    CLOSE emp_cursor;
END;

