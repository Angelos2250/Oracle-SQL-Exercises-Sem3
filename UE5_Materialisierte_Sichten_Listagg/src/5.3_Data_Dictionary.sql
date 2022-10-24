-- 1. Erstellen Sie ein Skript f�r eine angegebene Tabelle, das die Spaltennamen, die Datentypen und
-- die L�nge der Datentypen sowie eine Information dar�ber liefert, ob Nullwerte zul�ssig sind.
-- Fordern Sie den Benutzer auf, den Tabellennamen einzugeben (&-Operator). Geben Sie auch die
-- Spalten DATA_PRECISION und DATA_SCALE aus und weisen Sie ihnen geeignete
-- Aliasnamen zu.
SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, NULLABLE, DATA_PRECISION AS dp, DATA_SCALE AS Ds
FROM USER_TAB_COLS
WHERE TABLE_NAME = UPPER(?);

-- 2. F�gen Sie der Tabelle STORE einen Kommentar (SQL: COMMENT ON <Tablename> IS
-- '<Comment>') hinzu. Fragen Sie anschlie�end die View USER_TAB_COMMENTS ab, um zu
-- pr�fen, ob der Kommentar hinzugef�gt wurde.
COMMENT ON TABLE STORE IS 'THIS IS THE STORE TABLE YEYE';
SELECT *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME = 'STORE';

-- 3. Erstellen Sie ein Skript, das den Spaltennamen (COLUMN_NAME), den Constraint-Namen
-- (CONSTRAINT_NAME), den Constraint-Typ (CONSTRAINT_TYPE), das Suchkriterium
-- (SEARCH_CONDITION) und den Status (STATUS) f�r eine angegebene Tabelle liefert. Sie m�ssen
-- die Tabellen USER_CONSTRAINTS und USER_CONS_COLUMNS verkn�pfen, um alle diese
-- Informationen zu erhalten. Fordern Sie den Benutzer auf, den Tabellennamen einzugeben.
SELECT COLUMN_NAME, CONSTRAINT_NAME, c.CONSTRAINT_TYPE, c.SEARCH_CONDITION,c.STATUS
FROM USER_CONSTRAINTS c
JOIN USER_CONS_COLUMNS USING (CONSTRAINT_NAME)
WHERE c.TABLE_NAME = UPPER('&tableName');

-- 4. Bereiten Sie ein Skript vor, das Ihnen am Ende des Semesters erm�glicht, alle ihre angelegten
-- Objekte zu entfernen. Erstellen Sie daf�r eine Abfrage auf die Tabelle user_objects und
-- generieren Sie die DROP-Statements entsprechend.
-- Achtung: F�hren Sie die generierten Statements nicht aus, ansonsten entfernen Sie auch die noch
-- ben�tigten Tabellen des HR- und Sakila-Schemas!
select 'drop table ', table_name, 'cascade constraints;' from user_tables;