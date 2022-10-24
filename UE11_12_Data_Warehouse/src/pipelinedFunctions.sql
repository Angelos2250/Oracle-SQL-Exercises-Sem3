CREATE OR REPLACE FUNCTION get_best_worst_genre (p_city IN VARCHAR2 := NULL, p_country IN VARCHAR2 := NULL)
RETURN genre_tab PIPELINED AS
    min_amount NUMBER := 0;
    max_amount NUMBER := 0;
    info VARCHAR2(60) := NULL;

    CURSOR genre_cursor (min_amount NUMBER, max_amount NUMBER) IS
        SELECT genre, amount
            FROM factRental
                INNER JOIN dimCategory USING (category_id)
                INNER JOIN dimLocation USING (location_id)
            WHERE amount IN (min_amount, max_amount) AND p_city = city AND p_country = country;

BEGIN
    SELECT MIN(amount), MAX(amount) INTO min_amount, max_amount
    FROM factRental
        INNER JOIN dimCategory USING (category_id)
        INNER JOIN dimLocation USING (location_id)
    WHERE  p_city = city AND p_country = country;

    FOR genre_rec IN genre_cursor(min_amount, max_amount) LOOP
        IF genre_rec.amount = min_amount THEN
            info := 'worst';
        ELSE
            info := 'best';
        END IF;
        info := info || ' in genre ' || genre_rec.genre;
        -- hier erfolgt die laufende Übergabe an das aufrufende Query
        PIPE ROW(genre_row(genre_rec.genre, genre_rec.amount, info));
    END LOOP;

  RETURN;       -- RETURN ist leer, da nichts mehr zurückgegeben wird
END;
/