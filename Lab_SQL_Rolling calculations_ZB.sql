-- Lab | SQL Rolling calculations
-- Zsanett Borsos

-- 1. Get number of monthly active customers.
SELECT count(DISTINCT(sakila.rental.customer_id)) AS "Number of active customers",
date_format(sakila.rental.rental_date, "%Y") AS Year, 
date_format(sakila.rental.rental_date, "%m") As Month 
FROM sakila.rental
GROUP BY Year, Month;

-- 2. Active users in the previous month.
WITH active_customers_per_month AS (
	SELECT date_format(sakila.rental.rental_date, "%Y") AS Year, 
	date_format(sakila.rental.rental_date, "%m") AS Month, 
	COUNT(DISTINCT(sakila.rental.customer_id)) AS Active_customers_in_current_month 
	FROM sakila.rental
	GROUP BY Year, Month
    )
SELECT *, LAG (Active_customers_in_current_month) OVER () AS "Active customers in previous month" FROM active_customers_per_month;

-- 3. Percentage change in the number of active customers.
CREATE OR REPLACE VIEW customer_activity_percent AS
WITH active_customers_per_month AS (
	SELECT date_format(sakila.rental.rental_date, "%Y") AS Year, 
	date_format(sakila.rental.rental_date, "%m") AS Month, 
	COUNT(DISTINCT(sakila.rental.customer_id)) AS Active_customers_in_current_month 
	FROM sakila.rental
	GROUP BY Year, Month
    )
SELECT *, LAG (Active_customers_in_current_month) OVER () AS Active_customers_in_previous_month FROM active_customers_per_month;
SELECT *, CONCAT(ROUND((Active_customers_in_current_month - Active_customers_in_previous_month) / Active_customers_in_previous_month * 100, 2), ' %') AS Change_in_active_customers
FROM customer_activity_percent;

-- 4. Retained customers every month.
