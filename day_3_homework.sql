-- Questions

-- 1. Retrieve all unique customer first names from the customer table.

SELECT DISTINCT first_name
FROM customer;

-- 2. Find the top 5 customers who have spent the most money.

SELECT
	customer_id,
    amount
FROM payment
ORDER BY amount DESC
LIMIT 5;


-- 3. List all films with a rental rate greater than 4.00.

SELECT
	film_id,
	title,
	rental_rate
FROM film
WHERE rental_rate > 4.00;

-- 4. Count the number of payments per customer and display only customers with more than 15 payments.

SELECT
	customer_id, 
	count(*) as num_of_payments
FROM payment
GROUP BY customer_id
HAVING count(*) > 15;

-- 5. Retrieve the first 10 films alphabetically using FETCH.
SELECT 
	film_id,
	title
FROM film
ORDER BY title
FETCH FIRST 10 ROWS ONLY;

-- 6. Find the total amount paid per staff member.

SELECT 
	staff_id,
	SUM(amount) as total_amount
FROM payment
GROUP BY staff_id;

-- 7. List customers whose email ends with .org.

SELECT
	customer_id,
	first_name || ' ' || last_name AS full_name,
	email
FROM customer
WHERE email LIKE '%.org';

-- 8. Using DISTINCT ON, retrieve the latest payment record per customer.

SELECT DISTINCT ON (customer_id)
	customer_id, 
	amount,
	payment_date
FROM payment
ORDER BY customer_id, payment_date DESC;

-- 9. Display the average payment amount per customer, ordered from highest to lowest.
SELECT
	customer_id,
	AVG(amount) as average_payment
FROM payment
GROUP BY customer_id
ORDER BY average_payment;


-- 10. Retrieve all payments made between $2.99 and $5.99.

SELECT
	payment_id,
	amount,
	customer_id,
	payment_date
FROM payment
WHERE amount BETWEEN 2.99 AND 5.99;

-- Bonus Challenge

-- - Identify the top 3 cities with the highest number of customers.

SELECT
	ci.city,
	COUNT(*) as num_of_customers
FROM customer cu
	JOIN address a on a.address_id = cu.address_id
	JOIN city ci on a.city_id = ci.city_id
GROUP BY ci.city
ORDER BY num_of_customers DESC
LIMIT 3;
