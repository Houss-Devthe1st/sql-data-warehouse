/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/
------------------------CUSTOMER RELATIONS---------------------------
--select cst_id, count(*) duplicate_count from (
Create view gold.dim_customers as
select
ROW_NUMBER() over (order by ci.cst_id) as customer_key,
ci.cst_id as customer_id, 
ci.cst_key as customer_number,
ci.cst_firstname as first_name,
ci.cst_lastname as last_name,
la.CNTRY as country,
ci.cst_marital_status as marital_status,
case
	when ci.cst_gndr != 'n/a' then ci.cst_gndr
	else COALESCE(ca.GEN, 'N/A')
end as gender,
ca.BDATE as birthdate,
ci.cst_create_date as create_date
from silver.crm_cust_info ci
LEFT join silver.erp_cust_az12 ca on ci.cst_key = ca.CID
LEFT join silver.erp_loc_a101 la on ci.cst_key = la.CID
--) t
--group by cst_id
--having count(*) > 1

--I have 2 sources for the gender, let's check them out
--these 2 source can contraduct (example: one Female the other male), we ask the business which source is the master source regarding that info.
--let's say the CRM table is the master source

select distinct
ci.cst_gndr,
ca.GEN,
case
	when ci.cst_gndr != 'n/a' then ci.cst_gndr
	else COALESCE(ca.GEN, 'N/A')
end as new_gen
from silver.crm_cust_info ci
LEFT join silver.erp_cust_az12 ca on ci.cst_key = ca.CID
LEFT join silver.erp_loc_a101 la on ci.cst_key = la.CID
order by cst_gndr ,GEN

------------------------PRODUCTS RELATIONS---------------------------
--select prd_key, count(*) duplicate_count from (
Create view gold.dim_products as
select
ROW_NUMBER() over (order by pn.prd_start_dt, pn.prd_key) as product_key,
pn.prd_id as product_id,
pn.prd_key as product_number,
pn.prd_nm as product_name,
pn.cat_id as category_id,
pc.CAT as category,
pc.SUBCAT as subcategory,
pc.maintenance,
pn.prd_cost as cost,
pn.prd_line as product_line,
pn.prd_start_dt as start_date
--pn.prd_end_dt removed because it is always null, as per the where condition
from silver.crm_prd_info pn
left join silver.erp_px_cat_g1v2 pc on pn.cat_id = pc.ID
where pn.prd_end_dt is NULL --filter out historical data
--) t
--group by prd_key
--having count(*) > 1

------------------------SALES RELATIONS---------------------------
Create view gold.fact_sales as
select 
sd.sls_ord_num as order_number,
pr.product_key,
--sd.sls_prd_key,
--sd.sls_cust_id,
cs.customer_key,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as shipping_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales_amount,
sd.sls_quantity,
sd.sls_price
from silver.crm_sales_details sd
left join gold.dim_products pr on sd.sls_prd_key = pr.product_number
left join gold.dim_customers cs on sd.sls_cust_id = cs.customer_id

--check if all dimension tables can successfully join to the fact table
select * from gold.fact_sales f
left join gold.dim_customers c
on c.customer_key = f.customer_key
where c.customer_key is NULL

select * from gold.fact_sales f
left join gold.dim_products p
on p.product_key = f.product_key
where p.product_key is NULL
