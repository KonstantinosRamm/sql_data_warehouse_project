--Trucnate the table for FULL LOAD
TRUNCATE silver.crm_cust_info;
--==================================
--CTE here is used mostly because
--the cst_id col contains duplicates
--==================================
WITH cust_ranked_id AS (
    SELECT
        cst_id,
        TRIM(cst_key) AS cst_key,
        TRIM(cst_firstname) AS cst_firstname,
        TRIM(cst_lastname) AS cst_lastname,
        CASE 
            WHEN cst_gndr = 'M' THEN 'MALE'
            WHEN cst_gndr = 'F' THEN 'FEMALE'
            ELSE 'N/A' 
        END AS cst_gndr,
        CASE
            WHEN cst_marital_status = 'S' THEN 'SINGLE'
            WHEN cst_marital_status = 'M' THEN 'MARRIED'
            ELSE 'N/A'
        END AS cst_marital_status,
        cst_create_date,
        ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
    FROM bronze.crm_cust_info
)


--=================
--MAIN QUERY
--=================
INSERT INTO silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
)
SELECT 
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
FROM cust_ranked_id
WHERE flag_last = 1;



