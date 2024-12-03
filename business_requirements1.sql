-- Customer Demographic and sales data

select gender , marital_status, avg(annual_income) as avg_income, sum(sales) as sum_sales, sum(profit) as sum_profit 
from(
select gender, marital_status,annual_income, productprice as sales, (productprice - productcost)*orderquantity as profit
from tbl_fnl_customers as cust
inner join tbl_fnl_sales as sales
on cust.customerkey = sales.customerkey
inner join tbl_fnl_prd as prd
on sales.productkey = prd.productkey) as tbl
group by gender, marital_status;


-- Product Sales Performance
select productname, sum(orderquantity) as total_quantity
from(
select productname, orderquantity from tbl_fnl_prd as prd inner join tbl_fnl_sales as sales
on prd.productkey = sales.productkey) as tbl
group by productname
order by total_quantity desc
limit 5;


-- Sales trend over time

select year(orderdate) as purchase_year, month(orderdate) as purchase_month, sum(productprice) as total_sales 
from tbl_fnl_prd as prd
inner join tbl_fnl_sales as sales 
on prd.productkey = sales.productkey
group by purchase_year,purchase_month
order by total_sales desc;


-- Product category pupularity

select categoryname, sum(orderquantity) as total_quantity
from tbl_fnl_prdcat as prdcat
inner join tbl_fnl_prdsubcat as prdsubcat
on prdcat.productcategorykey = prdsubcat.productcategorykey
inner join tbl_fnl_prd as prd 
on prd.productsubcategorykey = prdsubcat.productsubcategorykey
inner join tbl_fnl_sales as sales
on sales.productkey = prd.productkey
group by categoryname
order by total_quantity desc;



-- Geographical Distribution of Sales


select region, country, sum(productprice) as total_sales
from tbl_fnl_territory as terr
inner join tbl_fnl_sales as sales
on terr.salesterritorykey = sales.territorykey
inner join tbl_fnl_prd as prd
on prd.productkey = sales.productkey
group by region, country
order by total_sales desc;



-- Prfitability per product
select productname, sum(profit) as profit
from(
select productname, (productprice-productcost)*orderquantity as profit  from tbl_fnl_prd as prd
inner join tbl_fnl_sales as sales
on prd.productkey = sales.productkey) as tbl
group by productname
order by profit desc;



-- Profitable Customers

select customer_name, sum(profit) as profit
from(
select customer_name, (productprice-productcost)*orderquantity as profit
from tbl_fnl_customers as cust
inner join tbl_fnl_sales as sales
on cust.customerkey = sales.customerkey
inner join tbl_fnl_prd as prd
on prd.productkey = sales.productkey
where customer_name is not null) as tbl
group by customer_name
order by profit desc
limit 5;
