SELECT S.MANAGER_STAFF_ID,S.STORE_ID,ST.STAFF_ID,SUM(P.AMOUNT)
FROM STORE S
JOIN STAFF ST on S.STORE_ID = ST.STORE_ID
JOIN PAYMENT P on ST.STAFF_ID = P.STAFF_ID
GROUP BY GROUPING SETS ((S.MANAGER_STAFF_ID,S.STORE_ID,ST.STAFF_ID),(S.MANAGER_STAFF_ID,S.STORE_ID),(S.STORE_ID,ST.STAFF_ID));

SELECT F.TITLE,F.RELEASE_YEAR,C3.COUNTRY,C4.NAME,SUM(P.AMOUNT),COUNT(P.PAYMENT_ID)
FROM FILM F
JOIN INVENTORY I on F.FILM_ID = I.FILM_ID
JOIN RENTAL R on I.INVENTORY_ID = R.INVENTORY_ID
JOIN PAYMENT P on R.RENTAL_ID = P.RENTAL_ID
JOIN STORE S on S.STORE_ID = I.STORE_ID
JOIN ADDRESS A2 on A2.ADDRESS_ID = S.ADDRESS_ID
JOIN CITY C2 on C2.CITY_ID = A2.CITY_ID
JOIN COUNTRY C3 on C3.COUNTRY_ID = C2.COUNTRY_ID
JOIN FILM_CATEGORY FC on F.FILM_ID = FC.FILM_ID
JOIN CATEGORY C4 on C4.CATEGORY_ID = FC.CATEGORY_ID
WHERE C4.NAME = 'Family' OR C4.NAME ='Children' OR C4.NAME ='Travel'
GROUP BY GROUPING SETS ( (F.TITLE,F.RELEASE_YEAR,C3.COUNTRY,C4.NAME) )
ORDER BY C3.COUNTRY;

SELECT S.MANAGER_STAFF_ID,S.STORE_ID,SUM(AMOUNT)
FROM STORE S
JOIN STAFF S2 on S.STORE_ID = S2.STORE_ID
JOIN PAYMENT P on S2.STAFF_ID = P.STAFF_ID
GROUP BY CUBE(S.STORE_ID,S.MANAGER_STAFF_ID);
-- GROUP BY GROUPING SETS ( (S.MANAGER_STAFF_ID,S.STORE_ID),(S.MANAGER_STAFF_ID),(S.STORE_ID),() );

SELECT S.MANAGER_STAFF_ID,S.STORE_ID,SUM(AMOUNT),
       GROUPING(S.MANAGER_STAFF_ID) GRP_MANAGER_ID,
       GROUPING(S.STORE_ID) GRP_STORE_ID
FROM STORE S
JOIN STAFF S2 on S.STORE_ID = S2.STORE_ID
JOIN PAYMENT P on S2.STAFF_ID = P.STAFF_ID
GROUP BY CUBE(S.STORE_ID,S.MANAGER_STAFF_ID);
