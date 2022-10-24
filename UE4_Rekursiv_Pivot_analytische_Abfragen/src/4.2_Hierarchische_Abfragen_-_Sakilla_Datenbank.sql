
-- 1. Erstellen Sie eine View partners, die Ihnen Schauspielerinnen und Schauspieler-Kollegen ausgibt
-- (wenn sie in irgendeinem Film miteinander gespielt haben). Achten Sie darauf, dass keine
-- Beziehung der SchauspielerInnen auf sich selbst entsteht. Die View soll beide Actor-IDs und die
-- Film-ID enthalten. Damit das Ergebnis überschaubar bleibt, sollen Sie hierfür nur die ersten 13
-- Filme (film_id <= 13) der Datenbank heranziehen. (2 Punkte, 438 Zeilen)

CREATE VIEW partners(Actor,partners,inFilm) AS
SELECT FA.ACTOR_ID,FA2.ACTOR_ID,FA.FILM_ID
FROM FILM_ACTOR FA
JOIN FILM_ACTOR FA2 on FA.FILM_ID = FA2.FILM_ID
WHERE FA.FILM_ID <= 13
AND FA.ACTOR_ID <> FA2.ACTOR_ID
CONNECT BY NOCYCLE PRIOR FA.FILM_ID = FA2.FILM_ID;

SELECT *
FROM partners;

-- 2. Erstellen Sie aufbauend auf der obigen View eine nach IDs sortierte Vorschlagsliste für
-- Schauspielerin „JULIANNE DENCH“. (4 Punkte, 10 Zeilen)

SELECT partners AS Vorschlag
FROM partners
WHERE Actor = ( SELECT ACTOR_ID
                FROM ACTOR
                WHERE FIRST_NAME = 'JULIANNE'
                AND LAST_NAME = 'DENCH')
ORDER BY partners;


SELECT ACTOR_ID
FROM FILM_ACTOR
WHERE FILM_ID = 10;

