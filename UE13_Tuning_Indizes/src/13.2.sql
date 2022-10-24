
-- Aufgabe 2

--1
CREATE INDEX country_idx ON customer_detail(COUNTRY);

SELECT * FROM customer_detail WHERE COUNTRY = 'Taiwan'AND LAST_NAME LIKE 'MC%';
--Kein Index wird verwendet

--2
SELECT /*+INDEX(c country_idx)*/ *
FROM customer_detail c WHERE c.COUNTRY = 'Taiwan' AND c.LAST_NAME LIKE 'MC%';
--country_idx wird verwendet cost ist 2 mehr