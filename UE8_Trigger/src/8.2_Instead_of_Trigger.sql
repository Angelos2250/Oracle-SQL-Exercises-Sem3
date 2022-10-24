CREATE TABLE new_emps AS
 SELECT employee_id, last_name, salary, department_id
    FROM employees;

CREATE TABLE new_locs AS
 SELECT l.location_id, l.city, l.country_id
  FROM locations l;

CREATE TABLE new_depts AS
 SELECT d.department_id, d.department_name,
             AVG(e.salary) AS dept_sal, d.location_id
    FROM employees e INNER JOIN departments d
                               ON (e.department_id = d.department_id)
   GROUP BY d.department_id, d.department_name, d.location_id;

CREATE TABLE new_countries AS
    SELECT c.country_id, c.country_name, COUNT(e.employee_id) AS c_emps
    FROM countries c INNER JOIN  locations l ON (l.country_id = c.country_id)
        INNER JOIN departments d ON (d.location_id = l.location_id)
        INNER JOIN employees e ON (e.department_id = d.department_id)
    GROUP BY c.country_id, c.country_name;

CREATE VIEW emp_details AS
SELECT employee_id, last_name, salary, department_id, department_name,
dept_sal, location_id, city, country_name, c_emps
FROM new_emps
JOIN new_depts USING (department_id)
JOIN new_locs USING (location_id)
JOIN new_countries USING (country_id);

SELECT * FROM emp_details;

SELECT column_name, updatable, insertable, deletable
FROM USER_UPDATABLE_COLUMNS
WHERE table_name = upper('emp_details');




CREATE OR REPLACE TRIGGER emp_details_trigger
  INSTEAD OF DELETE OR INSERT OR UPDATE ON emp_details
  FOR EACH ROW
BEGIN
  IF DELETING THEN
    DELETE FROM new_emps
    WHERE employee_id = :OLD.employee_id;

    UPDATE new_depts
    SET dept_sal = (
      SELECT AVG(salary)
      FROM employees JOIN departments USING (department_id)
      WHERE department_id = :OLD.department_id
    )
    WHERE department_id = :OLD.department_id;

    UPDATE new_countries
    SET c_emps = :OLD.c_emps - 1
    WHERE country_id = (SELECT country_id
                        FROM new_depts
                          JOIN new_locs USING (location_id)
                        WHERE department_id = :OLD.department_id);

  ELSIF INSERTING THEN
    INSERT INTO new_emps
    VALUES (:NEW.employee_id, :NEW.last_name, :NEW.salary, :NEW.department_id);

    UPDATE new_depts
    SET dept_sal = dept_sal + :NEW.salary
    WHERE department_id = :NEW.department_id;

    UPDATE new_countries
    SET c_emps = :OLD.c_emps + 1
    WHERE country_id = (SELECT country_id
                        FROM new_depts
                          JOIN new_locs USING (location_id)
                        WHERE department_id = :OLD.department_id);

  END IF;
END;
/


DELETE FROM emp_details WHERE EMPLOYEE_ID = 104;

SELECT * FROM emp_details;

ROLLBACK;