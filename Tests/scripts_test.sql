/**>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>silver.crm_cust_info<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<**/
-- Checking Null Values and Duplicated
-- Expectation: No Values
SELECT cst_id, count(*) as total_count FROM silver.crm_cust_info
group by cst_id
having count(*) != 1 or cst_id is null;

-- Checking for Unwanted Space in categorical column
-- Expectation: No values
SELECT cst_lastname FROM silver.crm_cust_info
where cst_lastname != trim(cst_lastname);

-- Data Quality Check: Standardization & Consistency
-- Expected Outcome: No abbreviated or inconsistent values present
SELECT DISTINCT cst_gndr FROM silver.crm_cust_info;
