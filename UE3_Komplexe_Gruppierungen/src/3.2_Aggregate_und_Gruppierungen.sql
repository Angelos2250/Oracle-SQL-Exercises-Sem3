/*1. Erstellen Sie die folgenden Statistikberichte für die Personalabteilung: Nehmen Sie die
Abteilungsnummer, den Namen und die Anzahl der Angestellten für jede Abteilung auf, die
folgende Bedingungen erfüllt:
a. Keine oder mehr als 3 Angestellte: 1 Punkt
b. Höchste Anzahl von Angestellten: 1 Punkt
c. Niedrigste Anzahl von Angestellten: 1 Punkt
Beachten Sie dabei, dass es auch Abteilungen ohne Mitarbeiter geben kann*/
SELECT D.DEPARTMENT_ID,D.DEPARTMENT_NAME, COUNT(E.EMPLOYEE_ID)
FROM DEPARTMENTS D
LEFT JOIN EMPLOYEES E on D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY  D.DEPARTMENT_ID, D.DEPARTMENT_NAME
HAVING (COUNT(E.EMPLOYEE_ID) = 0 OR COUNT(E.EMPLOYEE_ID) > 3);

SELECT D.DEPARTMENT_ID,D.DEPARTMENT_NAME,COUNT(E.EMPLOYEE_ID)
FROM DEPARTMENTS D
JOIN EMPLOYEES E on D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID, D.DEPARTMENT_NAME
HAVING COUNT(E.EMPLOYEE_ID) = (SELECT MAX(COUNT(E2.EMPLOYEE_ID))
                               FROM DEPARTMENTS D2
                               JOIN EMPLOYEES E2 on D2.DEPARTMENT_ID = E2.DEPARTMENT_ID
                               GROUP BY D2.DEPARTMENT_ID);


SELECT D.DEPARTMENT_ID,D.DEPARTMENT_NAME,COUNT(E.EMPLOYEE_ID)
FROM DEPARTMENTS D
LEFT JOIN EMPLOYEES E on D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID, D.DEPARTMENT_NAME
HAVING COUNT(E.EMPLOYEE_ID) = (SELECT MIN(COUNT(E2.EMPLOYEE_ID))
                               FROM DEPARTMENTS D2
                               LEFT JOIN EMPLOYEES E2 on D2.DEPARTMENT_ID = E2.DEPARTMENT_ID
                               GROUP BY D2.DEPARTMENT_ID);



