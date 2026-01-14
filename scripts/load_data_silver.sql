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




---===================================
--cleanse and Load silver.crm_prd_info
---===================================
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

---===================================
--cleanse and Load silver.crm_prd_info
---===================================
TRUNCATE silver.crm_sales_details;




INSERT INTO silver.crm_sales_details(
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
    --In bronze.crm_sales_details, date fields are stored as 
    --TEXT since the values do not follow a valid date format 
    --(e.g. 20201005 instead of 2020-10-05).
    --a transformation is required before applying 
    --an explicit CAST to a date type.
    --checks done for sls_order_dt,sls_ship_dt,sls_due_dt
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE 
        WHEN 
            sls_order_dt !~ '^\d{8}$' OR
            sls_order_dt::INT NOT BETWEEN 19000101 AND 20991231    
        THEN NULL
        ELSE TO_DATE(sls_order_dt, 'YYYYMMDD') 
    END AS sls_order_dt,

    CASE 
        WHEN
            sls_ship_dt !~ '^\d{8}$' OR
            sls_ship_dt::INT NOT BETWEEN 19000101 AND 20991231
        THEN NULL
        ELSE TO_DATE(sls_ship_dt, 'YYYYMMDD')
    END AS sls_ship_dt,
    
    CASE 
        WHEN
            sls_due_dt !~ '^\d{8}$' OR
            sls_due_dt::INT NOT BETWEEN 19000101 AND 20991231
        THEN NULL
        ELSE TO_DATE(sls_due_dt, 'YYYYMMDD')
    END AS sls_due_dt,
-- sls_sales is derived from business rules sls_sales = sls_quantity * sls_price; 
-- if sls_price is < 0 then we use the absolute sls_price 
-- other wise we use again the same formula as above
    CASE 
        WHEN 
            sls_sales IS NULL OR
            sls_sales <= 0 OR
            sls_sales != sls_quantity * ABS(sls_price) 
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,
    sls_quantity,

    CASE 
        WHEN 
            sls_price IS NULL
        THEN sls_sales / NULLIF(sls_quantity,0)
        WHEN 
            sls_price < 0
        THEN ABS(sls_price)
    ELSE sls_price
    
    END AS sls_price
FROM bronze.crm_sales_details;

---====================================
--cleanse and Load silver.erp_cust_az12
---====================================
TRUNCATE silver.erp_cust_az12;
INSERT INTO silver.erp_cust_az12(
    cid,
    bdate,
    gen
)
SELECT 
    -- Remove the 'NAS' prefix from cid so it matches cst_key in crm_cust_info
    -- Example: NASAW00013174 => AW00013174
    CASE 
        WHEN 
            cid LIKE 'NAS%'
        THEN SUBSTRING(cid,4)
    ELSE cid    
    END AS cid,
    -- Certain date values exceed the current date
    --Set those dates to NULL
    CASE 
        WHEN 
            bdate::DATE > CURRENT_DATE 
        THEN NULL
    ELSE bdate::DATE
    END AS bdate,
    CASE 
        WHEN 
            UPPER(TRIM(gen)) LIKE 'M' OR 
            UPPER(TRIM(gen)) LIKE 'MALE' 
        THEN 'MALE'
        WHEN 
            UPPER(TRIM(gen)) LIKE 'F' OR
            UPPER(TRIM(gen)) LIKE 'FEMALE'
        THEN 'FEMALE'
        ELSE 'N/A'
    END AS gen
FROM bronze.erp_cust_az12;