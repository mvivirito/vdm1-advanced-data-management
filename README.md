# vdm1-advanced-data-management

### Introduction

I am currently working on my Bachelors Degree in Computer Science at [WGU](https://www.wgu.edu/online-it-degrees/bachelors-programs.html) and this project is for the Advanced Data Managemnt course D191. 

## DVD Database

### Project Information

The goal of this project is to export data from our primary database into a new aggregation. We should be able to answer some real-world business questions from reports generated using our newly aggregated data. 

The real-world business question that we want to answer with our reports is what are our best performing titles every month. The detailed aggregate section will contain all rentals placed with their rental date and rental price. Through this data we will be able generate a monthly top 10 with sum totals for each film. 

#### Business Use Cases

The detailed section of the report will allow us to have a runing log of each rental. The biggest use for the detailed section is all of the sub reports that we can run off of it. For example we can create top 10 rentals per day, week, month, year, or all time. We can also generate reports to find the weakest performing titles as well. Our main summary in this scenario will be top 10 rentals of the month. 

#### Datafreshness

Our data should be refreshed weekly so that we can run up to date weekly reports. Running the refresh daily would be a burdon to our database and should only be done if requested. 

## Describe The Dataset

We can dig into the SQL SHELL (psql) command line utility that comes bundled with the postgresql13 installation for [Mac](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads) to see exactly what we are working with. This should be similar for any Windows or Linux install. 

![](images/psql.png)

# Let's log in. 

```bash
Server [localhost]: 
Database [postgres]: 
Port [5433]: 
Username [postgres]: 
Password for user postgres:********* 

psql (13.5)
Type "help" for help.

postgres=# 
``` 
# Now let's run some commands to get more info

```bash
postgres=# \l
                             List of databases
   Name    |  Owner   | Encoding | Collate | Ctype |   Access privileges   
-----------+----------+----------+---------+-------+-----------------------
 dvdrental | postgres | UTF8     | C       | C     | 
 postgres  | postgres | UTF8     | C       | C     | 
 template0 | postgres | UTF8     | C       | C     | =c/postgres          +
           |          |          |         |       | postgres=CTc/postgres
 template1 | postgres | UTF8     | C       | C     | =c/postgres          +
           |          |          |         |       | postgres=CTc/postgres
(4 rows)

postgres=# \c dvdrental
You are now connected to database "dvdrental" as user "postgres".
dvdrental=# \dt
             List of relations
 Schema |     Name      | Type  |  Owner   
--------+---------------+-------+----------
 public | actor         | table | postgres
 public | address       | table | postgres
 public | category      | table | postgres
 public | city          | table | postgres
 public | country       | table | postgres
 public | customer      | table | postgres
 public | film          | table | postgres
 public | film_actor    | table | postgres
 public | film_category | table | postgres
 public | inventory     | table | postgres
 public | language      | table | postgres
 public | payment       | table | postgres
 public | rental        | table | postgres
 public | staff         | table | postgres
 public | store         | table | postgres
(15 rows)

dvdrental=# 

```

As we can see the provided dataset includes customer information, film information, store information, etc. below is an ERD diagram with more detailed information which can be generated automatically from PgAdmin4. 

# ERD Diagram

Here is a detailed view of the dataset

![](images/erd.png)

# Real World Report

Now that we have enough information about our data, I have decided to create a summary report of the top 10 performing rentals of the month and if they are family friendly or not. This will be useful to the company, so that they can know what kind of inventory to keep in stock. To accomplish this report, I will need to combine data from the Payments, Inventory, Rental, and Film tables into a new table called all_rentals, this will be our detailed table. I will also createa another table called top_rentals which will take data from the detailed table and create our summary report. 

### Table Creation

Let's start by creating the new detailed and summary tables. The fields included are as shown below. 

```sql
CREATE TABLE IF NOT EXISTS all_rentals (
   title varchar(255),
   rating mpaa_rating,
   rental_rate numeric(4,2),
   rental_date TIMESTAMP
);

CREATE TABLE IF NOT EXISTS top_rentals (
   title varchar(255),
   family_friendly varchar(3),
   totals varchar(10)
);

```

### data extraction

Here is the query that we can run to populate our Detailed section of our report (I will create a procedure for this further down).

```sql
INSERT INTO all_rentals(title,rating, rental_rate, rental_date)
SELECT
	film.title, film.rating, rental_rate, rental.rental_date
FROM 
	rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON film.film_id  = inventory.film_id
INNER JOIN payment ON rental.rental_id = payment.rental_id
order by rental_date desc;
```

### Transformation

As you can see we have a family_friendly field in our top_rentals table. This will be populated using a function to transfrom the ratings into a simple Yes or No family friendly value. Here is the plpgsql function below.

```sql
Create or replace function family_friendly (rating mpaa_rating)
returns varchar
Language plpgsql
as
$$
Declare
 friendly varchar;
	Begin
	
	 if rating = 'R' then
		 friendly := 'No';
	 elseif rating = 'NC-17' then
		 friendly := 'No';
	 else 
		 friendly := 'Yes';
	 end if;
	
	return friendly;
End;
$$;

```


## Populate detailed and summary tables


I have created some procedures to populate the all_rentals table from the main dvdrental database and another procedure to populate the summary table from the all_rentals table. I have even created another procedure to refresh both detailed and summary at the same time. Here they are below

### rebuild_detailed_procedure

```sql
CREATE OR REPLACE PROCEDURE rebuild_detailed()
LANGUAGE SQL
AS $$

DELETE FROM all_rentals;

INSERT INTO all_rentals(title,rating, rental_rate, rental_date)
SELECT
	film.title, film.rating, rental_rate, rental.rental_date
FROM 
	rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON film.film_id  = inventory.film_id
INNER JOIN payment ON rental.rental_id = payment.rental_id
order by rental_date desc;

$$;
```
### rebuild_summary_procedure

```sql
CREATE OR REPLACE PROCEDURE rebuild_summary()
LANGUAGE SQL
AS $$

DELETE FROM top_rentals;

INSERT INTO top_rentals(title,family_friendly, totals)
SELECT 
	title, family_friendly(rating), CAST(SUM(rental_rate) AS money) AS totals
FROM 
	all_rentals
WHERE rental_date::TIMESTAMP::DATE BETWEEN '2005-07-01' AND '2005-08-01'
GROUP BY title,family_friendly
ORDER BY totals DESC
LIMIT 10;

$$;

```

### rebuild_all_procedure

This stored procedure can refresh the data in both the detailed and summary tables. It will first clear both of the tables and populate them with fresh data. This procedure should be executed once per week on Monday's to ensure data freshness. We can use a tool like pgagent to schedule a recurring job for this functionality. 

```sql
-- This procedure should be run once per week and is set to automatically run with pgagent.
CREATE PROCEDURE rebuild_all()
LANGUAGE SQL
AS $$

DELETE FROM all_rentals;
DELETE FROM top_rentals;

CALL rebuild_detailed();
CALL rebuild_summary();

$$;
```

Here is an example of how pgagent can be configured if installed as an addon on pgadmin 4.
![](images/pga1.png)
![](images/pga2.png)
![](images/pga3.png)


### Creating a trigger on detailed table

We needed a way to automaitcally update the summary table if new data was added to the detailed table. So I created a trigger to handle this. 

```sql
CREATE OR REPLACE FUNCTION all_rentals_insert_trigger_fnc()
  RETURNS trigger AS
$$
BEGIN
    CALL rebuild_summary();
RETURN NULL;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER all_rentals_trigger
  AFTER INSERT
  ON "all_rentals"
  FOR EACH STATEMENT
  EXECUTE PROCEDURE all_rentals_insert_trigger_fnc();
 ```