-- Welcome to the SQL Joins lab!

-- In this lab, you will be working with the Sakila database on movie rentals. Specifically, you will be practicing how to perform joins on multiple tables in SQL. Joining multiple tables is a fundamental concept in SQL, allowing you to combine data from different tables to answer complex queries. Furthermore, you will also practice how to use aggregate functions to calculate summary statistics on your joined data.

-- Challenge - Joining on multiple tables
-- Write SQL queries to perform the following tasks using the Sakila database:

USE sakila;

-- 1. List the number of films per category.
SELECT c.category_id, COUNT(title) as title_total
FROM sakila.film_category as c
JOIN sakila.film as f
ON f.film_id = c.film_id
GROUP BY c.category_id;

-- 2. Display the total amount rung up by each staff member in August of 2005.
SELECT *
FROM payment;

SELECT SUM(amount) as payment_total, month(payment_date), s.first_name, s.last_name
FROM sakila.payment as p
JOIN sakila.staff as s
ON p.staff_id = s.staff_id
WHERE EXTRACT(YEAR FROM payment_date)=2005 AND EXTRACT(MONTH FROM payment_date) = 08
GROUP BY month(payment_date), first_name, last_name
ORDER BY month(payment_date);

SELECT staff_id, SUM(amount) AS 'rung_up_amount', DATE_FORMAT(payment_date, '%M %Y') AS 'month_and_year'
FROM payment
WHERE EXTRACT(YEAR FROM payment_date) = 2005
AND EXTRACT(MONTH FROM payment_date) = 8
GROUP BY staff_id;

SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

USE sakila;

-- 3. Which actor has appeared in the most films.
SELECT first_name, last_name, COUNT(a.actor_id)
FROM actor a
JOIN film_actor f
ON a.actor_id = f.actor_id
GROUP BY first_name, last_name, a.actor_id
ORDER BY COUNT(film_id) DESC;

SELECT ac.actor_id, ac.first_name, ac.last_name, COUNT(fa.actor_id) AS 'film_count'
FROM sakila.actor AS ac
JOIN sakila.film_actor AS fa
ON ac.actor_id = fa.actor_id
GROUP BY ac.actor_id, ac.first_name, ac.last_name
ORDER BY film_count DESC
LIMIT 1;

-- 4. Most active customer (the customer that has rented the most number of films).
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS rental_count 
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY rental_count DESC
LIMIT 1;

-- 5. Display the first and last names, as well as the address, of each staff member.
SELECT s.first_name, s.last_name, s.address_id, a.address
FROM staff s
JOIN address a
ON a.address_id = s.address_id
GROUP BY first_name;

-- 6. List each film and the number of actors who are listed for that film.
SELECT title, COUNT(f.film_id)
FROM film f
JOIN film_actor a
ON f.film_id = a.film_id
GROUP BY f.film_id;

-- 7. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name.
SELECT c.last_name, c.first_name, c.customer_id, SUM(amount) AS 'Total_paid_by_customer' 
FROM payment p
JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY c.last_name
ORDER BY c.last_name ASC;

-- 8. List the titles of films per category.
SELECT c.category_id, COUNT(title) as title_total
FROM sakila.film_category as c
JOIN sakila.film as f
ON f.film_id = c.film_id
GROUP BY c.category_id;

SELECT c.name AS category_name, f.title AS film_title
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
ORDER BY category_name, film_title;
