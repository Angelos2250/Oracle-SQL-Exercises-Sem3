SELECT NAME, RATING, COUNT(*), SUM(LENGTH)
FROM FILM
JOIN FILM_CATEGORY USING (FILM_ID)
JOIN CATEGORY USING (CATEGORY_ID)
WHERE NAME = 'Comedy' OR NAME = 'Music'
GROUP BY ROLLUP(NAME,RATING);

SELECT NAME,RATING,COUNT(*),SUM(LENGTH)
FROM FILM
JOIN FILM_CATEGORY USING (FILM_ID)
JOIN CATEGORY USING (CATEGORY_ID)
WHERE NAME = 'Comedy' OR NAME = 'Music'
GROUP BY NAME, RATING
UNION ALL
SELECT NAME, NULL,COUNT(*),SUM(LENGTH)
FROM FILM
JOIN FILM_CATEGORY USING (FILM_ID)
JOIN CATEGORY USING (CATEGORY_ID)
WHERE NAME = 'Comedy' OR NAME = 'Music'
GROUP BY NAME
UNION ALL
SELECT NULL, NULL,COUNT(*),SUM(LENGTH)
FROM FILM
JOIN FILM_CATEGORY USING (FILM_ID)
JOIN CATEGORY USING (CATEGORY_ID)
WHERE NAME = 'Comedy' OR NAME = 'Music'
GROUP BY RATING
ORDER BY NAME;