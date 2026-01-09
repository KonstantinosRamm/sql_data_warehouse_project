--Truncate data before table popularization (FULL LOAD)
TRUNCATE bronze.crm_cust_info;
TRUNCATE bronze.crm_prd_info;
TRUNCATE bronze.crm_sales_details;
TRUNCATE bronze.erp_cust_az1;
TRUNCATE bronze.erp_loc_a101;
TRUNCATE bronze.erp_px_cat_g1v2;
--Populate tables
\copy bronze.crm_cust_info FROM 'datasets/source_crm/cust_info.csv' CSV HEADER NULL '';
\copy bronze.crm_prd_info  FROM 'datasets/source_crm/prd_info.csv' CSV HEADER NULL '';
\copy bronze.crm_sales_details FROM 'datasets/source_crm/sales_details.csv' CSV HEADER NULL '';
\copy bronze.erp_cust_az1 FROM 'datasets/source_erp/CUST_AZ12.csv' CSV HEADER NULL '';
\copy bronze.erp_loc_a101 FROM 'datasets/source_erp/LOC_A101.csv' CSV HEADER NULL '';
\copy bronze.erp_px_cat_g1v2 FROM 'datasets/source_erp/PX_CAT_G1V2.csv' CSV HEADER NULL '';



