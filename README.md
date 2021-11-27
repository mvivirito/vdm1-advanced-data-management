# vdm1-advanced-data-management

### Introduction

I am currently working on my Bachelors in Computer Science at WGU and this project is for my Advanced Data Managemnt course. 

## DVD Database

### Project Information

The task of this project is to summarize one real-world business report that can be created from the provided database of a movie rental company. 

## 1. Describe The Dataset

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

Now that we have enough information about our data, I have decided to create a report of the bottom and top 10 performing rentals of all time. To accomplish this report, I will need to combine data from the Payments, Inventory, Rental, and Film tables into a new table called total_sum_rental. 

Let's start by creating a new table to hold our data.

```bash

```


Now we will create our query to sum up the total rentals for each of our films. 

```sql
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
```

