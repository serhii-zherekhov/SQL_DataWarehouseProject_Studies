SELECT
	MIN(birth_date) AS oldest_customer_bd,
	DATEDIFF(YEAR, MIN(birth_date), GETDATE()) AS oldest_customer_age,
	MAX(birth_date) AS youngest_customer_bd,
	DATEDIFF(YEAR, MAX(birth_date), GETDATE()) AS youngest_customer_age
FROM gold.dim_customers