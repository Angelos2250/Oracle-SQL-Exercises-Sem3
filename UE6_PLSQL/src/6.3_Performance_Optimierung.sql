-- Erstellen Sie sich mit dem gegebenen Skript UE06_03_01.sql eine Tabelle my_payment indem Sie die
-- Datensätze der Tabelle payment einfügen. Fügen Sie eine weitere Spalte penalty der Tabelle hinzu.
-- Ermitteln Sie nun für jeden Bezahlvorgang (der einem Verleihvorgang entspricht) ob der Film
-- länger verliehen war, als unter rental_duration angegeben. Das gegebene Skript enthält einen
-- anonymen Block, der diese Berechnung in einer Schleife durchführt. Führen Sie diesen Block aus
-- und notieren Sie die ermittelte Laufzeit.
CREATE TABLE my_payment AS
SELECT *
FROM payment
WHERE rental_id IS NOT NULL;
ALTER TABLE my_payment ADD PRIMARY KEY (payment_id);
ALTER TABLE my_payment ADD penalty NUMBER;


-- UPDATE in loop
DECLARE
  starttime NUMBER;
  total NUMBER;
  maxRent NUMBER := 0;
  actualRent NUMBER := 0;
BEGIN
  starttime := DBMS_UTILITY.GET_TIME();
  FOR mp IN (SELECT amount, rental_id, payment_id, payment_date FROM my_payment) LOOP
    SELECT MAX(rental_duration) INTO maxRent
    FROM film
      INNER JOIN inventory USING (film_id)
      INNER JOIN rental USING (inventory_id) WHERE rental_id = mp.rental_id;

    SELECT MAX(CEIL(return_date - rental_date)) INTO actualRent
    FROM rental
    WHERE rental_id = mp.rental_id;

    IF actualRent > maxRent THEN
      UPDATE my_payment
         SET penalty = amount * 1.15
      WHERE mp.payment_id = payment_id;
    END IF;

  END LOOP;
  total := DBMS_UTILITY.GET_TIME() - starttime;
  DBMS_OUTPUT.PUT_LINE('PL/SQL LOOP: ' || total / 100 || ' seconds');
END;
/

DROP TABLE my_payment;

-- Entwickeln Sie eine weitere Version des Skripts und eliminieren Sie die Schleife. Führen Sie
-- also in einem weiteren anonymen Block ein einfaches Update-Statement aus, das die gleiche
-- Berechnung vornimmt.
SELECT * FROM my_payment;
DECLARE
  starttime NUMBER;
  total NUMBER;
  maxRent NUMBER := 0;
  actualRent NUMBER := 0;
BEGIN
    starttime := DBMS_UTILITY.GET_TIME();
    UPDATE my_payment
    SET penalty = amount * 1.15
    WHERE (SELECT MAX(rental_duration)
            FROM film
            INNER JOIN inventory USING (film_id)
            INNER JOIN rental USING (inventory_id) WHERE RENTAL_ID = my_payment.RENTAL_ID)
            <
          (SELECT MAX(CEIL(return_date - rental_date))
            FROM rental
            WHERE RENTAL_ID = my_payment.RENTAL_ID);
  total := DBMS_UTILITY.GET_TIME() - starttime;
  DBMS_OUTPUT.PUT_LINE('WITHOUT LOOP: ' || total / 100 || ' seconds');
END;
/
ROLLBACK ;