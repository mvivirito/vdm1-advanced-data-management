--drop table all_rentals;

CREATE TABLE IF NOT EXISTS all_rentals (
   title varchar(255),
   family_friendly varchar(3),
   rental_rate numeric(4,2),
   rental_date TIMESTAMP
);

select * from all_rentals;
