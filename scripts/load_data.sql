CREATE OR REPLACE PROCEDURE bronze.load_data()
LANGUAGE plpgsql
AS $$
DECLARE 
    --Get time stamps to measure load time of data for debugging
    time_begin TIMESTAMP;
    time_end TIMESTAMP;
BEGIN
    BEGIN 
        time_begin := clock_timestamp();
        --Truncate and full load data
        RAISE NOTICE '====================';
        RAISE NOTICE 'Loading Bronze Layer';
        RAISE NOTICE '====================';
        
        RAISE NOTICE '------------------';
        RAISE NOTICE 'Loading crm tables';
        RAISE NOTICE '------------------';

        RAISE NOTICE '>>>Truncating table:crm_cust_info';

        TRUNCATE bronze.crm_cust_info;
        RAISE NOTICE '>>>Inserting data in table:crm_cust_info';
        EXECUTE 'COPY bronze.crm_cust_info 
                FROM ''/var/lib/postgresql/datasets/source_crm/cust_info.csv'' 
                CSV HEADER NULL '''';';

        RAISE NOTICE '>>>Truncating table:crm_prd_info';

        TRUNCATE bronze.crm_prd_info;
        RAISE NOTICE '>>>Inserting data in table:crm_prd_info ';
        EXECUTE 'COPY bronze.crm_prd_info 
                FROM ''/var/lib/postgresql/datasets/source_crm/prd_info.csv'' 
                CSV HEADER NULL '''';';

        RAISE NOTICE '>>>Truncating table:crm_sales_details';

        TRUNCATE bronze.crm_sales_details;
        RAISE NOTICE '>>>Inserting data in table:crm_sales_details';
        EXECUTE 'COPY bronze.crm_sales_details 
                FROM ''/var/lib/postgresql/datasets/source_crm/sales_details.csv'' 
                CSV HEADER NULL '''';';


        RAISE NOTICE '------------------';
        RAISE NOTICE 'Loading erp tables';
        RAISE NOTICE '------------------';

        RAISE NOTICE '>>>Truncating table:erp_cust_az12';

        TRUNCATE bronze.erp_cust_az12;
        RAISE NOTICE '>>>Inserting data in table:erp_cust_az12';
        EXECUTE 'COPY bronze.erp_cust_az12
                FROM ''/var/lib/postgresql/datasets/source_erp/CUST_AZ12.csv'' 
                CSV HEADER NULL '''';';

        RAISE NOTICE '>>>Truncating table:erp_loc_a101';

        TRUNCATE bronze.erp_loc_a101;
        RAISE NOTICE '>>>Inserting data in table:erp_loc_a101';
        EXECUTE 'COPY bronze.erp_loc_a101 
                FROM ''/var/lib/postgresql/datasets/source_erp/LOC_A101.csv'' 
                CSV HEADER NULL '''';';


        RAISE NOTICE '>>>Truncating table:erp_px_cat_g1v2';

        TRUNCATE bronze.erp_px_cat_g1v2;
        RAISE NOTICE '>>>Inserting data in table:erp_px_cat_g1v2';
        EXECUTE 'COPY bronze.erp_px_cat_g1v2 
                FROM ''/var/lib/postgresql/datasets/source_erp/PX_CAT_G1V2.csv'' 
                CSV HEADER NULL '''';';
        RAISE NOTICE '===================';
        RAISE NOTICE 'Bronze Layer Loaded';
        RAISE NOTICE '===================';
        time_end := clock_timestamp();

        RAISE NOTICE '****************************************************';
        RAISE NOTICE 'Load started at:  %',time_begin;
        RAISE NOTICE 'Load ended at:    %',time_end;
        RAISE NOTICE 'Total time:       % seconds',EXTRACT(EPOCH FROM (time_end-time_begin));
        RAISE NOTICE '****************************************************';


    EXCEPTION
        WHEN OTHERS THEN
        RAISE EXCEPTION 'Error Occured: % ', SQLERRM;
    END;
END;
$$;


