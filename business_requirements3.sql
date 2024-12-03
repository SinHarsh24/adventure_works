-- Calculate the total sales by territory using the sum of product prices multiplied by order quantities 

with totalsalesbyterritory as 
(
    select s.territorykey, sum(s.orderquantity*p.productprice) as totalsales
    from tbl_fnl_sales s 
    inner join tbl_fnl_prd p on s.productkey = p.productkey
    group by s.territorykey
),
-- Calculate the average sales across all territories
averagesales as 
(
    select avg(totalsales) as avg_sales from totalsalesbyterritory
)
-- Select territories where sales exceed the average sales
select * from totalsalesbyterritory
join averagesales 
where totalsales > avg_sales;



-- Retrieve all sales entries for a specific customer

select * from tbl_fnl_sales where customerkey = 11019;

-- Count the number of orders for a specific customer on different dates
select count(*) from (
    select orderdate, customerkey, count(*) 
    from tbl_fnl_sales 
    group by orderdate, customerkey
    having customerkey = 14657
) tbl;

-- Count total orders for each customer grouped by date
with customerorder as 
(
    select customerkey, orderdate, count(*) as total_items
    from tbl_fnl_sales 
    group by customerkey, orderdate
),
-- Count the total number of orders per customer
totalorders as 
(
    select customerkey, count(*) as total_orders from customerorder
    group by customerkey
)
-- Join customer details with their order totals
select c.customerkey, c.customer_name, tod.total_orders 
from tbl_fnl_customers c 
inner join totalorders tod on c.customerkey = tod.customerkey;



-- Calculate total sales per product

with productsales as 
(
    select productname, sum(orderquantity*productprice) as total_sales 
    from tbl_fnl_prd p inner join tbl_fnl_sales s on p.productkey = s.productkey
    group by productname 
)
select * from productsales;



-- Calculate total quantities sold per product

with productquantity as 
(
    select productkey, sum(orderquantity) as total_quantity
    from tbl_fnl_sales 
    group by productkey
)
-- Join product details with quantity information
select productname, total_quantity 
from productquantity pq inner join tbl_fnl_prd p on pq.productkey = p.productkey;



-- Retrieve all product details

select * from tbl_fnl_prd;

-- Get the most recent order date for each customer
with recentorder as (
    select customerkey, max(orderdate) as lastorderdate from tbl_fnl_sales 
    group by customerkey
)
-- Join customer details with their last order date
select c.customerkey, c.customer_name, lastorderdate
from tbl_fnl_customers c inner join recentorder ro on c.customerkey = ro.customerkey;



-- Calculate average product price per category

with categoryavgprice as 
(
    select categoryname, avg(productprice) as avgprice 
    from tbl_fnl_prd p 
    inner join tbl_fnl_prdsubcat ps on p.productsubcategorykey = ps.productsubcategorykey
    inner join tbl_fnl_prdcat pc on ps.productcategorykey = pc.productcategorykey
    group by categoryname
)
select categoryname, avgprice from categoryavgprice;



-- Compute total revenue and customer-specific revenue

with revenueperreg as 
(
    select territorykey, region, sum(orderquantity*productprice) as total_revenue
    from tbl_fnl_sales s 
    inner join tbl_fnl_prd p on s.productkey = p.productkey 
    inner join tbl_fnl_territory t on s.territorykey = t.salesterritorykey
    group by territorykey, region
),
custrev as 
(
    select customerkey, sum(orderquantity*productprice) as cust_rev
    from tbl_fnl_sales s inner join tbl_fnl_prd p on s.productkey = p.productkey
    group by customerkey
),
customerdetails as 
(
    select customerkey, customer_name, email_adress, gender, annual_income
    from tbl_fnl_customers
),
fullcustomerdetails as 
(
    select cd.customerkey, cd.customer_name, cd.email_adress, cd.gender, cd.annual_income, cr.cust_rev
    from customerdetails cd inner join custrev cr on cd.customerkey = cr.customerkey
),
finalinfo as
(
    select distinct fcd.customerkey, customer_name, email_adress, gender, annual_income, cust_rev, s.territorykey, rp.region, rp.total_revenue
    from fullcustomerdetails fcd
    inner join tbl_fnl_sales s on fcd.customerkey = s.customerkey
    inner join revenueperreg rp on rp.territorykey = s.territorykey
)
-- Display the percentage contribution of each customer's revenue to the total revenue of their region
select customerkey, customer_name, email_adress, gender, annual_income, cust_rev, territorykey, region, total_revenue, 
(cust_rev/total_revenue)*100 as percentcontri from finalinfo;
