--Running Total Sales For Whole Period
SELECT
	order_month,
	total_sales,
	SUM(total_sales) OVER(ORDER BY order_month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_sales
FROM
(
SELECT
	DATETRUNC(MONTH, order_date) AS order_month,
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
)t

--Running Total Sales For Each Year
SELECT
	order_month,
	total_sales,
	SUM(total_sales) OVER(PARTITION BY YEAR(order_month) ORDER BY order_month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_sales
FROM
(
SELECT
	DATETRUNC(MONTH, order_date) AS order_month,
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
)t

--Moving Average Of Price For Whole Period
SELECT
	order_month,
	AVG(average_price) OVER(ORDER BY order_month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS moving_average_price
FROM
(
SELECT
	DATETRUNC(MONTH, order_date) AS order_month,
	AVG(price) AS average_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
)t