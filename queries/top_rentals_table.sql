--drop table top_rentals;

CREATE TABLE IF NOT EXISTS top_rentals (
   title varchar(255),
   family_friendly varchar(3),
   totals varchar(10)
);

--CALL rebuild_summary();

select * from top_rentals;