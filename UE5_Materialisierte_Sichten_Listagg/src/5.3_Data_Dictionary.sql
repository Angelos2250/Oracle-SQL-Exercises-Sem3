-- 1. Erstellen Sie ein Skript für eine angegebene Tabelle, das die Spaltennamen, die Datentypen und
-- die Länge der Datentypen sowie eine Information darüber liefert, ob Nullwerte zulässig sind.
-- Fordern Sie den Benutzer auf, den Tabellennamen einzugeben (&-Operator). Geben Sie auch die
-- Spalten DATA_PRECISION und DATA_SCALE aus und weisen Sie ihnen geeignete
-- Aliasnamen zu.
SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, NULLABLE, DATA_PRECISION AS dp, DATA_SCALE AS Ds
FROM USER_TAB_COLS
WHERE TABLE_NAME = UPPER(?);

-- 2. Fügen Sie der Tabelle STORE einen Kommentar (SQL: COMMENT ON <Tablename> IS
-- '<Comment>') hinzu. Fragen Sie anschließend die View USER_TAB_COMMENTS ab, um zu
-- prüfen, ob der Kommentar hinzugefügt wurde.
COMMENT ON TABLE STORE IS 'THIS IS THE STORE TABLE YEYE';
SELECT *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME = 'STORE';

-- 3. Erstellen Sie ein Skript, das den Spaltennamen (COLUMN_NAME), den Constraint-Namen
-- (CONSTRAINT_NAME), den Constraint-Typ (CONSTRAINT_TYPE), das Suchkriterium
-- (SEARCH_CONDITION) und den Status (STATUS) für eine angegebene Tabelle liefert. Sie müssen
-- die Tabellen USER_CONSTRAINTS und USER_CONS_COLUMNS verknüpfen, um alle diese
-- Informationen zu erhalten. Fordern Sie den Benutzer auf, den Tabellennamen einzugeben.
SELECT COLUMN_NAME, CONSTRAINT_NAME, c.CONSTRAINT_TYPE, c.SEARCH_CONDITION,c.STATUS
FROM USER_CONSTRAINTS c
JOIN USER_CONS_COLUMNS USING (CONSTRAINT_NAME)
WHERE c.TABLE_NAME = UPPER('&tableName');

-- 4. Bereiten Sie ein Skript vor, das Ihnen am Ende des Semesters ermöglicht, alle ihre angelegten
-- Objekte zu entfernen. Erstellen Sie dafür eine Abfrage auf die Tabelle user_objects und
-- generieren Sie die DROP-Statements entsprechend.
-- Achtung: Führen Sie die generierten Statements nicht aus, ansonsten entfernen Sie auch die noch
-- benötigten Tabellen des HR- und Sakila-Schemas!
select 'drop table ', table_name, 'cascade constraints;' from user_tables;