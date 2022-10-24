-- 1. Neena Kochhar verlässt das Unternehmen. Ihr Nachfolger wünscht Berichte über die
-- Angestellten, die Kochhar direkt unterstellt sind. Erstellen Sie eine SQL-Anweisung, um die
-- Angestelltennummer, den Nachnamen, das Einstellungsdatum und das Gehalt anzuzeigen, wobei
-- auf Folgendes eingeschränkt werden soll:
-- a. Die Angestellten, die Kochhar direkt unterstellt sind
-- b. Die gesamte Organisationsstruktur unter Kochhar (Angestelltennummer: 101)
SELECT E.EMPLOYEE_ID,E.LAST_NAME,E.HIRE_DATE,E.SALARY
FROM EMPLOYEES E
WHERE E.MANAGER_ID = 101;

SELECT E.EMPLOYEE_ID,E.LAST_NAME,E.HIRE_DATE,E.SALARY
FROM EMPLOYEES E
START WITH E.EMPLOYEE_ID = 101
CONNECT BY PRIOR E.EMPLOYEE_ID = E.MANAGER_ID;

-- 2. Erstellen Sie eine hierarchische Abfrage, um die Angestelltennummer, die Managernummer und
-- den Nachnamen für alle Angestellten unter De Haan anzuzeigen, die sich genau zwei Ebenen
-- unterhalb dieses Angestellten (De Haan, Angestelltennummer: 102) befinden. Zeigen Sie zudem
-- die Ebene des Angestellten an. (2 Zeilen)
SELECT E.EMPLOYEE_ID,E.MANAGER_ID,E.LAST_NAME,LEVEL
FROM EMPLOYEES E
WHERE LEVEL = 3
START WITH E.EMPLOYEE_ID = 102
CONNECT BY PRIOR E.EMPLOYEE_ID = E.MANAGER_ID;

-- 3. Der CEO benötigt einen hierarchischen Bericht über alle Angestellten. Er teilt Ihnen die
-- folgenden Anforderungen mit: Erstellen Sie einen hierarchischen Bericht, der den Nachnamen,
-- die Angestelltennummer, die Managernummer und die Pseudospalte LEVEL des Angestellten
-- anzeigt. Für jede Zeile der Tabelle EMPLOYEES soll eine Baumstruktur ausgegeben werden, die
-- den Angestellten, seinen Manager, dessen Manager usw. zeigt. Verwenden Sie Einrückungen
-- (LPAD) für die Spalte LAST_NAME.
SELECT LPAD(E.LAST_NAME,LENGTH(E.LAST_NAME)+(LEVEL-1),'_') AS LAST_NAME,E.EMPLOYEE_ID, E.MANAGER_ID, LEVEL
FROM EMPLOYEES E
START WITH E.EMPLOYEE_ID = 100
CONNECT BY PRIOR E.EMPLOYEE_ID = E.MANAGER_ID;

-- 4. Erstellen Sie einen Bericht, der alle Angestellten enthält (Vor- und Nachname) und bestimmt,
-- von wie vielen Personen er/sie Vorgesetzte/r ist. Zählen Sie nicht nur die direkt unterstellten,
-- sondern die gesamte Hierarchie darunter (zB Steven King ist der Vorgesetzte von 19 Personen).
-- Sie benötigen für diese Aufgabe die Pseudo-Spalte connect_by_root - recherchieren Sie diese!
SELECT E.FIRST_NAME,E.LAST_NAME,COUNT(connect_by_root MANAGER_ID)
FROM EMPLOYEES E
CONNECT BY PRIOR E.MANAGER_ID= E.EMPLOYEE_ID
GROUP BY E.FIRST_NAME, E.LAST_NAME;
