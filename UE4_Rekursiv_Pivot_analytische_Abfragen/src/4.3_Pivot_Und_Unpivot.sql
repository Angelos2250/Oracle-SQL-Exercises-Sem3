
-- 1. Erstellen Sie eine Pivot-Tabelle für die Kategorien „Family“, „Children“ und „Animation“
-- (Spalten), welche die Durchschnittslänge der Filme pro Sprache (Zeilen) angibt. (6 Zeilen, 4
-- Spalten)
SELECT *
FROM   (SELECT CATEGORY.NAME AS CAT_NAME,LANGUAGE.NAME AS LANG_NAME,LENGTH
        FROM FILM_CATEGORY FC
        JOIN CATEGORY USING (CATEGORY_ID)
        JOIN FILM USING (FILM_ID)
        JOIN LANGUAGE USING (LANGUAGE_ID))
PIVOT(
    AVG(LENGTH)
    FOR CAT_NAME
    IN ('Family' AS Family,
    'Children' AS Children,
    'Animation' AS Animation)
    );

-- 2. Sie sollen für jede Kategorie Anzahl der Filme (Inventar!) pro Filiale und insgesamt in
-- jeweiligen Kategorie berechnen. Erstellen Sie hierfür eine Kreuztabelle, die für Filialen und
-- Kategorien die Anzahl der Filme (Inventar!) berechnet, geben Sie auch die Gesamtsummen
-- pro Filiale und pro Kategorie aus. Ergänzen Sie für die Erstellung der Kreuztabelle den
-- gegebenen Code-Ausschnitt und verwenden Sie diese als Sub-Select eines Pivot-Befehls.
SELECT COUNT(*) AS anzahl,
 CASE WHEN GROUPING(name) = 1 THEN 'Gesamt' ELSE name END AS Kategorie,
 CASE WHEN GROUPING(store_id) = 1 THEN 'Gesamt' ELSE to_char(store_id) END AS Filiale
FROM inventory
 INNER JOIN film_category USING (film_id)
 INNER JOIN category USING (category_id)
GROUP BY CUBE (store_id, name);

-- 3. Erstellen Sie eine Anfrage die für jeden Film aus dem Jahr 1990 die Sprache
-- und die OriginalSprache enthält. Die Ergebnistabelle soll als Spalten den Film-Namen,
-- die Sprache und die Art der Sprache (L, OL) enthalten und nach Film-Titel sortiert sein
WITH Films1990 AS(
    SELECT *
    FROM(SELECT TITLE, LANGUAGE_ID, ORIGINAL_LANGUAGE_ID
         FROM FILM
         WHERE RELEASE_YEAR = 1990)
    UNPIVOT(
    LANGUAGE_ID
    FOR ART
    IN (LANGUAGE_ID AS 'L',
    ORIGINAL_LANGUAGE_ID AS 'OL'))
)

SELECT TITLE, ART, NAME AS LANGUAGE
FROM Films1990
JOIN LANGUAGE USING (LANGUAGE_ID)
ORDER BY TITLE;