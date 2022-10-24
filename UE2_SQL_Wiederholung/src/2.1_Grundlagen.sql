--1. Erstellen Sie eine Liste aller Schauspieler. Verketten Sie Vor- und Nachname (getrennt durch
--ein Leerzeichen) und nennen Sie die neue Spalte "Name". Sortieren Sie das Ergebnis nach dem
--Nachnamen. (0,5 Punkte)
SELECT (FIRST_NAME ||' '||LAST_NAME) AS Name
FROM ACTOR;

--2. Geben Sie eine Liste mit Titel und Länge all jener Filme aus, die länger als 180 Minuten dauern. (0,5 Punkte)
SELECT TITLE,LENGTH
FROM FILM
WHERE LENGTH > 180;

--3. Geben Sie eine Liste mit Filmtitel aus, deren Namen an vierter Stelle ein 'A' enthält, geben Sie
--die Titel so aus, dass jeweils der erste Buchstabe eines Wortes mit einem Großbuchstaben beginnt (zB Atlantis Cause). (0,5 Punkte)
SELECT INITCAP(TITLE)
FROM FILM
WHERE TITLE LIKE '___A%';

--4. Geben Sie den Titel jener Filme aus, bei denen eine Originalsprache eingetragen ist. (0,5
--Punkte)
SELECT TITLE
FROM FILM
WHERE ORIGINAL_LANGUAGE_ID IS NOT NULL ;

--5. Geben Sie die Anzahl der verliehenen Filme zwischen 1.1.2015 und 31.12.2015 aus (Start des
--Verleihvorgangs, rental_date). (1 Punkt)
alter session set nls_date_format = 'dd.mm.yyyy';
SELECT COUNT(*)
FROM RENTAL
WHERE RENTAL_DATE BETWEEN '01.01.2015' AND '31.12.2015';

--6. Geben Sie alle Inventar-Ids aus, die noch nie verliehen wurden. (1 Punkt)
SELECT I.INVENTORY_ID
FROM INVENTORY I
    LEFT JOIN RENTAL R on I.INVENTORY_ID = R.INVENTORY_ID
WHERE RENTAL_ID IS NULL ;

--7. Erstellen Sie eine Liste mit Kunden (Vor- und Nachname), die in Newcastle, Linz und London
--wohnen. (1 Punkt)
SELECT FIRST_NAME, LAST_NAME
FROM CUSTOMER C
    JOIN ADDRESS A on C.ADDRESS_ID = A.ADDRESS_ID
    JOIN CITY CI on A.CITY_ID = CI.CITY_ID
WHERE REGEXP_LIKE(CI.CITY,'Newcatsle|Linz|London');

--8. Geben Sie für den Kunden mit der ID 240 alle Verleihvorgänge mit dem Start des Verleihvorgangs und dem bezahlten Betrag aus. Geben Sie das Datum im Format ‘Mittwoch, 14. Okt.
--2020‘ aus, verwenden Sie dazu die Funktion to_char und recherchieren Sie bei Bedarf in der
--Oracle-Dokumentation. (1 Punkt)
SELECT R.RENTAL_ID, TO_CHAR( R.RENTAL_DATE, 'DAY, dd. Mon. YYYY' ), P.AMOUNT
FROM CUSTOMER C
    JOIN RENTAL R on C.CUSTOMER_ID = R.CUSTOMER_ID
    JOIN PAYMENT P on C.CUSTOMER_ID = P.CUSTOMER_ID
WHERE C.CUSTOMER_ID = 240