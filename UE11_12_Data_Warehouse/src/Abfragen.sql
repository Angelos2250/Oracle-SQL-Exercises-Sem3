--4
--4.1
SELECT lengthDescription, COUNT(lengthDescription) AS rentals
FROM factRental
    INNER JOIN dimLength USING (length_id)
GROUP BY lengthDescription
ORDER BY rentals DESC;

--Anhand der Ausgabe kann man sehen, dass Filme mit einer Länge >= 120 Minuten
--am öftesten ausgeliehen werden. Diese sind dicht gefolgt von Filmen mit einer Länge
--zwischen 60 und 120 Minuten und das Schlusslicht bilden Filme mit einer Länge von
--weniger als 60 Minuten.

--4.2
SELECT genre, ROUND(AVG(amount), 2)
FROM factRental
    INNER JOIN dimCategory USING (category_id)
GROUP BY genre
ORDER BY AVG(amount) DESC;

--An den Daten kann man sehen, dass 'Sci-Fi' Filme die lukrativsten sind und
--somit ist das Genre wahrscheinlich das beliebteste der Kunden. Platz zwei
--und drei belegen in diesem Fall das Genre 'Travel' und 'Documentary'.

--4.3
SELECT quarter, SUM(amount)
FROM factRental
    INNER JOIN dimDate USING(date_id)
GROUP BY quarter
ORDER BY SUM(amount) DESC;

--Am Ergebnis lässt sich feststellen, dass im ersten Quartal eines Jahres die
--die meisten Filme ausgeliehen werden. Folglich ist das erste Quartal das lukrativste.

--4.4
SELECT month, quarter,
       AVG(days)
FROM factRental
    INNER JOIN dimDate USING (date_id)
GROUP BY GROUPING SETS((month), (quarter), ())
ORDER BY AVG(days) DESC;

--Die Ausleihdauer ist im ersten Monat eines Jahres die Längste und führt
--mit einer durchschnittlichen Anzahl von 5.5 Tagen.
--Folglich ist das erste Quatal eines Jahres, jenes mit der Längsten durchschnittlichen
--Ausleihdauer.
--Überraschenderweise ist das vierte Quartal, obwohl dieses bei der Abfrage, welches
--Quartal am lukrativsten ist, den vierten Platz belegt, in dieser Abfrage auf dem zweiten Platz
--der Quartale.

--4.5
SELECT country, lengthDescription, COUNT(*), SUM(amount)
FROM factRental
    INNER JOIN dimLength USING (length_id)
    INNER JOIN dimLocation USING (location_id)
GROUP BY CUBE(country, lengthDescription)
ORDER BY SUM(amount);

--Österreich und Australien leihen am wenigsten Filme aus, wohingegen Japan der
--Spitzenreiter ist. Australier leihen sich eher Filme, mit einer Länge zwischen 60 und 120
--Minuten aus, als Filme, welche länger als 120 Minuten dauern.
--Da Filme mit einer Laufzeit von weniger als 60 Minuten, am wenigsten zum Gewinn beitragen,
--wäre es durchaus eine Überlegung wert diese Filme aus dem Sortiment zu nehmen.

--4.6
SELECT country, weekday, COUNT(*)
FROM factRental
    INNER JOIN dimLocation USING (location_id)
    INNER JOIN dimDate USING (date_id)
GROUP BY weekday, country
ORDER BY country, count(*);

--Australien bildet das Schlusslicht. Dort werden an einem Montag nur um die 353 Filme
--ausgeliehen.
--Überraschend ist, dass Österreich an einem Sonntag die wenigsten Filme ausleiht.
--Möglicherweise weil der Sonntag in Österreich einen hohen Stellenwert hat.
--Japan hingegen sitzt an der Spitze der Ergebnisse, denn dort werden an einem Sonntag bis zu
--818 Filme ausgeliehen. Das könnte auf die hohe Bevölkerungszahl zuruckzuführen sein.

--4.7
SELECT month, year, sum_Month,
       SUM(sum_Month) OVER (PARTITION BY year
                            ORDER BY year, month ROWS BETWEEN
                            UNBOUNDED PRECEDING AND CURRENT ROW)
       AS cumulative_Sum
FROM (SELECT month, year, SUM(amount) AS sum_Month
      FROM factRental
            INNER JOIN dimCategory USING (category_id)
            INNER JOIN dimDate USING (date_id)
      WHERE class = 'Narrative'
      GROUP BY year, month)
GROUP BY month, year, sum_Month;

--Auffallend ist vor allem die Tatsache, dass im Jahr 2014 vom Januar bis November
--mehr eingenommen wurde, als im Jahr 2015 im selben Zeitraum.