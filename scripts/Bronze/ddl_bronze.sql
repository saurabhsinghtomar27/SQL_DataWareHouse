/*
====================================================
Author: Saurabh Singh
====================================================
Description:    
Bronze Layer - Create Tables
====================================================
*/
IF OBJECT_ID('bronze.crm_cust_info') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
create Table bronze.crm_cust_info(
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(100),
    cst_lastname VARCHAR(100),
    cst_marital_status VARCHAR(20),
    cst_gndr VARCHAR(10),
    cst_create_date DATE
);
GO
IF OBJECT_ID('bronze.crm_prd_info') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
CREATE Table bronze.crm_prd_info(
    prid_id INT,
    prid_key VARCHAR(50),
    prd_nm VARCHAR(100),
    prd_cost DECIMAL(10,2),
    prd_line VARCHAR(100),
    prd_start_dt DATE,
    prd_end_dt DATE
)
GO
IF OBJECT_ID('bronze.crm_sales_details') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
Create Table bronze.crm_sales_details(
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
)
GO
IF OBJECT_ID('bronze.erp_cust_az12') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
Create Table bronze.erp_cust_az12(
    CID varchar(50),
    BDATE DATE,
    GEN VARCHAR(50)
)
GO
IF OBJECT_ID('bronze.erp_cust_az12') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_loc_a101(
    CID varchar(50),
    CNTRY varchar(100)
)
GO
IF OBJECT_ID('bronze.erp_px_cat_g1v2') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
Create TABLE bronze.erp_px_cat_g1v2(
    ID varchar(50),
    CAT varchar(100),
    SUBCAT varchar(100),
    MAINTENANCE varchar(100)
)
