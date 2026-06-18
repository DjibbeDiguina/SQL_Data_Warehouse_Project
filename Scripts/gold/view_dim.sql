CREATE VIEW gold.dim_customer AS
	SELECT
	ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	lo.CNTRY AS country,
	ci.cst_marital_status AS marital_status,
	CASE
		WHEN ci.cst_gndr in ('n/a', NULL) THEN coalesce(ca.GEN, 'n/a')
		ELSE ci.cst_gndr
	END AS gender,
	ca.BDATE AS birthdate,
	ci.cst_create_date AS create_date
	FROM silver.crm_cust_info ci
	LEFT JOIN  silver.erp_CUST_AZ12 ca
	ON			ci.cst_key = ca.CID
	LEFT JOIN silver.erp_LOC_A101 lo
	ON			ci.cst_key = lo.CID
;
