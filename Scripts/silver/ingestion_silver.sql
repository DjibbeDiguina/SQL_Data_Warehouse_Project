/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
			/***************************************** CRM TABLE *******************************************/
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/

USE MASTER;
USE DataWarehouse;

/**>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> SILVER CRM_CUST_INFO <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<**/
TRUNCATE TABLE silver.crm_cust_info;
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
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE UPPER(TRIM(cst_marital_status))
	WHEN 'M' THEN 'Married'
	WHEN 'S' THEN 'Single'
	ELSE 'n/a'
END as cst_marital_status,
CASE UPPER(TRIM(cst_gndr))
	WHEN 'M' THEN 'Male'
	WHEN 'F' THEN 'Female'
	ELSE 'n/a'
END AS cst_gndr,
cst_create_date
FROM
	(SELECT 
	*,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date desc) AS flag_last
	FROM bronze.crm_cust_info WHERE  cst_id IS NOT NULL)t
WHERE flag_last = 1;

select count(*) from silver.crm_cust_info;

/****************************************************************SILVER CRM PRD_INFO**********************************************************/

TRUNCATE TABLE silver.crm_prd_info;
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
REPLACE(SUBSTRING(prd_key, 1, 5), '-','_') as cat_id,
SUBSTRING(prd_key, 7, LEN(prd_key)) as prd_key,
TRIM(prd_nm) AS prd_nm,
COALESCE(ABS(prd_cost), 0) AS prd_cost,
CASE UPPER(TRIM(prd_line))
	WHEN 'M' THEN 'Mountain'
	WHEN 'R' THEN 'Road'
	WHEN 'S' THEN 'Other Sales'
	WHEN 'T' THEN 'Touring'
	ELSE 'n/a'
END AS prd_line,
prd_start_dt,
CAST(CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) AS DATETIME) - 1 AS DATE) AS prd_end_dt
FROM
	(select *, ROW_NUMBER() OVER(PARTITION BY prd_id order by prd_start_dt) as flag_last
	from bronze.crm_prd_info where prd_id is not null) t
WHERE flag_last = 1;

select count(*) from silver.crm_prd_info;

/***********************************************SILVER CRM SALES DETAILS *************************************************************************/
TRUNCATE TABLE silver.crm_sales_details;
INSERT INTO silver.crm_sales_details
(
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

SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE
	WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_order_dt AS NVARCHAR(10)) AS DATE)
END AS sls_order_dt,
CASE
	WHEN sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_ship_dt AS NVARCHAR(10)) AS DATE)
END AS sls_ship_dt,
CASE
	WHEN sls_due_dt <= 0 OR LEN(sls_due_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_due_dt AS NVARCHAR(10))AS DATE)
END AS sls_due_dt,
CASE
	WHEN sls_sales <= 0 OR sls_sales IS NULL THEN ABS(sls_quantity * sls_price)
	WHEN sls_sales != sls_quantity * sls_price THEN ABS(sls_quantity * sls_price)
	ELSE sls_sales
END as sls_sales,
sls_quantity,
CASE
	WHEN sls_price < 0 THEN ABS(sls_sales)
	WHEN sls_price IS NULL OR sls_price = 0 THEN ABS(sls_sales/NULLIF(sls_quantity, 0))
	ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details;

select count(*) from silver.crm_sales_details;


/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
			/***************************************** ERP TABLE *******************************************/
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/


/***************************************** silver.erp_CUST_AZ12 *******************************************/
TRUNCATE TABLE silver.erp_CUST_AZ12;
INSERT INTO silver.erp_CUST_AZ12(
	CID,
	BDATE,
	GEN
)
SELECT
CASE
	WHEN CID LIKE ('NAS%') THEN SUBSTRING(CID, 4, LEN(CID))
	ELSE CID
END AS CID,
CASE
	WHEN BDATE > GETDATE() THEN NULL
	ELSE BDATE
END AS BDATE,
CASE UPPER(TRIM(GEN))
	WHEN 'F' THEN 'Female'
	WHEN 'M' THEN 'Male'
	WHEN '' THEN NULL
	WHEN ' ' THEN NULL
	ELSE TRIM(GEN)
END AS GEN
FROM bronze.erp_CUST_AZ12;

select count(*) from silver.erp_CUST_AZ12;


/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> silver.erp_LOC_A101 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
TRUNCATE TABLE silver.erp_LOC_A101;
INSERT INTO silver.erp_LOC_A101(
	CID,
	CNTRY
)
SELECT 
CASE
	WHEN CID LIKE ('%-%') THEN REPLACE(TRIM(CID), '-', '')
	ELSE TRIM(CID)
END AS CID,
CASE 
	WHEN UPPER(TRIM(CNTRY)) IN ('US','USA') THEN 'United States'
	WHEN UPPER(TRIM(CNTRY)) = 'DE' THEN 'Germany'
	WHEN UPPER(TRIM(CNTRY)) IN ('', ' ') THEN NULL
	ELSE TRIM(CNTRY)
END AS CNTRY 
FROM bronze.erp_LOC_A101;

select count(*) from silver.erp_LOC_A101;
