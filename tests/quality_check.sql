--==========================================================
--              CRM TABLES
--==========================================================



--==============
--crm_cust_info
--==============

--duplicates cst_id 
--Ecpectation : No result
SELECT COUNT(*),cst_id
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;


--cst_firstname containing spaces or null values
--Expectation : No result
SELECT DISTINCT cst_firstname
FROM bronze.crm_cust_info 
WHERE  cst_firstname != TRIM(cst_firstname) OR cst_firstname IS NULL;

--cst_lastname containing spaces or null values
--Expectation:no result
SELECT DISTINCT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname) OR cst_lastname IS NULL;

--cst_gndr check
--Expecation: 'F','M',NULL
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info;


--cst_marital_status check
--Expectation: 'S','M',NULL
SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info;




--==============
--crm_prd_info
--==============


--check prd_key connection with erp tables through joins
--Expectation : Multiple rows with joins between crm_prd_info and erp_px_cat_g1v2
SELECT * FROM silver.crm_prd_info pi
INNER JOIN silver.erp_px_cat_g1v2 pc
ON pi.cat_id = pc.ID;


--check prd_cost for negative or null values
--Expectation: No result
SELECT prd_cost FROM bronze.crm_prd_info 
WHERE prd_cost < 0 OR prd_cost IS NULL;


--check prd_line 
--Expectation: 'M','R','S','T',NULL
SELECT DISTINCT prd_line FROM bronze.crm_prd_info;


--check prd_start_dt > prd_end_dt
--Expectation : No result
SELECT prd_start_dt,prd_end_dt FROM bronze.crm_prd_info
WHERE prd_start_dt > prd_end_dt; 



--=================
--crm_sales_details
--=================


--check sls_order_dt for invalid date format
--Expectation : No result
SELECT sls_order_dt FROM bronze.crm_sales_details
WHERE sls_order_dt !~ '^\d{8}$' OR 
sls_order_dt::INT NOT BETWEEN 19000101 AND 20991231;


--check sls_ship_dt for invalid date format
--Expectation: No result
SELECT sls_ship_dt FROM bronze.crm_sales_details
WHERE sls_ship_dt !~ '^\d{8}$' OR 
sls_ship_dt::INT NOT BETWEEN 19000101 AND 20991231;

--check for sls_sale_dt > sls_ship_dt
--Expectation: No result
SELECT sls_order_dt,sls_ship_dt 
FROM bronze.crm_sales_details 
WHERE sls_order_dt::INT > sls_ship_dt::INT;

--check sls_due_dt for invalid date format or sls_due_dt 
--Expectation: No result
SELECT sls_due_dt 
FROM bronze.crm_sales_details 
WHERE   sls_due_dt !~ '^\d{8}$' OR
        sls_due_dt::INT NOT BETWEEN 19000101 AND 20991231;

--check for sls_due_dt > sls_order_dt
--Expectation: No result
SELECT sls_due_dt,sls_order_dt
FROM bronze.crm_sales_details 
WHERE sls_due_dt::INT < sls_order_dt::INT;

--check for negative or null sls_price
--Expectation : No result
SELECT sls_price FROM bronze.crm_sales_details 
WHERE sls_price IS NULL or sls_price < 0;


--check for negative or null sls_sales
--Expectation : No result
SELECT sls_sales FROM bronze.crm_sales_details 
WHERE sls_sales IS NULL OR sls_sales < 0;


--check for negative or negative sls_quantity
--Expectation: No result
SELECT sls_quantity FROM bronze.crm_sales_details 
WHERE sls_quantity IS NULL OR sls_quantity < 0;


--check for data consistency between sls_sales,sls_price,sls_quantity
--According to business rule : sls_sales = sls_price*sls_quantity
--expectation: No result
SELECT sls_sales,sls_price,sls_quantity 
FROM bronze.crm_sales_details 
WHERE sls_sales != sls_price * sls_quantity;



--==========================================================
--                      ERP TABLES
--==========================================================

--==============
--erpcust_az12
--==============

-- CHECK for duplicates 
--Expectation : No result 
SELECT cid, COUNT(*) AS cnt
FROM bronze.erp_cust_az12
GROUP BY cid
HAVING COUNT(*) > 1;

--CHECK for NULL cid
SELECT cid
FROM bronze.erp_cust_az12
WHERE cid IS NULL;


--Check connection between crm_cust_info and erp_cust_az12
--By formatting cid 
--Expectation : Multiple Joinner Rows between the 2 tables
SELECT *
FROM bronze.erp_cust_az12 AS az
INNER JOIN bronze.crm_cust_info AS ci
ON ci.cst_key = SUBSTRING(az.cid,4);


--Check the format of bdate
--Epectation : No result
SELECT bdate FROM bronze.erp_cust_az12
WHERE bdate !~ '^\d{4}-\d{2}-\d{2}$';

--Check bdate to not exceed current date
--Expectation : No result
SELECT bdate FROM bronze.erp_cust_az12
WHERE bdate::DATE > CURRENT_DATE;

--Check gender
--Expectation : 'M','F','Male','Female',NULL
SELECT DISTINCT gen FROM bronze.erp_cust_az12;


--==================
--erp_loc_a101
--==================
--check connection between crm_cust_info and erp_loc_a101
--Expectation: Multiple joined rows of tables crm_cust_info and erp_loc_a101
SELECT * FROM bronze.crm_cust_info ci
INNER JOIN bronze.erp_loc_a101 l
ON ci.cst_key = l.cid;

--check connection between crm_cust_info and erp_loc_a101 after cid substitution
--Expectation: Multiple joined rows of tables crm_cust_info and erp_loc_a101
SELECT * FROM bronze.crm_cust_info ci
INNER JOIN bronze.erp_loc_a101 l
ON ci.cst_key = REPLACE(l.cid,'-','');

--check cntry for containing country codes instead of country name
--Expectation: No result
SELECT DISTINCT cntry 
FROM bronze.erp_loc_a101 
WHERE LENGTH(TRIM(cntry)) = 2;

--=================
--erp_px_cat_g1v2
--=================

--check connection between crm_prd_info and erp_px_cat_g1v2


--Check id format to follow pattern CC_CC e.g. AB_CD and connection of 
--erp_px_cat_g1v2 and crm_prd_info after  id substitution
--Expectation: Multiple joined Rows between erp_px_cat_g1v and crm_prd_info
SELECT * FROM bronze.erp_px_cat_g1v2 px
INNER JOIN bronze.crm_prd_info pi
ON px.id = SUBSTRING(REPLACE(pi.prd_key,'-','_'),1,5);


--Check cat 
--Expectation: 'Bikes','Accessories','Clothing','Components',NULL
SELECT DISTINCT cat FROM bronze.erp_px_cat_g1v2;


--Check subcat
--Expectation: Subcategories LIKE : 'Cleaners','Socks','Vests','Helmets',NULL...
SELECT DISTINCT subcat FROM bronze.erp_px_cat_g1v2;

--Check maintenance
--Expectation: 'Yes','No'
SELECT DISTINCT maintenance FROM bronze.erp_cat_g1v2;












