-- Drop the silver table if it exists to allow for a fresh load (Idempotent design)
DROP TABLE IF EXISTS silver.crm_cust_info;

-- Create the clean target table using standard SQL data types
CREATE TABLE silver.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE
);

-- Insert cleaned data directly from the Bronze layer
INSERT INTO silver.crm_cust_info (
    cst_id, cst_key, cst_firstname, cst_lastname, 
    cst_marital_status, cst_gndr, cst_create_date
)
SELECT
    cst_id,
    TRIM(cst_key), 
    TRIM(cst_firstname),
    TRIM(cst_lastname),
    -- Clean: Standardize marital status codes to full words
    CASE 
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        ELSE 'Unknown'
    END,
    -- Clean: Standardize gender codes
    CASE 
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        ELSE 'Unknown'
    END,
    cst_create_date
FROM bronze.crm_cust_info
-- Filter out bad data
WHERE cst_id IS NOT NULL;
