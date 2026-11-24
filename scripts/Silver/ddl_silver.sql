/*
====================================================
Author: Saurabh Singh
====================================================
Description:    
silver Layer - Create Tables
====================================================
*/
IF OBJECT_ID('silver.crm_cust_info') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
create Table silver.crm_cust_info(
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(100),
    cst_lastname VARCHAR(100),
    cst_marital_status VARCHAR(20),
    cst_gndr VARCHAR(10),
    cst_create_date DATE,
    dwh_create_date DATETIME2 default GETDATE()
);
GO
IF OBJECT_ID('silver.crm_prd_info') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
CREATE Table silver.crm_prd_info(
    prid_id INT,
    prid_key VARCHAR(50),
    cat_id   VARCHAR(50),
    prd_nm VARCHAR(100),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE,
    dwh_create_date DATETIME2 default GETDATE()

)
GO
IF OBJECT_ID('silver.crm_sales_details') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
Create Table silver.crm_sales_details(
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt Date,
    sls_ship_dt Date,
    sls_due_dt Date,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT,
    dwh_create_date DATETIME2 default GETDATE()

)
GO
IF OBJECT_ID('silver.erp_cust_az12') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
Create Table silver.erp_cust_az12(
    CID varchar(50),
    BDATE DATE,
    GEN VARCHAR(50),
    dwh_create_date DATETIME2 default GETDATE()
)
GO
IF OBJECT_ID('silver.erp_cust_az12') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
CREATE TABLE silver.erp_loc_a101(
    CID varchar(50),
    CNTRY varchar(100),
    dwh_create_date DATETIME2 default GETDATE()
)
GO
IF OBJECT_ID('silver.erp_px_cat_g1v2') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
Create TABLE silver.erp_px_cat_g1v2(
    ID varchar(50),
    CAT varchar(100),
    SUBCAT varchar(100),
    MAINTENANCE varchar(100),
    dwh_create_date DATETIME2 default GETDATE()
)
