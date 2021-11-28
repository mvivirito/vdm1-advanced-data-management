-- This procedure should be run once per week and is set to automatically run with pgagent.
CREATE OR REPLACE PROCEDURE rebuild_all()
LANGUAGE SQL
AS $$

DELETE FROM all_rentals;
DELETE FROM top_rentals;

CALL rebuild_detailed();
CALL rebuild_summary();

$$;