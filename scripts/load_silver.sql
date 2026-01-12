--=====================================
--Cleanse and Load silver.crm_cust_info
--=====================================
-- Truncate the table for FULL LOAD
TRUNCATE silver.crm_cust_info;
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
FROM (
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
        cst_create_date::DATE AS cst_create_date,
        ROW_NUMBER() OVER (
            PARTITION BY cst_id ORDER BY cst_create_date::DATE DESC
        ) AS flag_last
    FROM bronze.crm_cust_info
) ranked
WHERE flag_last = 1;




---=======================
--cleanse
--Load silver.crm_prd_info
---=======================
TRUNCATE silver.crm_prd_info;
INSERT INTO silver.crm_prd_info( 
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT 
    prd_id,
    -- It appears that prd_key, when compared with the ERP table erp_px_g1v2,
    -- consists of two parts: the category ID and the product key.
    -- By default, they are combined into a single string (product ID + product key),
    -- so we need to separate them for easier joins and analysis.
    REPLACE(SUBSTR(prd_key,1,5),'-','_') AS cat_id,
    SUBSTRING(prd_key, 7) AS prd_key,
    prd_nm,
    --make sure to make negative or NUll values 0
    CASE WHEN prd_cost IS NULL OR prd_cost < 0 THEN 0
    ELSE prd_cost
    END AS prd_cost,
    CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
         WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
         WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
         WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Tour'
         ELSE 'N/A'
    END AS prd_line,
    -- Current dataset has inconsistencies that need cleansing.
    -- prd_start_dt / prd_end_dt define the product interval.
    -- prd_end_dt should not be before prd_start_dt and ideally should align with the next prd_start_dt. 
    prd_start_dt::DATE AS prd_start_dt,
    LEAD(prd_start_dt::DATE) OVER(PARTITION BY prd_key ORDER BY prd_id)-1 AS prd_end_dt
FROM bronze.crm_prd_info;

/*

*/

