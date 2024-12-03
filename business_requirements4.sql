-- Determine the top 5 customers by profit in each territory 

select * from (
select region, customer_name, profit, dense_rank() over (partition by region order by profit desc) as rnk 
from(
select customer_name, region, orderquantity*(productprice-productcost) as profit from tbl_fnl_customers as c
inner join tbl_fnl_sales as s
on c.customerkey = s.customerkey
inner join tbl_fnl_prd as p
on p.productkey = s.productkey
inner join tbl_fnl_territory t
on t.salesterritorykey = s.territorykey
) as tbl1 
)as tbl2 
where rnk < 6;



-- Rank customers based on the frequency of their purchases to assign loyalty tiers

select customer_name, customerkey, nooftimes, drnk, case 
		when drnk >= 10 then 'Bronze'
		when drnk <10 and drnk >= 5 then 'Gold'
		else 'Platinum'
    end as Tier
from (
select c.customer_name, tbl.customerkey, nooftimes, dense_rank() over (order by nooftimes desc) as drnk
from(
select customerkey, count(*) as nooftimes from (
select customerkey, orderdate, count(*) from tbl_fnl_sales 
group by customerkey, orderdate) tbl
group by customerkey) tbl
inner join tbl_fnl_customers as c
on tbl.customerkey = c.customerkey) as fnl_tbl;



-- : Determine which products are the most popular based on the number of times they have been ordered

select p.productname, tbl.productkey, tbl.timesordered ,drnk 
from (
select productkey, count(*) as timesordered, dense_rank() over(order by count(*) desc) as drnk
from tbl_fnl_sales
group by productkey) as tbl
inner join tbl_fnl_prd as p
on tbl.productkey = p.productkey
where drnk < 6;



-- For each customer, rank their orders by the quantity of items purchased in a single order

select customerkey, orderdate, count(orderlineitem) as totalitmes, dense_rank() over(partition by customerkey order by count(orderlineitem) desc) as drnk 
from tbl_fnl_sales
group by customerkey, orderdate;



-- Rank the product categories by the total revenue they have generated

select pc.categoryname, sum(s.orderquantity*p.productprice) as total_revenue ,dense_rank() over(order by sum(s.orderquantity*p.productprice) desc) as drnk
from tbl_fnl_sales as s
inner join tbl_fnl_prd as p
on s.productkey = p.productkey
inner join tbl_fnl_prdsubcat as ps
on p.productsubcategorykey = ps.productsubcategorykey
inner join tbl_fnl_prdcat as pc
on ps.productcategorykey = pc.productcategorykey
group by pc.categoryname;



-- Give sequence number to each order by customer and create the view on top of the same

select c.customerkey, c.customer_name, orderdate, row_number() over(partition by customerkey order by orderdate asc) as arrival_num from(
select customerkey, orderdate, count(*) from tbl_fnl_sales
group by customerkey, orderdate) as tbl
inner join tbl_fnl_customers as c
on c.customerkey = tbl.customerkey
;



-- Calculate the year-over-year analysis of sales growth by calculating the annual percentage change in revenue. 

select rev_year, total_revenue, last_year_rev, round((total_revenue-last_year_rev)/last_year_rev*100,2) as y_o_y from(
select rev_year, total_revenue, lag(total_revenue) over(order by rev_year asc) as last_year_rev from(
select year(orderdate) as rev_year, sum(s.orderquantity*p.productprice) as total_revenue 
from tbl_fnl_sales as s
inner join tbl_fnl_prd as p
on s.productkey = p.productkey
group by year(orderdate)) as tbl) as tbl_fnl;