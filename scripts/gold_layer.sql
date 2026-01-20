
--===========================
-- customer dimension  table
--===========================
CREATE OR REPLACE VIEW gold.dim_customers AS (
SELECT 
	ROW_NUMBER() OVER(ORDER BY c_i.cst_id) AS customer_key,
	c_i.cst_id AS customer_id,
	c_i.cst_key AS customer_number,
	c_i.cst_firstname AS firstname,
	c_i.cst_lastname AS lastname,
	c_i.cst_marital_status AS marital_status,
    -- Business Rule:
    -- 1. Prefer CRM gender value.
    -- 2. If CRM gender = 'N/A', fallback to ERP gender.
    -- 3. If ERP gender is NULL, keep 'N/A' as final value.
	CASE
   		WHEN c_i.cst_gndr IS NULL OR c_i.cst_gndr = 'N/A' THEN
        	CASE
            	WHEN c_b.gen IS NOT NULL THEN c_b.gen
            	ELSE 'N/A'
        	END
    	ELSE c_i.cst_gndr
	END AS gender,
	c_i.cst_create_date AS create_date,
	c_b.bdate AS birthday,
	c_l.cntry AS country
FROM silver.crm_cust_info c_i
LEFT JOIN silver.erp_cust_az12 c_b
ON c_i.cst_key = c_b.cid
LEFT JOIN silver.erp_loc_a101 c_l
ON c_i.cst_key =c_l.cid
);



--=========================
--products dimension table
--=========================
CREATE OR REPLACE VIEW gold.dim_products AS (
SELECT 
	ROW_NUMBER() OVER(ORDER BY s_d.prd_start_dt,s_d.prd_key) AS product_key,
	s_d.prd_id AS product_id,
	s_d.cat_id AS category_id,
	s_d.prd_key AS product_number,
	s_d.prd_line AS product_line,
	s_d.prd_nm AS product_name,
	p_c.cat AS category,
	p_c.subcat AS subcategory,
	p_c.maintenance AS maintenance,
	s_d.prd_cost AS product_cost,
	s_d.prd_start_dt AS start_date
FROM silver.crm_prd_info s_d
LEFT JOIN silver.erp_px_cat_g1v2 p_c
ON p_c.id = s_d.cat_id
--Filter all products by latest price
WHERE s_d.prd_end_dt IS NULL

);


--==================
--fact sales table
--==================
CREATE OR REPLACE VIEW gold.fact_sales AS (
SELECT
		--dimension keys
		s_d.sls_ord_num AS order_number,
		prod.product_key AS product_key,
		cust.customer_key AS customer_key,
		--dates
		s_d.sls_order_dt AS order_date,
		s_d.sls_ship_dt AS shipping_date,
		s_d.sls_due_dt AS due_date,
		--Sales
		s_d.sls_sales AS total_sales,
		s_d.sls_quantity AS quantity,
		s_d.sls_price AS unit_price
FROM silver.crm_sales_details s_d
LEFT JOIN gold.dim_products prod
ON s_d.sls_prd_key = prod.product_number
LEFT JOIN gold.dim_customers cust
ON s_d.sls_cust_id = cust.customer_id
);



