--Top 5 products with highest revenue
SELECT TOP 5
	p.product_name,
	SUM(s.sales_amount) AS total_sales
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_sales DESC

--Worst 5 products with lowest sales
SELECT TOP 5
	p.product_name,
	SUM(s.sales_amount) AS total_sales
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_sales ASC

--Top 5 subcategories with highest revenue
SELECT TOP 5
	p.subcategory,
	SUM(s.sales_amount) AS total_sales
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.subcategory
ORDER BY total_sales DESC

--Top 10 products with highest revenue
SELECT
*
FROM
(
	SELECT
		p.product_name,
		SUM(s.sales_amount) AS total_sales,
		ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC) AS product_rank
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
	GROUP BY p.product_name
)t
WHERE product_rank <= 10

--Top 10 customers with highest revenue
SELECT
*
FROM
(
	SELECT
		c.customer_key,
		c.first_name,
		c.last_name,
		SUM(s.sales_amount) AS total_sales,
		ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC) AS customer_rank
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_customers c
	ON s.customer_key = c.customer_key
	GROUP BY c.customer_key, c.first_name, c.last_name
)t
WHERE customer_rank <= 10

--Worst 3 customers with fewest number of orders
SELECT TOP 3
c.customer_key,
c.first_name,
c.last_name,
COUNT(DISTINCT  order_number) AS total_number_of_orders
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_number_of_orders ASC