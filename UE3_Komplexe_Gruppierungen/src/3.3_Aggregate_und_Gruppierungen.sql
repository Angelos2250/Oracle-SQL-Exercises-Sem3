-- 1. Welche Schauspieler/Schauspielerinnen (Vor- und Nachname) sind in der Datenbank öfters als
-- einmal eingetragen? (0,5 Punkt)
SELECT FIRST_NAME,LAST_NAME,COUNT(*)
FROM ACTOR
GROUP BY FIRST_NAME, LAST_NAME
HAVING COUNT(*) > 1;

-- 2. Ermitteln Sie die Titel jener Filme, die zwar in der Filmdatenbank existieren, allerdings in keinem
-- Geschäft angeboten werden. (42 Zeilen) (1 Punkt)
SELECT F.TITLE
FROM FILM F
LEFT JOIN INVENTORY I on F.FILM_ID = I.FILM_ID
GROUP BY F.TITLE
HAVING COUNT(STORE_ID) = 0;

-- 3. Geben Sie an, welcher Verkäufer in welchem Geschäft wie viele Verleihungen durchgeführt hat
-- und wie viel Umsatz er (jeweils) erzielt hat. (1 Punkt)
-- Achtung: Der Umsatz zählt für den Verkäufer, der den Film verliehen hat, d.h. der die Verleihung
-- eines Films durchgeführt hat. Dieser kann sich vom Verkäufer unterscheiden, der den
-- Bezahlvorgang (payment) durchgeführt hat.
SELECT S.FIRST_NAME,S.LAST_NAME,S.STORE_ID, COUNT(R.RENTAL_ID),SUM(P.AMOUNT)
FROM STAFF S
LEFT JOIN RENTAL R on S.STAFF_ID = R.STAFF_ID
LEFT JOIN PAYMENT P on R.RENTAL_ID = P.RENTAL_ID
GROUP BY S.FIRST_NAME, S.LAST_NAME, S.STORE_ID;

-- 4. Geben Sie pro Kunde (Vorname, Nachname) die Summe geliehener Filme an. Sortieren Sie nach
-- der Anzahl aufsteigend. (1 Punkt)
SELECT C.FIRST_NAME,C.LAST_NAME,COUNT(RENTAL_ID)
FROM CUSTOMER C
LEFT JOIN RENTAL R on C.CUSTOMER_ID = R.CUSTOMER_ID
GROUP BY C.FIRST_NAME, C.LAST_NAME
ORDER BY COUNT(RENTAL_ID) ASC ;

-- 5. Geben Sie den besten Kunden (gemessen am Umsatz, d.h. wie viel er gesamt bezahlt hat) pro
-- Store an, sowie den Umsatz und die Store-ID des Kunden). Bedenken Sie dabei den Fall, dass
-- Personen gleich heißen könnten. (1,5 Punkte)
SELECT C.FIRST_NAME, C.LAST_NAME, C.STORE_ID,SUM(P.AMOUNT) AS "UMSATZ"
FROM CUSTOMER C
JOIN RENTAL R on C.CUSTOMER_ID = R.CUSTOMER_ID
JOIN PAYMENT P on R.RENTAL_ID = P.RENTAL_ID
GROUP BY C.FIRST_NAME, C.LAST_NAME, C.STORE_ID
HAVING SUM(P.AMOUNT) IN (SELECT MAX(UMSATZ)
                         FROM (SELECT STORE_ID,FIRST_NAME,SUM(AMOUNT) AS "UMSATZ"
                               FROM CUSTOMER
                               INNER JOIN RENTAL USING(CUSTOMER_ID)
                               INNER JOIN PAYMENT USING(RENTAL_ID)
                               GROUP BY STORE_ID, FIRST_NAME)
                         GROUP BY STORE_ID);

-- 6. Geben Sie in Absteigender Reihenfolge an, welcher Kunde (Vorname, Nachname) bereits vier
-- oder mehr Horror-Filme ausgeliehen hat. (34 Zeilen) (1,5 Punkte)
SELECT C.FIRST_NAME,C.LAST_NAME,COUNT(RENTAL_ID)
FROM CUSTOMER C
JOIN RENTAL R on C.CUSTOMER_ID = R.CUSTOMER_ID
JOIN INVENTORY I on R.INVENTORY_ID = I.INVENTORY_ID
JOIN FILM_CATEGORY FC on I.FILM_ID = FC.FILM_ID
JOIN CATEGORY C2 on FC.CATEGORY_ID = C2.CATEGORY_ID
WHERE C2.NAME = 'Horror'
GROUP BY C.FIRST_NAME, C.LAST_NAME
HAVING COUNT(RENTAL_ID) > 3;

-- 7. Geben Sie die Top 10 der Schauspieler aus (mit Vor- und Nachnamen), die in den meisten Filmen
-- mitgespielt haben. (10 Zeilen, Stichprobe, keine Ties berücksichtigen) (1 Punkt)
SELECT A.FIRST_NAME,A.LAST_NAME,COUNT(FA.FILM_ID)
FROM ACTOR A
JOIN FILM_ACTOR FA on A.ACTOR_ID = FA.ACTOR_ID
GROUP BY A.FIRST_NAME, A.LAST_NAME
ORDER BY COUNT(FA.FILM_ID) DESC fetch first 10 rows only;

-- 8. Bestimmen Sie den/die kürzeste(n) Film(e) (Titel ausgeben), der der längste Film einer Kategorie
-- ist, zu der er gehört. (exakt, kein ROWNUM)
SELECT F.TITLE
FROM FILM F
JOIN FILM_CATEGORY FC on F.FILM_ID = FC.FILM_ID
WHERE LENGTH
