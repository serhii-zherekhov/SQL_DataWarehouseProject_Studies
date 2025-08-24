SELECT
	*,
	MIN(order_date) OVER() AS min_order_date,
	MAX(order_date) OVER() AS max_order_date
FROM gold.fact_sales

SELECT
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	CONCAT(DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) / 12, ' years ',
		   DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) % 12, ' months') AS Duration
FROM gold.fact_sales