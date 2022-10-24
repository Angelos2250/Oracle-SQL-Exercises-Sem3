--1. Erstellen Sie eine neue Tabelle "new_film", diese soll den gleichen Aufbau wie die Tabelle
--"film" haben, jedoch nur die neuesten Filme (jene Filme, die das höchste Erscheinungsjahr in
--der Datenbank aufweisen) enthalten. (1 Punkt)

CREATE TABLE new_film (
  new_film_id INTEGER NOT NULL,
  title VARCHAR2(255) NOT NULL,
  description VARCHAR2(255),
  release_year INTEGER,
  language_id INTEGER NOT NULL,
  original_language_id INTEGER,
  rental_duration INTEGER NOT NULL,
  rental_rate DECIMAL(4,2) NOT NULL,
  length INTEGER DEFAULT NULL,
  replacement_cost DECIMAL(5,2) NOT NULL,
  rating VARCHAR2(20),
  special_features VARCHAR2(255),
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT new_film_pk PRIMARY KEY  (new_film_id),
  CONSTRAINT fk_new_film_language FOREIGN KEY (language_id) REFERENCES language (language_id) DEFERRABLE,
  CONSTRAINT fk_new_film_language_original FOREIGN KEY (original_language_id) REFERENCES language (language_id) DEFERRABLE
);

INSERT INTO new_film
SELECT *
FROM FILM
WHERE RELEASE_YEAR = (SELECT MAX(RELEASE_YEAR)
                      FROM FILM);

--2. Fügen Sie den Film "Jason Bourne" mit ID = 1001 in Englisch (language_id = 1) mit 5 Tagen
--Verleihdauer (zum Preis von 1,79) mit Ersetzungskosten von 16,99 in die Tabelle ein. (1 Punkt)
INSERT INTO FILM (FILM_ID, TITLE, LANGUAGE_ID, ORIGINAL_LANGUAGE_ID, RENTAL_DURATION, RENTAL_RATE, REPLACEMENT_COST,LAST_UPDATE)
VALUES (1001,'Jason Bourne',1,1,5,1.79,16.99,CURRENT_TIMESTAMP);

--3. Erhöhen Sie den Leihpreis der Filme in der Tabelle „new_film“ um 15%, wenn der Leihpreis
--kleiner als 2 ist. (0,5 Punkte)
UPDATE new_film
SET rental_rate = rental_rate*1.15
WHERE rental_rate < 2;

--4. Erstellen Sie eine View, die alle Filme der Tabelle "new_film" enthält, deren Leihpreis maximal 2 beträgt,
-- vergeben Sie die Check-Option. Die View soll nur den Filmtitel, die Beschreibung, den Leihpreis und die Länge enthalten. (1 Punkt)
CREATE VIEW FILM_LESSTHAN_2 AS
SELECT
    TITLE,DESCRIPTION,RENTAL_RATE,LENGTH
FROM
    NEW_FILM
WHERE
    RENTAL_RATE < 2 WITH CHECK OPTION;

--5. Welche Auswirkungen haben COMMIT und ROLLBACK an dieser Stelle (nachdem Sie die
--View erstellt haben). (0,5 Punkte)
--Ein COMMIT speichert die Datenänderungen in die Datenbank, sodass der Zustand der vorherigen Daten überschrieben wird. Ab diesem Zeitpunkt können alle Benutzer die Ergebnisse sehen.
--Ein ROLLBACK hingegen verwirft alle noch nicht gespeicherten Änderungen, wodurch der vorherige Zustand mit Hilfe vom UNDO-Tablespace hergestellt wird. Zudem werden die betroffenen gesperrten Zeilen wieder freigegeben.

--6. Können Sie die Datensätze Ihrer neuen View verändern? Wenn ja, führen Sie die Erhöhung der
--Filme (10%) ein weiteres Mal durch, diesmal auf Ihre View. Wenn nein, warum nicht? (0,5
--Punkte)
--Check option anschauen

--7. Löschen Sie alle Einträge aus der Tabelle new_film, deren Leihpreis über 1.79 liegt. (0,5
--Punkte)
DELETE FROM NEW_FILM WHERE RENTAL_RATE > 1.79;

--8. Können Sie den Leihpreis der Filme in der View nun erhöhen? Erklären Sie dieses Verhalten.
--(0,5 Punkte)

--9. Löschen Sie die Tabelle "new_film" und Ihre erstellte View wieder. (0,5 Punkte)
drop view FILM_LESSTHAN_2;
drop table NEW_FILM