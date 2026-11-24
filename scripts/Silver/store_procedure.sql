/*
==========================================================
Author: Saurabh Singh
==========================================================
Description:
silver Layer - Inserting Data into silver table after tranformation and cleaning the data
==========================================================
*/
CReate or alter PROCEDURE silver.load_procedure AS
Begin
-- customer info Table
TRUNCATE table silver.crm_cust_info
Insert into silver.crm_cust_info(
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)(
SELECT cst_id,
       cst_key,
       ---------------------------------------------
         --- Data Cleaning
       TRIM(cst_firstname) AS cst_firstname,
       TRIM(cst_lastname) AS cst_lastname,
       ---------------------------------------------
       --- Data Normalization
       CASE WHEN UPPER(trim(cst_marital_status)) = 'M' THEN 'Married'
        WHEN UPPER(trim(cst_marital_status)) = 'S' THEN 'Single' 
        ELSE 'n/a' END AS cst_marital_status,
        CASE WHEN UPPER(trim(cst_gndr)) = 'M' THEN 'Male' 
        WHEN UPPER(trim(cst_gndr)) = 'F' THEN 'Female' 
        ELSE 'n/a' END AS cst_gndr,
        ---------------------------------------------
       cst_create_date
FROM   (SELECT *,
               ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
        FROM   bronze.crm_cust_info) AS t
WHERE  flag_last = 1
       AND cst_id IS NOT NULL);
---------------------------------------------
--  Storing Product Info Table
TRUNCATE table silver.crm_prd_info
insert into silver.crm_prd_info(
    prid_id,
     prid_key,
    cat_id,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
select 
prid_id,
Substring(prid_key,7,LEN(prid_key)) as prid_key, -- Ectact the product key from prid_key
REPLACE(SUBSTRING(prid_key,0,6),'-','_') as cat_id, -- Extract the category id from prid_key
prd_nm,
ISNULL(prd_cost, 0) as prd_cost, -- Replace null with 0
case when upper(trim(prd_line))='M' then 'Mountain'
when upper(trim(prd_line))='R' then 'Road'
when upper(trim(prd_line))='T' then 'Touring'
when upper(trim(prd_line))='S' then 'Other Sales'
else 'n/a' end as prd_line,
prd_start_dt,
    DateAdd(MONTH, -1, LEAD(prd_start_dt) OVER (
           PARTITION BY prid_key
           ORDER BY prd_start_dt
       )) AS prd_end_dt
from bronze.crm_prd_info
---------------------------------------------
--  Storing Sales Info Table
TRUNCATE table silver.crm_sales_details
INSERT INTO silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_price,
    sls_quantity
)
SELECT sls_ord_num,
       sls_prd_key,
       sls_cust_id,
       ----------------------------------------------
         --- Date Conversion
       CASE WHEN sls_order_dt = 0
                 OR len(sls_order_dt) != 8 THEN NULL ELSE CAST (CAST (sls_order_dt AS VARCHAR) AS DATE) END AS sls_order_dt,
       CASE WHEN sls_ship_dt = 0
                 OR len(sls_ship_dt) != 8 THEN NULL ELSE CAST (CAST (sls_ship_dt AS VARCHAR) AS DATE) END AS sls_ship_dt,
       CASE WHEN sls_due_dt = 0
                 OR len(sls_due_dt) != 8 THEN NULL ELSE CAST (CAST (sls_due_dt AS VARCHAR) AS DATE) END AS sls_due_dt,
        ---------------------------------------------------
        -- Data Calculation of Sales and Price
       CASE WHEN sls_sales = 0
                 OR sls_sales IS NULL
                 OR sls_sales != sls_price * sls_quantity THEN sls_price * sls_quantity ELSE sls_sales END AS sls_sales,
       CASE WHEN sls_price IS NULL
                 OR sls_price = 0 THEN sls_sales / sls_quantity ELSE sls_price END AS sls_price,
       sls_quantity
FROM   bronze.crm_sales_details;
--------------------------------------------------
TRUNCATE table silver.erp_cust_az12
Insert into silver.erp_cust_az12
(CID,BDATE,gen)
SELECT
    CASE
        WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(CID))
        ELSE CID
    END AS CID,

    CASE
        WHEN BDATE > GETDATE() THEN NULL
        ELSE BDATE
    END AS BDATE,

    CASE
        WHEN UPPER(TRIM(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), '')))
             IN ('F', 'FEMALE') THEN 'Female'

        WHEN UPPER(TRIM(REPLACE(REPLACE(gen, CHAR(13), ''), CHAR(10), '')))
             IN ('M', 'MALE') THEN 'Male'

        ELSE 'n/a'
    END AS gen from bronze.erp_cust_az12
-----------------------------

-------
TRUNCATE table silver.erp_loc_a101
INSERT into silver.erp_loc_a101
(CID,CNTRY)
select
REPLACE(CID,'-','') as CID,
Case 
when REPLACE(CNTRY,CHAR(13),'')='DE' then 'Germany'
when REPLACE(trim(CNTRY),CHAR(13),'') in ('US','USA') then 'United States'
else REPLACE(trim(CNTRY),CHAR(13),'') END AS CNTRY
from bronze.erp_loc_a101
------------------------
TRUNCATE table silver.erp_px_cat_g1v2
INSERT into silver.erp_px_cat_g1v2(
    ID,
    CAT,
    SUBCAT,
    MAINTENANCE
)
select ID,CAT,SUBCAT,
REPLACE(MAINTENANCE,char(13),'') as MAINTENANCE 
from bronze.erp_px_cat_g1v2
------------------------------
End