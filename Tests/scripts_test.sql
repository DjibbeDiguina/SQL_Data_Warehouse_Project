/*********************************************************************************************************/
	/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Testing Silver Table <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
/*********************************************************************************************************/

/**>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>silver.crm_cust_info<<<<<<<<<<<<**/
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


/**>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>silver.crm_prd_info<<<<<<<<<<<<<<<<<<<<<<<<<<<**/
--- Checking for Null And Duplicated Values
--- Expectation: No Values
SELECT prd_id, count(*) total_count FROM silver.crm_prd_info
group by prd_id
having count(*) != 1 or prd_id is null;

-- Checking for unwanted Space
-- expectation : no Values
select prd_nm from silver.crm_prd_info
where prd_nm != trim(prd_nm);

-- Checking for null or Negative Values In product cost
-- Expectation: no negative and no null
select prd_cost from silver.crm_prd_info
where prd_cost < 0 or prd_cost is null;

-- Checking for standarization and consistency
select distinct prd_line from silver.crm_prd_info;

-- Checking that prd_start > prd_end_dt
-- Expectation: No Values
select * from silver.crm_prd_info
where prd_start_dt >  prd_end_dt or prd_start_dt is null;
