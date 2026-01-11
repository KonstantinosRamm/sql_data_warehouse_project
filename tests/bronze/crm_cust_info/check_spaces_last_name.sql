--Check for spaces in last name
--expectation : No result
SELECT cst_lastname 
FROM bronze.crm_cust_info
WHERE cst_lastname LIKE '% %';