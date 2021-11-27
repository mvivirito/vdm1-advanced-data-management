SELECT 
	  rental.rental_id, film.title, rental_rate,  rental.rental_date
FROM 
	rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON film.film_id  = inventory.film_id
INNER JOIN payment ON rental.rental_id = payment.rental_id

order by rental_date desc;




