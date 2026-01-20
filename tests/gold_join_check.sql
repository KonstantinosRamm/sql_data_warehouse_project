--Check the link between fact_sales and dim_customers with customer_key
--Expectation:No result
SELECT * FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_key = dc.customer_key 
--Only dc.customer_key needs to be checked since a non-match on the left join will result in a NULL dc.customer_key
WHERE dc.customer_key IS NULL;

--Check the link between fact_sales and dim_products with product key
--Expectation: No result
SELECT * FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key
--Only dp.product_key needs to be checked since a non-match on the left join will result in a NULL dp.product_key
WHERE dp.product_key IS NULL;


--check the link between all dim tables and fact sales 
--Expectation: No result
SELECT * FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key
LEFT JOIN gold.dim_customers dc
ON dc.customer_key = fs.customer_key
WHERE dp.product_key IS NULL
OR dc.customer_key IS NULL;