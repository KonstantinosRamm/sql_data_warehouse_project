/*
===============================================================================
Create Database,schemas and tables
===============================================================================
WARNING
    Running this script will drop the entire data_warehouse database if exists already.
    All the data will be deleted.Proceed with caution and ensure you have backups before 
    running this script
*/
DROP DATABASE IF EXISTS data_warehouse;
CREATE DATABASE data_warehouse;
DROP SCHEMA IF EXISTS bronze;
DROP SCHEMA IF EXISTS silver;
DROP SCHEMA IF EXISTS gold;


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
	cst_info_id BIGSERIAL PRIMARY KEY,
	cst_key VARCHAR(50),
	cst_firstname VARCHAR(50),
	cst_lastname VARCHAR(50),
	cst_marital_status VARCHAR(50),
	cst_gndr VARCHAR(50),
	cst_create_date DATE
);

CREATE TABLE IF NOT EXISTS bronze.crm_prd_info(
    crm_prd_id  BIGSERIAL PRIMARY KEY,
    prd_id BIGINT,
    prd_key VARCHAR(50),
    prd_name VARCHAR(100),
    prd_cost INTEGER,
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE
);

CREATE TABLE IF NOT EXISTS bronze.crm_sls_ord_num(
    sls_id BIGSERIAL PRIMARY KEY,
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


CREATE TABLE IF NOT EXISTS bronze.erp_cust(
    cust_id BIGSERIAL PRIMARY KEY,
    cid VARCHAR(50),
    bdate DATE,
    gen VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS bronze.erp_loc(
    cust_id BIGSERIAL PRIMARY KEY,
    cid VARCHAR(50),
    cntry VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS bronze.erp_px_cat(
    px_id BIGSERIAL PRIMARY KEY,
    ID VARCHAR(50),
    CAT VARCHAR(50),
    SUBCAT VARCHAR(50),
    MAINTENANCE VARCHAR(50)
);

/*
--------------
Bronze Layer
--------------
*/
CREATE TABLE IF NOT EXISTS silver.placeholder(

);

/*
--------------
Bronze Layer
--------------
*/
CREATE TABLE IF NOT EXISTS gold.placeholder(

);



--









