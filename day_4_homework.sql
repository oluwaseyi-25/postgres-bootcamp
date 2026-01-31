-- -----------------------------------------------------
-- Q1: List all customers along with their total payment amount.
-- Output: customer_id, full_name, total_amount
SELECT 
	c.customer_id,
	CONCAT(first_name, ' ', last_name) AS full_name,
	SUM(amount) as total_amount
FROM public.customer as c
JOIN public.payment as p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id;

-- -----------------------------------------------------
-- Q2: Retrieve the top 10 customers by total amount spent.
-- Output: full_name, email, total_amount
SELECT 
	CONCAT(first_name, ' ', last_name) AS full_name,
	c.email,
	SUM(amount) as total_amount
FROM public.customer as c
JOIN public.payment as p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY total_amount DESC 
LIMIT 10;

-- -----------------------------------------------------
-- Q3: Display all films and their corresponding categories.
-- Tables: film, film_category, category
SELECT
	f.title as film_title,
	c.name as category
FROM public.film as f
JOIN public.film_category as fc 
	ON f.film_id = fc.film_id
JOIN public.category as c 
	ON fc.category_id = c.category_id;

-- -----------------------------------------------------
-- Q4: Find the number of rentals made by each customer.
-- Output: customer_id, full_name, total_rentals
SELECT
	c.customer_id,
	CONCAT(first_name, ' ', last_name) AS full_name,
	COUNT(r.rental_id) as total_rentals
FROM public.customer as c
JOIN public.rental as r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id;
	
-- -----------------------------------------------------
-- Q5: List customers who have never made a payment.
-- Hint: LEFT JOIN
SELECT
	CONCAT(first_name, ' ', last_name) AS customer_name
FROM public.customer as c
LEFT JOIN public.payment as p
ON c.customer_id = p.customer_id
WHERE p.payment_id is null;

-- -----------------------------------------------------
-- Q6: Show total revenue generated per store.
-- Tables: store, staff, payment
SELECT
	sto.store_id,
	SUM(p.amount) as generated_revenue
FROM store sto
JOIN staff sta ON sto.store_id = sta.store_id
JOIN payment p ON sta.staff_id = p.staff_id
GROUP BY sto.store_id;


-- -----------------------------------------------------
-- Q7: Identify the top 5 most rented movies.
-- Output: film_title, rental_count
SELECT 
	f.title,
	COUNT(r.rental_id) AS rental_count
FROM film as f
JOIN inventory as i ON f.film_id = i.film_id
JOIN rental as r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id
ORDER BY rental_count DESC
LIMIT 5;

-- -----------------------------------------------------
-- Q8 (BONUS): Find customers who rented more than 30 films.
-- Output: full_name, rental_count
SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	COUNT(r.rental_id) AS rental_count
FROM customer c 
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id
HAVING COUNT(r.rental_id) > 30;