/*
===============================================================================
    STORED PROCEDURE: bronze.load_bronze
===============================================================================

    PURPOSE:
    --------
    This stored procedure performs the full data ingestion process for the
    BRONZE layer of the Data Warehouse.

    It loads raw data from CRM and ERP source CSV files into staging tables
    without applying transformations (raw ingestion layer).

    SOURCES:
    --------
    - CRM: Sales transaction data
    - ERP: Customer, location, and product category data

    PROCESS OVERVIEW:
    ------------------
    1. Drops existing bronze tables if they exist
    2. Recreates fresh tables for each dataset
    3. Loads raw CSV data using BULK INSERT
    4. Ensures repeatable and clean ingestion process

    TABLES LOADED:
    --------------
    CRM:
      - bronze.crm_sales_details

    ERP:
      - bronze.erp_CUST_AZ12
      - bronze.erp_LOC_A101
      - bronze.erp_PX_CAT_G1V2

    IMPORTANT NOTES:
    ----------------
    - This is a RAW DATA LAYER (no transformations applied)
    - Designed for full reload (not incremental load)
    - Files must exist at specified local paths before execution
    - Intended for development / learning / ETL pipeline simulation

    WARNING:
    --------
    Running this procedure will DELETE and RELOAD all BRONZE tables.
    Do not run in production environments.

    AUTHOR:
    -------
    Djibe Christian Diguina

===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
	BEGIN
	/**>>>>>>>>>>>>>>>>>>>>>>>SOURCE: CRM TABLE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<***/

	/** CONDITION TO DROP EXISTING TABLE AND CREATE THE NEW ONE ***/
	IF OBJECT_ID ('bronze.crm_sales_details', 'U') IS NOT NULL
		DROP TABLE bronze.crm_sales_details;
	/** CREATING A TABLE 'bronze.crm_sales_details' */
	CREATE TABLE bronze.crm_sales_details(
	sls_ord_num NVARCHAR(30),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt NVARCHAR(30),
	sls_ship_dt NVARCHAR(30),
	sls_due_dt NVARCHAR(30),
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
	);

	
	/** DELETE ALL EXISTING ROW ***/
	TRUNCATE TABLE bronze.crm_sales_details;
	/**LOADING DATA INSIDE TABLE 'bronze.crm_sales_details' USING BULK FOR FULL LOADING***/
	BULK INSERT bronze.crm_sales_details FROM 'C:\Users\Diguina-Fils\Documents\DataProject_Warehouse\datasets\source_crm\sales_details.csv'
	WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);



	/**>>>>>>>>>>>>>>>>>>>>>>>SOURCE: ERP TABLE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<***/

	/********************* TABLE CREATION ********************************/
	/**CONDITION TO DELETE EXISTING TABLE**/
	IF OBJECT_ID('bronze.erp_CUST_AZ12', 'U') IS NOT NULL
		DROP TABLE bronze.erp_CUST_AZ12;
	/**creating new table called 'bronze.erp_CUST_AZ12'**/
	CREATE TABLE bronze.erp_CUST_AZ12(
		CID NVARCHAR(30),
		BDATE DATE,
		GEN VARCHAR(10)
	);


	/**CONDITION TO DELETE EXISTING TABLE**/
	IF OBJECT_ID('bronze.erp_LOC_A101', 'U') IS NOT NULL
		DROP TABLE bronze.erp_LOC_A101;
	/**creating new table called 'bronze.erp_LOC_A101'**/
	CREATE TABLE bronze.erp_LOC_A101(
		CID NVARCHAR(50),
		CNTRY VARCHAR(30)
	);


	/**CONDITION TO DELETE EXISTING TABLE**/
	IF OBJECT_ID('bronze.erp_PX_CAT_G1V2', 'U') IS NOT NULL
		DROP TABLE bronze.erp_PX_CAT_G1V2;
	/**creating new table called 'bronze.PX_CAT_G1V2'**/
	CREATE TABLE bronze.erp_PX_CAT_G1V2(
		ID NVARCHAR(30),
		CAT NVARCHAR(30),
		SUBCAT NVARCHAR(30),
		MAINTENANCE NVARCHAR(30)
	);


	/*********************BULK LOAD ********************************/
	/***deleting al existing row ****/
	TRUNCATE TABLE bronze.erp_CUST_AZ12;
	/***Inserting new row >>>>>>>>>>>> ****/
	BULK INSERT bronze.erp_CUST_AZ12
	FROM 'C:\Users\Diguina-Fils\Documents\DataProject_Warehouse\datasets\source_erp\CUST_AZ12.csv'
	WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);


	/***deleting al existing row ****/
	TRUNCATE TABLE bronze.erp_LOC_A101;
	/***Inserting new row >>>>>>>>>>>> ****/
	BULK INSERT bronze.erp_LOC_A101
	FROM 'C:\Users\Diguina-Fils\Documents\DataProject_Warehouse\datasets\source_erp\LOC_A101.csv'
	WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);


	/***deleting al existing row ****/
	TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;
	/***Inserting new row >>>>>>>>>>>> ****/
	BULK INSERT bronze.erp_PX_CAT_G1V2
	FROM 'C:\Users\Diguina-Fils\Documents\DataProject_Warehouse\datasets\source_erp\PX_CAT_G1V2.csv'
	WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
END;
