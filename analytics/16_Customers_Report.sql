IF OBJECT_ID ('gold.report_customers', 'V') IS NOT NULL
	DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS
WITH base_query AS
(
SELECT
	s.order_number,
	s.product_key,
	s.order_date,
	s.sales_amount,
	s.quantity,
	c.customer_key,
	c.customer_number,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	DATEDIFF(YEAR, c.birth_date, GETDATE()) AS age
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
WHERE order_date IS NOT NULL
),

customer_aggregation AS
(
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT product_key) AS total_products,
	MAX(order_date) AS last_order_date,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS monthspan
FROM base_query
GROUP BY customer_key,
		 customer_number,
		 customer_name,
		 age
)

SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE WHEN age < 20 THEN '<-19'
		 WHEN age BETWEEN 20 AND 29 THEN '20-29'
		 WHEN age BETWEEN 30 AND 39 THEN '30-39'
		 WHEN age BETWEEN 40 AND 49 THEN '40-49'
		 WHEN age >= 50 THEN '50->'
		 ELSE 'n/a'
		 END AS age_group,
	CASE WHEN monthspan >= 12 AND total_sales > 5000 THEN 'VIP'
		 WHEN monthspan >= 12 AND total_sales <= 5000 THEN 'Regular'
		 WHEN monthspan < 12 THEN 'New'
		 ELSE 'n/a'
		 END AS customer_segments,
	last_order_date,
	DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	monthspan,
	CASE WHEN total_orders = 0 THEN 0
		 ELSE total_sales / total_orders
		 END AS average_order_value,
	CASE WHEN monthspan = 0 THEN total_sales
		 ELSE total_sales / monthspan
		 END AS average_monthly_spend
FROM customer_aggregation