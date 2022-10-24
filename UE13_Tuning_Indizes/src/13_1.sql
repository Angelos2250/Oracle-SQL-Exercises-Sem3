--1
CREATE  TABLE customer_detail AS (SELECT CUSTOMER_ID,FIRST_NAME,LAST_NAME,EMAIL,DISTRICT,POSTAL_CODE,PHONE,CITY,C3.COUNTRY
FROM CUSTOMER JOIN ADDRESS A2 on CUSTOMER.ADDRESS_ID = A2.ADDRESS_ID
JOIN CITY C2 on A2.CITY_ID = C2.CITY_ID
JOIN COUNTRY C3 ON C2.COUNTRY_ID = C3.COUNTRY_ID);

DROP TABLE customer_detail;

--2
SELECT * FROM customer_detail WHERE LAST_NAME LIKE 'MC%';
--FULL SCAN COST 5

--3
CREATE INDEX last_name_idx ON customer_detail(LAST_NAME);
--FULL SCAN COST 5 Kein Unterschied index wird nicht verwendet

--4
SELECT * FROM customer_detail WHERE SUBSTR(LAST_NAME,1,2) = 'MC';
--FULL SCAN COST 5
CREATE INDEX last_name_idx ON customer_detail(LAST_NAME);
--FULL SCAN COST 5

--5
CREATE INDEX last_name_idx ON customer_detail (SUBSTR(LAST_NAME,1,2));
-- Index scan cost 3
