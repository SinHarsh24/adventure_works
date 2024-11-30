-- Customer Names who have purchased specific product

select distinct customer_name from tbl_fnl_customers where customerkey in (
select customerkey from tbl_fnl_sales where productkey = (
select productkey from tbl_fnl_prd where productname = 'AWC Logo Cap'));



-- Products that have never been ordered
select productname from tbl_fnl_prd where 
productsubcategorykey in (
select productsubcategorykey from tbl_fnl_prdsubcat
where  productcategorykey = (
select productcategorykey from tbl_fnl_prdcat
where categoryname = "Clothing"))
and productkey not in (select productkey from tbl_fnl_sales);



-- Total sales for given territory

select sum(orderquantity*productprice) as total_sales
from tbl_fnl_sales as s
inner join tbl_fnl_prd as p
on p.productkey = s.productkey
where s.territorykey = 
(select salesterritorykey from tbl_fnl_territory where country = "Germany");



-- Identify customers with annual income higher than the average income of their region

create view vw_cust_sales as 
select distinct c.customerkey, c.customer_name, c.annual_income, s.territorykey
from tbl_fnl_customers as c
inner join tbl_fnl_sales as s
on c.customerkey = s.customerkey;

select * from vw_cust_sales where annual_income > (
select avg(annual_income) 
from vw_cust_sales as c 
inner join tbl_fnl_territory as t
on c.territorykey = t.salesterritorykey
where region = "France")
and territorykey = 7;



-- List products that have a cost higher than the average cost of all products in their subcategory

select p.productname, p.productsubcategorykey, p.productcost
from tbl_fnl_prd as p
where p.productcost >
(select avg(p2.productcost) from tbl_fnl_prd as p2
where p2.productsubcategorykey = p.productsubcategorykey
and p.productsubcategorykey = 37
);




