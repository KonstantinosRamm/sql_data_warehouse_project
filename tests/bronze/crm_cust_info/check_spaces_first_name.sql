--Check for spaces in first name
--Expectation : No result
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname LIKE '% %';