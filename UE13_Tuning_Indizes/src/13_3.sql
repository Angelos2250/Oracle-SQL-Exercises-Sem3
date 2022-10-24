
-- Aufgabe 3
--1
SELECT DISTINCT customer_id, first_name, last_name
FROM customer
INNER JOIN rental USING (customer_id)
INNER JOIN inventory USING (inventory_id)
INNER JOIN film USING (film_id)
INNER JOIN film_category USING (film_id)
INNER JOIN category USING (category_id)
WHERE name IN ('Children', 'Comedy', 'Family') AND length < 90
UNION
SELECT DISTINCT customer_id, first_name, last_name
FROM customer
INNER JOIN rental USING (customer_id)
INNER JOIN inventory USING (inventory_id)
INNER JOIN film USING (film_id)
INNER JOIN film_category USING (film_id)
INNER JOIN category USING (category_id)
WHERE name IN ('Animation', 'Classics');
--cost ist 108

SELECT customer_id, first_name, last_name
FROM customer
INNER JOIN rental USING (customer_id)
INNER JOIN inventory USING (inventory_id)
INNER JOIN film USING (film_id)
INNER JOIN film_category USING (film_id)
INNER JOIN category USING (category_id)
WHERE (name IN ('Children', 'Comedy', 'Family') AND length < 90) OR name IN ('Animation', 'Classics')
GROUP BY customer_id, first_name, last_name
ORDER BY CUSTOMER_ID;
--COST is 58

--2
SELECT c.customer_id, first_name, last_name,
(SELECT SUM(amount)
FROM payment
WHERE c.customer_id = customer_id
AND to_char(payment_date, 'yy') = '15') AS umsatz15,
(SELECT SUM(amount)
FROM payment
WHERE c.customer_id = customer_id
AND to_char(payment_date, 'yy') = '14') AS umsatz14,
(SELECT SUM(amount)
FROM payment
WHERE c.customer_id = customer_id
AND to_char(payment_date, 'yy') = '13') AS umsatz13,
(SELECT SUM(amount)
FROM payment
WHERE c.customer_id = customer_id) AS umsatzGesamt
FROM customer c;
--599 Zeilen COst 119

SELECT CUSTOMER_ID,FIRST_NAME,LAST_NAME,"13","14","15","13"+"14"+"15" AS SUMM FROM
(SELECT C.CUSTOMER_ID, C.FIRST_NAME,C.LAST_NAME, P.AMOUNT, to_char(payment_date, 'yy') AS date_pay
FROM CUSTOMER C JOIN PAYMENT P on C.CUSTOMER_ID = P.CUSTOMER_ID)
PIVOT(
    SUM(AMOUNT)
    FOR date_pay IN( 13, 14 , 15)
    );
--COST 33;

--3
SELECT PAYMENT_DATE FROM PAYMENT;

SELECT  to_char(payment_date, 'yy') AS asas
FROM PAYMENT;

CREATE OR REPLACE FUNCTION num_longer_films_in_cat (filmid IN NUMBER)
RETURN NUMBER
AS
categoryid NUMBER;
len NUMBER;
numfilms NUMBER := 0;
BEGIN
SELECT category_id, length INTO categoryid, len
FROM film INNER JOIN film_category USING (film_id)
WHERE film_id = filmid;
FOR film IN (SELECT *
FROM film INNER JOIN film_category USING (film_id)
WHERE category_id = categoryid AND length > len) LOOP
numfilms := numfilms + 1;
END LOOP;
RETURN numfilms;
END;
/
SELECT film_id, title, num_longer_films_in_cat(film_id) AS longerFilmsInCategory
FROM film
ORDER BY FILM_ID;
--505 ms

SELECT f.film_id, f.title,COUNT(f.FILM_ID) OVER ( PARTITION BY fc.CATEGORY_ID ORDER BY f.LENGTH RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)-1
FROM film f
JOIN FILM_CATEGORY FC on f.FILM_ID = FC.FILM_ID
ORDER BY FILM_ID;
--215ms