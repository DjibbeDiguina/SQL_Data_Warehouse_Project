/*=========================================================================
  SILVER LAYER TABLE CREATION
  -------------------------------------------------------------------------
  Purpose:
  Create Silver Layer tables in the Data Warehouse to store cleansed,
  standardized, and transformed CRM and ERP data.

  Process:
  1. Check if the target table already exists.
  2. Drop the existing table to ensure a fresh structure.
  3. Create the table with the required schema.
  4. Add dwh_update_date to track data load/update timestamps.

  Source Systems:
  - CRM: Customer, Product, and Sales data
  - ERP: Customer, Location, and Product Category data

  Layer: Silver
  Database: DataWarehouse
=========================================================================*/

USE MASTER;
USE DataWarehouse;

/**>>>>>>>>>>>>>>>>>>>>>>>SOURCE: CRM TABLE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<***/
IF OBJECT_ID ('silver.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(30),
	cst_firstname VARCHAR(30),
	cst_lastname VARCHAR(30),
	cst_marital_status VARCHAR(20),
	cst_gndr VARCHAR(20),
	cst_create_date DATE,
	dwh_update_date DATETIME DEFAULT GETDATE()
);

GO

/** CONDITION TO DROP EXISTING TABLE AND CREATE THE NEW ONE ***/
IF OBJECT_ID ('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info (
prd_id INT,
prd_key NVARCHAR(50),
prd_nm VARCHAR(50),
prd_cost INT,
prd_line VARCHAR(30),
prd_start_dt DATE,
prd_end_dt DATE,
dwh_update_date DATETIME DEFAULT GETDATE()
);

GO 

/** CONDITION TO DROP EXISTING TABLE AND CREATE THE NEW ONE ***/
IF OBJECT_ID ('silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;
	/** CREATING A TABLE 'silver.crm_sales_details' */
CREATE TABLE silver.crm_sales_details(
	sls_ord_num NVARCHAR(30),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt NVARCHAR(30),
	sls_ship_dt NVARCHAR(30),
	sls_due_dt NVARCHAR(30),
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_update_date DATETIME DEFAULT GETDATE()
);

GO

/**>>>>>>>>>>>>>>>>>>>>>>>SOURCE: ERP TABLE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<***/

	/********************* TABLE CREATION ********************************/
	/**CONDITION TO DELETE EXISTING TABLE**/
	IF OBJECT_ID('silver.erp_CUST_AZ12', 'U') IS NOT NULL
		DROP TABLE silver.erp_CUST_AZ12;
	/**creating new table called 'silver.erp_CUST_AZ12'**/
	CREATE TABLE silver.erp_CUST_AZ12(
		CID NVARCHAR(30),
		BDATE DATE,
		GEN VARCHAR(10),
		dwh_update_date DATETIME DEFAULT GETDATE()
	);

GO
	/**CONDITION TO DELETE EXISTING TABLE**/
	IF OBJECT_ID('silver.erp_LOC_A101', 'U') IS NOT NULL
		DROP TABLE silver.erp_LOC_A101;
	/**creating new table called 'silver.erp_LOC_A101'**/
	CREATE TABLE silver.erp_LOC_A101(
		CID NVARCHAR(50),
		CNTRY VARCHAR(30),
		dwh_update_date DATETIME DEFAULT GETDATE()
	);

GO

	/**CONDITION TO DELETE EXISTING TABLE**/
	IF OBJECT_ID('silver.erp_PX_CAT_G1V2', 'U') IS NOT NULL
		DROP TABLE silver.erp_PX_CAT_G1V2;
	/**creating new table called 'silver.PX_CAT_G1V2'**/
	CREATE TABLE silver.erp_PX_CAT_G1V2(
		ID NVARCHAR(30),
		CAT NVARCHAR(30),
		SUBCAT NVARCHAR(30),
		MAINTENANCE NVARCHAR(30),
		dwh_update_date DATETIME DEFAULT GETDATE()
	);
