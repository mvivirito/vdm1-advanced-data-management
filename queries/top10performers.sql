SELECT 
	film.title, sum(payment.amount) as total_rentals
FROM 
	rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON film.film_id  = inventory.film_id
INNER JOIN payment ON rental.rental_id = payment.rental_id
group by film.film_id
order by total_rentals desc
limit 10;

