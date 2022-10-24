-- 1. Geben Sie für alle Filme das Erscheinungsjahr (‚year‘) und den Filmtitel (‚film‘) aus, sortiert
-- nach Jahr und Titel. Zusätzlich soll für jeden Film eine Liste aller Schauspieler (‚actors‘), die in
-- dem Film mitspielen, ausgegeben werden (siehe Abbildung). In der Actors-Liste sollen die
-- Namen nach Nachname und Vorname sortiert sein. Die Namen sollen so ausgegeben werden,
-- dass jeweils der erste Buchstabe des Vornamens, ‘. ‘, und der Nachname angezeigt werden. Die
-- einzelnen Schauspieler sind durch Komma ‘,‘ voneinander zu trennen.
SELECT F.RELEASE_YEAR,F.TITLE,
       LISTAGG(SUBSTR(A2.FIRST_NAME,1,1) || '. ' || A2.LAST_NAME,'; ') WITHIN GROUP ( ORDER BY A2.LAST_NAME, A2.FIRST_NAME) AS Actors
FROM FILM F
JOIN FILM_ACTOR FA on F.FILM_ID = FA.FILM_ID
JOIN ACTOR A2 on FA.ACTOR_ID = A2.ACTOR_ID
GROUP BY F.RELEASE_YEAR, F.TITLE;

-- 2. Geben Sie zu jedem Kunden (Vorname Nachname) eine Liste der Filme aus, die sich der Kunde
-- innerhalb der letzten sieben Jahre ausgeborgt hat. Zusätzlich zum Titel des Films geben Sie das
-- Erscheinungsjahr in Klammer an. Sortieren Sie die Film-Liste so, dass die jüngsten Filme zuerst
-- aufscheinen.
SELECT C.FIRST_NAME,C.LAST_NAME,LISTAGG(F.TITLE ||'(' || F.RELEASE_YEAR || ')','; ') WITHIN GROUP ( ORDER BY F.RELEASE_YEAR) AS Rented_Films
FROM CUSTOMER C
JOIN RENTAL R on C.CUSTOMER_ID = R.CUSTOMER_ID
JOIN INVENTORY I on R.INVENTORY_ID = I.INVENTORY_ID
JOIN FILM F on I.FILM_ID = F.FILM_ID
WHERE RENTAL_DATE = trunc(SYSDATE - interval '7' year,'YEAR')
GROUP BY C.FIRST_NAME, C.LAST_NAME;

-- 3. Der Store in Linz (store_id = 3) möchte die Interessen seiner Kunden näher bestimmen.
-- Besonders interessant sind die Filmkategorien, die einzelne Kunden zuletzt ausgeliehen haben.
-- Geben Sie Vor- und Nachname des Kunden als „customer“ und eine Liste der Kategorien
-- (getrennt durch ‘,‘) aller Filme, die sich der jeweilige Kunde ausgeborgt hat, als „recent_interests“
-- aus. Beschränken Sie sich auf Kunden, die im Store in der Stadt Linz registriert sind und
-- verwenden Sie für das Ergebnis nur die drei zuletzt geliehenen Kategorien.
-- Sonderfälle: Achten Sie darauf, dass dies auch mehrere Kategorien sein könnten, wenn mehrere
-- Filme zum gleichen Zeitpunkt geliehen wurden. Außerdem sollen Kategorien nicht mehrfach in
-- der Liste erscheinen.
-- Eine Vereinfachung können Sie unter anderem durch eine entsprechende Vorverarbeitung der
-- Datenmenge (analytische Funktion) erreichen z.B. durch die Verwendung von WITH.
-- Recherchieren Sie bei Bedarf.
-- Fügen Sie ausreichend Testfälle in die Abgabe ein, um auch Sonderfälle entsprechend zu belegen.
SELECT LAST_NAME,LISTAGG(DISTINCT Interests,',') AS RECENT_INTERESTS
FROM (
         SELECT C2.LAST_NAME,
                RENTAL_DATE,
                row_number() over (PARTITION BY C2.LAST_NAME ORDER BY RENTAL_DATE DESC) AS Row_num,
                LISTAGG(DISTINCT C3.NAME, ',') WITHIN GROUP ( ORDER BY R.RENTAL_DATE) AS Interests
         FROM CUSTOMER C2
                  JOIN RENTAL R on C2.CUSTOMER_ID = R.CUSTOMER_ID
                  JOIN INVENTORY I on R.INVENTORY_ID = I.INVENTORY_ID
                  JOIN FILM F on I.FILM_ID = F.FILM_ID
                  JOIN FILM_CATEGORY FC on F.FILM_ID = FC.FILM_ID
                  JOIN CATEGORY C3 on FC.CATEGORY_ID = C3.CATEGORY_ID
                  JOIN STORE S on C2.STORE_ID = S.STORE_ID
         WHERE S.STORE_ID = 3
         GROUP BY C2.LAST_NAME, RENTAL_DATE
         ORDER BY LAST_NAME, RENTAL_DATE DESC
     )
WHERE Row_num < 4
GROUP BY LAST_NAME;
