-- F?hren Sie folgendes Skript UE06_01_01.sql aus, um die Tabelle top_salaries zu erstellen, in der
-- die Geh?lter der Angestellten gespeichert werden sollen.
DROP TABLE top_salaries;
CREATE TABLE top_salaries (salary NUMBER(8,2));

SELECT * FROM top_salaries;
-- Zus?tzlich zum Gehalt soll auch die Anzahl der Mitarbeiter abgespeichert werden, die dieses
-- Gehalt verdienen. Erweitern Sie dazu die Tabelle top_salaries um das Feld emp_cnt und w?hlen
-- Sie einen passenden Datentyp aus. Definieren Sie einen k?nstlichen Prim?rschl?ssel als
-- generierte Identit?t und ein Check Constraint zur Sicherstellung, dass emp_cnt gr??er als Null ist.
-- Verwenden Sie f?r die Erweiterung ALTER-Befehle (leeren Sie Ihre Tabelle davor).
DROP TABLE top_salaries;
ALTER TABLE top_salaries ADD
(
id INT GENERATED BY DEFAULT AS IDENTITY
    ( START WITH 1 INCREMENT BY 1
    MINVALUE 1 MAXVALUE 2000) PRIMARY KEY ,
emp_count NUMBER(5) CHECK (emp_count > 0)
);

-- Modifizieren Sie das Skript UE06_01_02.sql, um das neue Feld korrekt zu bef?llen.
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
INSERT INTO top_salaries
VALUES (sal,DEFAULT, emp_cnt);
FETCH emp_cursor INTO sal, emp_cnt;
END LOOP;
CLOSE emp_cursor;
END;