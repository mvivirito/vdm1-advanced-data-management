--drop table all_rentals;

CREATE TABLE IF NOT EXISTS all_rentals (
   title varchar(255),
   rating mpaa_rating,
   rental_rate numeric(4,2),
   rental_date TIMESTAMP
);


