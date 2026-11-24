/*
------------------------------------
Author - Saurabh Singh
------------------------------------
Description: Gold layer creating sales, customer and product dim & fact view
----------------------------------
*/

-- Customer Details
create view gold.dim_customers as (
select 
ROW_NUMBER() over(order by ci.cst_id) as customer_key,
ci.cst_id as customer_id,
ci.cst_key as customer_number,
ci.cst_firstname as first_name,
ci.cst_lastname as last_name,
Case when ci.cst_gndr='n/a' then ci.cst_gndr
Else coalesce(ca.GEN,'n/a') end as Gender,
ci.cst_marital_status as marital_status,
ci.cst_create_date as created_date,
ca.BDATE as birthdate,
loc.CNTRY as country
 from silver.crm_cust_info ci left join 
 silver.erp_cust_az12 ca on ci.cst_key=ca.cid
 left join silver.erp_loc_a101 loc on loc.CID=ci.cst_key)

 ---Product details
 create view gold.dim_products as(
 select 
 ROW_NUMBER() over(order by prid_id) as product_key,
 prid_id as product_id,
 prid_key as product_number,
 prd_nm as product_name,
 cat_id as [CategoryID],
 CAT as [Category],
 SUBCAT as [SubCategory], 
 MAINTENANCE,
 prd_cost as Cost,
 prd_line as [Product_line],
 prd_start_dt as Start_Date
 from 
 silver.crm_prd_info
 left join silver.erp_px_cat_g1v2 on ID=cat_id
 where prd_end_dt is null)
--------------------------------------------
-- sales detail
create view gold.fact_sales as(
select 
sls_ord_num as order_number,
product_key,
customer_key,
sls_order_dt as order_date,
sls_ship_dt as ship_date,
sls_due_dt as due_date,
sls_sales as sales_amount,
sls_quantity as quantity,
sls_price as price
from silver.crm_sales_details left join gold.dim_products ON sls_prd_key=product_number
left join gold.dim_customers on sls_cust_id=customer_id)

