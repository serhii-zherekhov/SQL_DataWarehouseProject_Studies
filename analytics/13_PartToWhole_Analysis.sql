--Categories which contribute the most to overall sales
WITH category_sales AS
(
SELECT
	p.category,
	SUM(s.sales_amount) AS total_sales
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.category
)

SELECT 
	category,
	total_sales AS total_sales_by_category,
	SUM(total_sales) OVER() AS total_sales,
	CONCAT(ROUND(CAST(total_sales AS FLOAT) / (SUM(total_sales) OVER()) * 100, 2), '%') AS per_total
FROM category_sales
ORDER BY total_sales_by_category DESC