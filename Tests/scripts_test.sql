/*********************************************************************************************************/
	/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Testing Silver Table <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
/*********************************************************************************************************/
USE MASTER;
USE DataWarehouse;
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

/**>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>silver.crm_sales_details<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<**/

-- Checking for unwanted space
-- Expectation: No Values
SELECT sls_ord_num FROM silver.crm_sales_details
where sls_ord_num != trim(sls_ord_num);

-- Checking if foreign Key are working perfectly
-- Expectation: No Values
SELECT * FROM silver.crm_sales_details
where sls_cust_id not in (select cst_id from silver.crm_cust_info)
/*select prd_key from silver.crm_prd_info*/;

-- Checking The Date Invaladity
--Expectation: No Values
SELECT sls_order_dt FROM bronze.crm_sales_details
WHERE 
	sls_order_dt <= 0
	or len(sls_order_dt) != 8 
	or sls_order_dt = 205004955
;

SELECT sls_ship_dt FROM bronze.crm_sales_details
WHERE 
	sls_ship_dt = 0 or
	LEN(sls_ship_dt) != 8
;

SELECT sls_due_dt FROM bronze.crm_sales_details
WHERE 
	sls_due_dt = 0 or
	LEN(sls_due_dt) != 8
;

--Checking Date Rule for business
--Expectation: No values
select * from (
SELECT CASE
	WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_order_dt AS NVARCHAR(10)) AS DATE)
END AS sls_order_dt,
CASE
	WHEN sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_ship_dt AS NVARCHAR(10)) AS DATE)
END AS sls_ship_dt FROM bronze.crm_sales_details)t where sls_order_dt > sls_ship_dt;

-- Checking Business Rule
-- Expectation: No Values
SELECT sls_sales, sls_quantity, sls_price FROM silver.crm_sales_details
WHERE
	sls_sales <= 0 or
	sls_sales is null or
	sls_sales != sls_quantity * sls_price
;

SELECT sls_sales, sls_quantity, sls_price FROM silver.crm_sales_details
WHERE
	sls_quantity <= 0 or
	sls_quantity is null
;

SELECT sls_sales, sls_quantity, sls_price
FROM silver.crm_sales_details
WHERE
	sls_price <= 0 or
	sls_price is null
;


/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> silver.erp_CUST_AZ12 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/

--Checking for valide connection or relatioship between to table
--Expectation: No Values
SELECT
CID
FROM silver.erp_CUST_AZ12 WHERE
CID NOT IN (
select cst_key from silver.crm_cust_info);

-- Checking BDATE outlier 
--Expectation : No Values
SELECT  BDATE FROM silver.erp_CUST_AZ12 where BDATE > GETDATE();

-- Checking Consistency and Standarization
-- Expectation: FULL VALUES Values
SELECT DISTINCT GEN FROM silver.erp_CUST_AZ12;


SELECT* FROM silver.erp_CUST_AZ12;


/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> silver.erp_LOC_A101 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/

-- Checking unwanted Space 
--Expectatio : No Values
SELECT CID FROM silver.erp_LOC_A101 WHERE CID != TRIM(CID);

-- Checking for relationship ID format 
-- Expectation: No Values
SELECT 
CID FROM silver.erp_LOC_A101 where CID NOT IN (
select CID from silver.erp_CUST_AZ12);

--Checking for consistency and standarization
--Expectation: Consistence
SELECT DISTINCT CNTRY FROM silver.erp_LOC_A101;

SELECT * FROM silver.erp_LOC_A101;


/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> silver.erp_PX_CAT_G1V2 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/

--Checking For Id relationship
--Expectation: no Values
SELECT ID FROM silver.erp_PX_CAT_G1V2 WHERE ID NOT IN
(select cat_id from silver.crm_prd_info);

-- Checking for unwanted Space
-- Expectation: No Values
SELECT  CAT FROM silver.erp_PX_CAT_G1V2 WHERE CAT !=TRIM(CAT);

-- Checking for unwanted Space
-- Expectation: No Values
SELECT  SUBCAT FROM silver.erp_PX_CAT_G1V2 WHERE SUBCAT !=TRIM(SUBCAT);

-- Checking for consistency
SELECT DISTINCT MAINTENANCE FROM silver.erp_PX_CAT_G1V2;


SELECT * FROM silver.erp_PX_CAT_G1V2
