--Grouping customers:
--	- VIP: At least 12 months of history and spending more than 5000
--  - Regular: At least 12 months of history and spending 5000 or less
--  - New: Customer with history less than 12 months
-- Showing total number of customers for each group

WITH customer_info AS
(
SELECT 
	c.customer_key,
	SUM(s.sales_amount) AS total_spending,
	MIN(s.order_date) AS first_order,
	MAX(s.order_date) AS last_order,
	DATEDIFF(MONTH, MIN(s.order_date), MAX(s.order_date)) AS monthspan
FROM gold.dim_customers AS c
LEFT JOIN gold.fact_sales AS s
ON c.customer_key = s.customer_key
GROUP BY c.customer_key
)

SELECT
	customer_segments,
	COUNT(customer_key) AS total_customers
FROM
(
SELECT
	customer_key,
	CASE WHEN monthspan >= 12 AND total_spending > 5000 THEN 'VIP'
		 WHEN monthspan >= 12 AND total_spending <= 5000 THEN 'Regular'
		 WHEN monthspan < 12 THEN 'New'
		 ELSE 'n/a'
		 END AS customer_segments
FROM customer_info
)t
GROUP BY customer_segments
ORDER BY total_customers DESC