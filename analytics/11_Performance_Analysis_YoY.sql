--Comparing total sales by year with average sales for whole period and the previous year`s sales 
--Year-over-year
WITH yearly_product_sales AS
(
SELECT
	YEAR(s.order_date) AS order_year,
	p.product_name,
	SUM(s.sales_amount) AS current_sales
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE s.order_date IS NOT NULL
GROUP BY YEAR(s.order_date), p.product_name
)

SELECT
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER(PARTITION BY product_name) AS average_sales,
	current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS delta_average_sales,
	CASE 
		WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Average'
		WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Average'
		ELSE 'Average'
		END AS average_change,
	LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) AS previous_year_sales,
	current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) AS delta_previous_year_sales,
	CASE 
		WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) > 0 THEN 'Increase'
		WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) < 0 THEN 'Decrease'
		ELSE 'No change'
		END AS sales_change
FROM yearly_product_sales
ORDER BY product_name, order_year