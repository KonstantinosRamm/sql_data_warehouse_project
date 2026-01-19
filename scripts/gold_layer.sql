

-- customer dimension  table
CREATE OR REPLACE VIEW gold.customer_dimension AS (
SELECT 
	c_i.cst_id AS customer_id,
	c_i.cst_key AS customer_key,
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


CREATE OR REPLACE VIEW gold.product_dimension AS (
--products dimension table
SELECT 
	s_d.prd_id AS product_id,
	s_d.cat_id AS category_id,
	s_d.prd_key AS product_key,
	s_d.prd_nm AS product_number,
	s_d.prd_cost AS product_cost,
	s_d.prd_line AS product_line,
	s_d.prd_start_dt AS start_date,
	s_d.prd_end_dt AS end_date,
	p_c.cat AS category,
	p_c.subcat AS subcategory,
	p_c.maintenance AS maintenance
FROM silver.crm_prd_info s_d
LEFT JOIN silver.erp_px_cat_g1v2 p_c
ON p_c.id = s_d.cat_id
);



