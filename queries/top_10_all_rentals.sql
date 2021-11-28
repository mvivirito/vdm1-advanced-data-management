SELECT 
	title, family_friendly, cast(sum(rental_rate) as money) as totals
FROM 
	all_rentals
WHERE rental_date::TIMESTAMP::DATE between '2005-06-01' and '2005-07-01'
group by title,family_friendly
order by totals desc
limit 10;