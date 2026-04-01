-- Drop the view if it exists so we can recreate it cleanly
DROP VIEW IF EXISTS gold.dim_customers;

-- Create the Gold modeling view.
-- Standard SQL is used here so it works across platforms.
CREATE VIEW gold.dim_customers AS
SELECT 
    cst_id AS customer_id,
    cst_key AS customer_key,
    cst_firstname AS first_name,
    cst_lastname AS last_name,
    cst_marital_status AS marital_status,
    cst_gndr AS gender,
    cst_create_date AS account_created_date
FROM silver.crm_cust_info;
