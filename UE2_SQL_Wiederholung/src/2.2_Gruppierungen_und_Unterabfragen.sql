--1. Geben Sie die Titel aller Filme aus, die länger dauern als der Film mit der ID 50 und deren Ersetzungskosten größer
-- sind als der Film mit der ID 101. (1,5 Punkte)
SELECT TITLE
FROM FILM
WHERE LENGTH > (SELECT LENGTH
                FROM FILM
                WHERE FILM_ID = 50)
AND REPLACEMENT_COST > (SELECT REPLACEMENT_COST
                        FROM FILM
                        WHERE FILM_ID = 101);

--2. Geben Sie die Titel aller Filme aus, die kürzer als 60 Minuten dauern und in den gleichen Kategorien spielen als
-- die Filme mit den IDs 10, 20 oder 30. (1,5 Punkte)
SELECT F.TITLE
FROM FILM F
    JOIN FILM_CATEGORY FC on F.FILM_ID = FC.FILM_ID
WHERE F.LENGTH < 60
AND CATEGORY_ID IN (SELECT CATEGORY_ID
                    FROM FILM_CATEGORY
                    WHERE FILM_ID IN (10,20,30));

--3. Erstellen Sie eine Liste aus Schauspieler (Vor- und Nachname) und Anzahl der Filme, in denen
--sie mitspielen. Die Liste soll nur jene Schauspieler enthalten, die in mehr als 35 Filmen mitspielen.
--Zählen Sie nur jene Filme, die mindestens 60 Minuten dauern. (1 Punkt)
SELECT A.FIRST_NAME, A.LAST_NAME,COUNT(*)
FROM ACTOR A
    JOIN FILM_ACTOR FA on A.ACTOR_ID = FA.ACTOR_ID
    JOIN FILM F on FA.FILM_ID = F.FILM_ID
WHERE f.LENGTH > 60
GROUP BY A.FIRST_NAME, A.LAST_NAME
HAVING COUNT(FA.ACTOR_ID) >35;

--4. Erstellen Sie eine Liste mit den Titeln und der Länge jener Filme, die länger als der Durchschnitt sind. (1 Punkt)
SELECT TITLE, LENGTH
FROM FILM
WHERE LENGTH > (SELECT AVG(LENGTH)
                FROM FILM);

--5. Ermitteln Sie die Namen jener Filmkategorien zu denen weniger als 60 Filme gehören. (1
--Punkt)
SELECT NAME
FROM CATEGORY
WHERE CATEGORY_ID IN (SELECT CATEGORY_ID
                      FROM FILM_CATEGORY
                      GROUP BY CATEGORY_ID
                      HAVING COUNT(*) < 60);

--6. Ermitteln Sie alle Filme, die die längsten in ihrem Erscheinungsjahr sind und geben Sie Titel,
--Dauer (length) sowie Erscheinungsjahr aus. (1 Punkt)
SELECT F.TITLE, F.LENGTH, F.RELEASE_YEAR
FROM FILM F
WHERE F.LENGTH = (SELECT MAX(F2.LENGTH)
                FROM FILM F2
                WHERE F.RELEASE_YEAR = F2.RELEASE_YEAR);

--7. Geben Sie den durchschnittlich bezahlten Preis (Tabelle payment) pro Filmkategorie aus (sollte
--ein Film zu mehreren Kategorien gehören, zählt er zu allen). Runden Sie auf zwei Nachkommastellen. (1 Punkt)
SELECT FC.CATEGORY_ID, ROUND(AVG(P.AMOUNT),2)
FROM PAYMENT P
    JOIN RENTAL R on R.RENTAL_ID = P.RENTAL_ID
    JOIN INVENTORY I on R.INVENTORY_ID = I.INVENTORY_ID
    JOIN FILM_CATEGORY FC on I.FILM_ID = FC.FILM_ID
GROUP BY FC.CATEGORY_ID;

--8. Geben Sie die neun zuletzt verliehenen Filme und das Verleihdatum im Format ‘YYYY-MMDD‘ aus. (1,5 Punkte)
SELECT I.FILM_ID, TO_CHAR(R.RENTAL_DATE, 'YYYY-MMDD')
FROM INVENTORY I
JOIN RENTAL R on I.INVENTORY_ID = R.INVENTORY_ID
WHERE ROWNUM <= 9
ORDER BY RENTAL_DATE DESC;

--9. Geben Sie alle Schauspieler (mind. Vor-/Nachname) aus, die in mehr als 15 verschiedenen
--Film-Kategorien spielen. Achten Sie dabei darauf, dass manche Schauspieler unter Umständen
--den gleichen Namen tragen. (1 Punkt)
SELECT A.ACTOR_ID, A.FIRST_NAME, A.LAST_NAME
FROM ACTOR A
         JOIN FILM_ACTOR FA on A.ACTOR_ID = FA.ACTOR_ID
         JOIN FILM_CATEGORY FC on FA.FILM_ID = FC.FILM_ID
GROUP BY A.ACTOR_ID, A.FIRST_NAME, A.LAST_NAME
HAVING COUNT(FC.CATEGORY_ID) > 15;

--10. Welcher Film wurde pro Film-Kategorie als erstes ausgeliehen (rental_date)? Geben Sie FilmTitel, Kategorie-Name
-- und Verleihdatum aus. Sortieren Sie nach dem Kategorie-Namen. (1,5Punkte)
SELECT F.TITLE,C.NAME,R.RENTAL_DATE
FROM FILM F
    JOIN FILM_CATEGORY FC on F.FILM_ID = FC.FILM_ID
    JOIN CATEGORY C on C.CATEGORY_ID = FC.CATEGORY_ID
    JOIN INVENTORY I on FC.FILM_ID = I.FILM_ID
    JOIN RENTAL R on I.INVENTORY_ID = R.INVENTORY_ID
WHERE R.RENTAL_DATE = (SELECT MIN(RENTAL_DATE)
                       FROM RENTAL R2
                            JOIN INVENTORY I2 on R2.INVENTORY_ID = I2.INVENTORY_ID
                            JOIN FILM_CATEGORY FC2 on I2.FILM_ID = FC2.FILM_ID
                       WHERE FC.CATEGORY_ID = FC2.CATEGORY_ID)
ORDER BY C.NAME


