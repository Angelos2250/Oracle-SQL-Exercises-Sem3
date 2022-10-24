-- 1. Geben Sie zu jedem Film ID, Titel, Länge und die zugehörige Kategorie-Bezeichnung aus.
-- Führen Sie außerdem pro Film an, wie viele Filme in der jeweiligen Film-Kategorie 10 Minuten
-- kürzer oder länger als der Film selbst sind (Wie viele Empfehlungen für "ähnliche" Filme gibt
-- es?).
-- Hinweis: Zur Selbstkontrolle sortieren Sie die Liste nach Kategorie und Länge. Für "Bride
-- Intrigue" (Action) gibt es 15 weitere Filme, deren Laufzeit 10 Minuten kürzer oder länger ist.
SELECT F.FILM_ID,F.TITLE,C2.NAME,F.LENGTH, COUNT(F.FILM_ID) OVER ( PARTITION BY C2.NAME ORDER BY F.LENGTH RANGE BETWEEN 10 PRECEDING AND 10 FOLLOWING)-1 AS LongerThan
FROM FILM F
JOIN FILM_CATEGORY FC on F.FILM_ID = FC.FILM_ID
JOIN CATEGORY C2 on C2.CATEGORY_ID = FC.CATEGORY_ID
ORDER BY C2.NAME;

-- Geben Sie zu jeder Filmkategorie drei Filme aus, wählen Sie jene Filme, die neueren Datums
-- sind. Geben Sie den Kategorienamen aus, den Filmtitel und das Erscheinungsjahr. Verwenden
-- Sie ROW_NUMBER().
SELECT *
FROM
    (SELECT ROW_NUMBER() over (PARTITION BY C.NAME ORDER BY C.NAME DESC) AS row_num,
            C.NAME AS Kategorie,F.TITLE AS FILM
    FROM FILM F
    JOIN FILM_CATEGORY FC on F.FILM_ID = FC.FILM_ID
    JOIN CATEGORY C on C.CATEGORY_ID = FC.CATEGORY_ID)
WHERE row_num <= 3;

-- Ermitteln Sie welche Kunden schon einmal mehr als 180 Tage zwischen zwei Verleihvorgängen
-- verstreichen haben lassen.
-- a) Erstellen Sie zuerst eine analytische Abfrage, die für jeden Kunden das aktuelle
-- Verleihdatum und das nächste gegenüberstellt.
-- b) Berechnen Sie aufbauend auf a) die Anzahl der Tage zwischen den Verleihvorgängen.
-- Geben Sie für die geforderten Einträge den Vor- und Nachnamen des Kunden, sowie die Anzahl
-- der verstrichenen Tage aus.
-- Achtung: Die Auswertung ist nur möglich, wenn der Kunde bereits mehr als einen Film ausgeborgt
-- hat (beachten Sie NULL-Werte).

SELECT FIRST_NAME, LAST_NAME, RENTAL_DATE AS active_rental_date,
       LEAD(RENTAL_DATE, 1) OVER (PARTITION BY CUSTOMER_ID ORDER BY RENTAL_DATE) AS next_rental_date
FROM CUSTOMER
     JOIN RENTAL USING(CUSTOMER_ID)
ORDER BY FIRST_NAME;

SELECT FIRST_NAME, LAST_NAME, (next_rental_date - active_rental_date) AS days
FROM (
SELECT FIRST_NAME, LAST_NAME, RENTAL_DATE AS active_rental_date,
       LEAD(RENTAL_DATE, 1) OVER (PARTITION BY CUSTOMER_ID ORDER BY RENTAL_DATE) AS next_rental_date
FROM CUSTOMER
     JOIN RENTAL USING(CUSTOMER_ID) )
WHERE (next_rental_date - active_rental_date) > 180;
