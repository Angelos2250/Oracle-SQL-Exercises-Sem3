CREATE TABLE top_actors
(
actor_id NUMBER(5) PRIMARY KEY,
film_count NUMBER,
createdBy VARCHAR2(30) DEFAULT USER,
dateCreated TIMESTAMP DEFAULT SYSDATE,
datedeactivated TIMESTAMP DEFAULT NULL
);

CREATE OR REPLACE PACKAGE top_actor_pkg AS
	FUNCTION GetFilmCount(actor_IDv ACTOR.ACTOR_ID%TYPE,begin_year NUMBER,end_year NUMBER) RETURN NUMBER;
    PROCEDURE GetTopNActors(n_count NUMBER DEFAULT 20,begin_year NUMBER DEFAULT 1900,end_year NUMBER DEFAULT 2000);
    PROCEDURE DeactivateTopActors(films NUMBER);
END;
/

-- TODO Definition des Paktet-Rumpfes/Implementierung
CREATE OR REPLACE PACKAGE BODY top_actor_pkg AS
	--TODO Funktion hineinkopieren
	FUNCTION GetFilmCount(actor_IDv ACTOR.ACTOR_ID%TYPE,begin_year NUMBER,end_year NUMBER)
    RETURN NUMBER 
    IS 
        cnt NUMBER;
	BEGIN
		SELECT COUNT(*) INTO cnt
        FROM ACTOR
        JOIN FILM_ACTOR USING (ACTOR_ID)
        JOIN FILM USING (FILM_ID)
        WHERE ACTOR_ID = actor_IDv
        AND RELEASE_YEAR BETWEEN begin_year AND end_year
        AND LENGTH > 60;
        RETURN cnt;
	END;
    
    PROCEDURE GetTopNActors(n_count NUMBER DEFAULT 20,begin_year NUMBER DEFAULT 1900,end_year NUMBER DEFAULT 2000)
    IS
        CURSOR act_cur IS 
        SELECT First_Name,Last_name, Actor_id ,COUNT(*) AS CNT
        FROM ACTOR
        JOIN FILM_ACTOR USING (ACTOR_ID)
        JOIN FILM USING (FILM_ID)
        WHERE RELEASE_YEAR BETWEEN begin_year AND end_year
        AND LENGTH > 60
        GROUP BY First_Name,Last_name, Actor_id
        ORDER BY cnt DESC
        fetch FIRST n_count rows with ties;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('The top 20 actors from '||begin_year||' TO '||end_year ||' are:');
        FOR actr IN act_cur
		LOOP
            DBMS_OUTPUT.PUT_LINE(actr.First_Name||' '||actr.Last_name||': '||actr.cnt||' films');
            INSERT INTO top_actors(actor_id,film_count)
            VALUES(actr.actor_ID,actr.cnt);
		END LOOP;
    END;
    
    PROCEDURE DeactivateTopActors(films NUMBER) 
    IS
        CURSOR act_cur IS 
        SELECT * FROM top_actors
        FOR UPDATE NOWAIT;
    BEGIN
        FOR actr IN act_cur
		LOOP
            IF (actr.film_count < films) THEN
               UPDATE top_actors 
               SET datedeactivated = SYSDATE
               WHERE CURRENT OF act_cur;
            END IF;
		END LOOP; 
    END;
END;
/

drop table TOP_ACTORS;
ROLLBACK;
Call top_actor_pkg.GetTopNActors();
Call top_actor_pkg.deactivatetopactors(26);
COMMIT;
SELECT* FROM top_actors

