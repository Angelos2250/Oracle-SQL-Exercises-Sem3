CREATE SEQUENCE identifiers
START WITH 1
INCREMENT BY 1
MAXVALUE 1000000000;

-- dimLocation: city, country, locationID, mapping-ID
CREATE TABLE dimLocation AS
    SELECT identifiers.nextval AS location_id, city, country, originalAddressId
    FROM ( SELECT DISTINCT city, country, address_id AS originalAddressId
                FROM store
                    INNER JOIN address USING (address_id)
                    INNER JOIN city USING (city_id)
                    INNER JOIN country USING (country_id)
    );

ALTER TABLE dimLocation ADD CONSTRAINT dimLocation_pk PRIMARY KEY (location_id);

SELECT * FROM dimLocation;

-- dimCategory:
CREATE TABLE dimCategory AS
    SELECT identifiers.nextval AS category_id,'classification' AS class, genre, originalCategoryId
    FROM ( SELECT DISTINCT name AS genre, category_id AS originalCategoryId
                FROM category
    );

ALTER TABLE dimCategory ADD CONSTRAINT dimCategory_pk PRIMARY KEY (category_id);
ALTER TABLE dimCategory MODIFY class VARCHAR2(25) NOT NULL;

SELECT * FROM dimCategory;

UPDATE dimCategory
SET class = 'Storyline'
WHERE genre IN ('Animation', 'Sci-Fi', 'Sports');

UPDATE dimCategory
SET class = 'Narrative'
WHERE genre IN ('Children', 'Comedy', 'Documentary', 'Drama', 'Family', 'Foreign', 'Travel');

UPDATE dimCategory
SET class = 'Mood'
WHERE genre IN ('Action', 'Horror', 'Music');

UPDATE dimCategory
SET class = 'Others'
WHERE genre NOT IN ('Animation', 'Sci-Fi', 'Sports', 'Children', 'Comedy', 'Documentary', 'Drama', 'Family', 'Foreign', 'Travel','Action', 'Horror', 'Music');

--dimDate:
CREATE TABLE dimDate
(
    date_id  NUMBER,
    ddate   DATE,
    year    NUMBER,
    month   NUMBER,
    quarter NUMBER,
    day     NUMBER,
    weekday VARCHAR(10)
);
ALTER TABLE dimDate ADD CONSTRAINT dimDate_pk PRIMARY KEY (date_id);

DECLARE
    startDate DATE;
    endDate DATE := SYSDATE;
BEGIN
    SELECT TRUNC(MIN(payment_date)) INTO startDate FROM payment;

    FOR n IN 0..(endDate - startDate) LOOP
        INSERT INTO dimDate (date_id, ddate, year, month, quarter, day, weekday)
        VALUES(identifiers.nextval, startDate + n, EXTRACT(year FROM startDate + n),
               EXTRACT(month FROM startDate + n), to_char(startDate + n, 'Q'),
               EXTRACT(day FROM startDate + n), to_char(startDate + n, 'Day'));
    END LOOP;
END;
/

SELECT * FROM dimDate;

--dimLength:
CREATE TABLE dimLength AS
    SELECT identifiers.nextval AS length_id, length,
        CASE WHEN length <= 60 THEN 'short'
             WHEN length > 60 AND length <= 120 THEN 'medium'
             WHEN length > 120 THEN 'long'
        END AS lengthDescription,
        film_id AS originalFilmId
        FROM film;

ALTER TABLE dimLength ADD CONSTRAINT dimLength_pk PRIMARY KEY (length_id);

DROP TABLE dimLength;

SELECT * FROM dimLength;

SELECT * FROM FILM;


-- factRental: Hue: dimLocation und Aktualisierungszeitpunkt

CREATE MATERIALIZED VIEW factRental
AS
SELECT CEIL(return_date - rental_date) days, amount, dimLocation.location_id, dimDate.date_id, dimCategory.category_id, dimLength.length_id
FROM rental
    LEFT JOIN payment USING (rental_id)
    INNER JOIN inventory USING (inventory_id)
    INNER JOIN store USING (store_id)
    INNER JOIN film_category USING (film_id)
    INNER JOIN dimLocation ON (store.address_id = dimLocation.originalAddressId)        -- Mapping
    INNER JOIN dimDate ON (TRUNC(payment_date) = dimDate.ddate)                         -- Mapping
    INNER JOIN dimCategory ON (dimCategory.originalCategoryId = film_category.category_id)
    INNER JOIN dimLength ON (dimLength.originalFilmId = film_id);

DROP MATERIALIZED VIEW factRental;


SELECT COUNT(*), SUM(amount), class
FROM factRental
    INNER JOIN dimCategory USING (category_id)
GROUP BY class;

SELECT * FROM factRental;