CREATE OR REPLACE FUNCTION all_rentals_insert_trigger_fnc()
  RETURNS trigger AS
$$
BEGIN
    CALL rebuild_summary();
RETURN NULL;
END;
$$
LANGUAGE 'plpgsql';

--CREATE TRIGGER all_rentals_trigger
--  AFTER INSERT
--  ON "all_rentals"
--  FOR EACH STATEMENT
--  EXECUTE PROCEDURE all_rentals_insert_trigger_fnc();
 
