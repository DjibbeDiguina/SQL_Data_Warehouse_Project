use master;
use DataWarehouse;
IF OBJECT_ID ('gold.dim_customer', 'V') IS NOT NULL
	DROP VIEW gold.dim_customer;
GO
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
			WHEN ci.cst_gndr IS NULL OR ci.cst_gndr = 'n/a' THEN coalesce(ca.GEN, 'n/a')
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

GO

CREATE OR ALTER VIEW gold.dim_product AS
	SELECT
		ROW_NUMBER() OVER (ORDER BY p.prd_id, p.prd_start_dt) AS product_key,
		p.prd_id as product_id,
		p.cat_id as category_id,
		p.prd_key as product_number, 
		p.prd_nm as product_name,
		pd.CAT as categories,
		pd.SUBCAT as sub_categories,
		p.prd_cost as product_cost,
		p.prd_line as product_line,
		pd.MAINTENANCE as maintenance,
		p.prd_start_dt as start_date
	FROM silver.crm_prd_info p
	LEFT JOIN silver.erp_PX_CAT_G1V2 pd
	ON			p.cat_id = pd.ID
	WHERE p.prd_end_dt IS NULL
;

GO

CREATE OR ALTER VIEW gold.fact_sales AS
	SELECT
		s.sls_ord_num AS order_number,
		p.product_key,
		c.customer_key,
		s.sls_order_dt as order_date,
		s.sls_ship_dt as shipping_date,
		s.sls_due_dt as due_date,
		s.sls_sales as sales_amount,
		s.sls_quantity as quantity,
		s.sls_price as price
	FROM silver.crm_sales_details s
	LEFT JOIN gold.dim_product p
	ON			s.sls_prd_key = p.product_number
	LEFT JOIN gold.dim_customer c
	ON			s.sls_cust_id = c.customer_id
;
