-- 1. Formulieren Sie eine Anfrage, die den Umsatz der Verkäufer (staff_id = 1 bzw. 2) pro
-- Filmkategorie vergleicht und geben Sie auch das Verhältnis der beiden Umsätze (pro Kategorie)
-- aus. „Speichern“ Sie diese Abfrage als virtuelle Sicht „UE05_02a“.
-- Tipp: Erstellen Sie hierfür zuerst einen Subquery-Block „revenues“, der Ihnen für jeden
-- Angestellten (staff_id) den Umsatz pro Filmkategorie (Name der Filmkategorie) berechnet.
CREATE VIEW UE05_02a AS
SELECT S1.STAFF_ID, FC.category_id, sum(AMOUNT) as revenue
FROM payment P
INNER JOIN STAFF S1 ON (S1.staff_id = P.staff_id)
INNER JOIN STORE S2 ON (S1.store_id = S2.store_id)
INNER JOIN RENTAL R ON (P.rental_id = R.rental_id)
INNER JOIN INVENTORY i ON (R.inventory_id = i.inventory_id)
INNER JOIN FILM_CATEGORY FC ON (i.film_id = FC.film_id)
WHERE S1.STAFF_ID = 1 OR S1.STAFF_ID = 2
GROUP BY S1.STAFF_ID, FC.category_id
ORDER BY category_id;

SELECT * FROM UE05_02A;

-- 2. Erzeugen Sie aus der virtuellen Sicht UE05_02a eine manuell zu aktualisierende materialisierte
-- Sicht UE05_02b mit kompletter Neuberechnung (Re-Materialisierung).
CREATE MATERIALIZED VIEW UE05_02b AS
SELECT * FROM UE05_02a;

-- 3. Verändern Sie den Aktualisierungszeitpunkt der erstellten materialisierten Sicht UE05_02b in der
-- Weise, dass sie automatisch jeden Tag um 23:30 aktualisiert wird. Speichern Sie die geänderte
-- materialisierte Sicht unter dem Namen UE05_02c. Löschen Sie die materialisierte Sicht
-- UE05_02c anschließend wieder.

CREATE MATERIALIZED VIEW UE05_02c AS
SELECT * FROM UE05_02a;
ALTER MATERIALIZED VIEW UE05_02c REFRESH
START WITH SYSDATE
NEXT TRUNC(SYSDATE) + 23.50/24;
drop materialized view UE05_02C;
