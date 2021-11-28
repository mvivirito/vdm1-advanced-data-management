CREATE OR REPLACE PROCEDURE rebuild_summary()
LANGUAGE SQL
AS $$

DELETE FROM top_rentals;

INSERT INTO top_rentals(title,family_friendly, totals)
SELECT 
	title, family_friendly, CAST(SUM(rental_rate) AS money) AS totals
FROM 
	all_rentals
WHERE rental_date::TIMESTAMP::DATE BETWEEN '2005-07-01' AND '2005-08-01'
GROUP BY title,family_friendly
ORDER BY totals DESC
LIMIT 10;

$$;