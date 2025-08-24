--Total Sales
--How many items are sold
--Average selling price
--Total number of orders
--Total number of distinct orders (real number)
--Total number of products
--Total number of customers
--Total number of customers that has placed an order
SELECT 'Total Sales Amount' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Items Sold', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
--SELECT 'Total Number Of Orders', COUNT(order_number) FROM gold.fact_sales
--UNION ALL
SELECT 'Total Number Of Orders', COUNT(DISTINCT order_number) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Number Of Products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Number Of Customers', COUNT(DISTINCT customer_key) FROM gold.dim_customers
--UNION ALL
--SELECT 'Total Number Of Customers Who Placed Order', COUNT(DISTINCT customer_key) FROM gold.fact_sales;