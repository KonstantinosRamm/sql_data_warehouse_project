




/*
===============================================================================
Create Database,schemas and tables
===============================================================================
WARNING
    Running this script will drop the entire data_warehouse database if exists already.
    All the data will be deleted.Proceed with caution and ensure you have backups before 
    running this script
*/
DROP SCHEMA IF EXISTS bronze CASCADE;
DROP SCHEMA IF EXISTS silver CASCADE;
DROP SCHEMA IF EXISTS gold CASCADE;


---Create Schemas
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;

/*
==================================================
Create Tables
==================================================
--------------
Bronze Layer
--------------
*/
CREATE TABLE IF NOT EXISTS bronze.crm_cust_info(
    cst_id INTEGER ,
	cst_key VARCHAR(50),
	cst_firstname VARCHAR(50),
	cst_lastname VARCHAR(50),
	cst_marital_status VARCHAR(50),
	cst_gndr VARCHAR(50),
	cst_create_date TEXT
);

CREATE TABLE IF NOT EXISTS bronze.crm_prd_info(
    prd_id INTEGER,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(100),
    prd_cost INTEGER,
    prd_line VARCHAR(50),
    prd_start_dt TEXT,-- intentionally TEXT to handle messy raw dates
    prd_end_dt TEXT -- intentionally TEXT to handle messy raw dates
);

CREATE TABLE IF NOT EXISTS bronze.crm_sales_details(
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INTEGER,
    sls_order_dt TEXT, -- intentionally TEXT to handle messy raw dates
    sls_ship_dt TEXT, -- intentionally TEXT to handle messy raw dates
    sls_due_dt TEXT, -- intentionally TEXT to handle messy raw dates
    sls_sales INTEGER,
    sls_quantity INTEGER,
    sls_price INTEGER
);


CREATE TABLE IF NOT EXISTS bronze.erp_cust_az12(
    cid VARCHAR(50),
    bdate TEXT, -- intentionally TEXT to handle messy raw dates
    gen VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS bronze.erp_loc_a101(
    cid VARCHAR(50),
    cntry VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS bronze.erp_px_cat_g1v2(
    ID VARCHAR(50),
    CAT VARCHAR(50),
    SUBCAT VARCHAR(50),
    MAINTENANCE VARCHAR(50)
);
/*
=======================================
Silver Layer
=======================================
*/
CREATE TABLE IF NOT EXISTS silver.crm_cust_info(
    cst_id INTEGER ,
	cst_key VARCHAR(50),
	cst_firstname VARCHAR(50),
	cst_lastname VARCHAR(50),
	cst_marital_status VARCHAR(50),
	cst_gndr VARCHAR(50),
	cst_create_date DATE
);

CREATE TABLE IF NOT EXISTS silver.crm_prd_info(
    prd_id INTEGER,
    cat_id VARCHAR(50),
    prd_key VARCHAR(50),
    prd_nm VARCHAR(100),
    prd_cost INTEGER,
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE
);

CREATE TABLE IF NOT EXISTS silver.crm_sales_details(
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INTEGER,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales INTEGER,
    sls_quantity INTEGER,
    sls_price INTEGER
);


CREATE TABLE IF NOT EXISTS silver.erp_cust_az12(
    cid VARCHAR(50),
    bdate DAtE, 
    gen VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS silver.erp_loc_a101(
    cid VARCHAR(50),
    cntry VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS silver.erp_px_cat_g1v2(
    ID VARCHAR(50),
    CAT VARCHAR(50),
    SUBCAT VARCHAR(50),
    MAINTENANCE VARCHAR(50)
);





