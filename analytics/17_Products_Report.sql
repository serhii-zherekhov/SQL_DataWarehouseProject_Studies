IF OBJECT_ID ('gold.report_products', 'V') IS NOT NULL
	DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS
WITH base_query AS
(
SELECT 
	s.order_number,
	s.customer_key,
	s.order_date,
	s.sales_amount,
	s.quantity,
	p.product_key,
	p.product_name,
	p.category,
	p.subcategory,
	p.cost
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE order_date IS NOT NULL
),

product_aggregation AS
(
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT customer_key) AS total_customers,
	MAX(order_date) AS last_order_date,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS monthspan
FROM base_query
GROUP BY product_key,
		 product_name,
		 category,
		 subcategory,
		 cost
)

SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	CASE WHEN total_sales > 50000 THEN 'High-Performer'
		 WHEN total_sales >= 10000 THEN 'Mid-Performer'
		 WHEN total_sales >= 0 THEN 'Low-Performer'
		 ELSE 'n/a'
		 END AS product_segments,
	last_order_date,
	DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	monthspan,
	CASE WHEN total_orders = 0 THEN 0
		 ELSE total_sales / total_orders
		 END AS average_order_value,
	CASE WHEN monthspan = 0 THEN total_sales
		 ELSE total_sales / monthspan
		 END AS average_monthly_spend
FROM product_aggregation