-- creating tables
CREATE TABLE customer_dim (
    cust_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone BIGINT,
    primary_pincode INT,
    gender VARCHAR(10),
    dob DATE,
    joining_date DATE
);

CREATE TABLE pincode_dim (
    pincode INT PRIMARY KEY,
    city VARCHAR(100),
    state VARCHAR(100)
);

CREATE TABLE product_dim (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    brand VARCHAR(50),
    category VARCHAR(50),
    procurement_cost_per_unit INT,
    mrp INT
);

CREATE TABLE delivery_person_dim (
    delivery_person_id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    joining_date DATE,
    pincode INTEGER
);

CREATE TABLE order_dim (
    order_id bigint,
    order_type VARCHAR(20),
    cust_id INTEGER,
    order_date DATE,
    delivery_date DATE,
    tot_units INTEGER,
    displayed_selling_price_per_unit INTEGER,
    total_amount_paid INTEGER,
    product_id INTEGER,
    delivery_person_id INTEGER,
    payment_type VARCHAR(20),
    delivery_pincode INTEGER,
	PRIMARY KEY (order_id, order_type)

);


select * from customer_dim
select * from delivery_person_dim
select * from order_dim
select * from pincode_dim
select * from product_dim

-- 1.How many customers do not have DOB information available ?

select count(*) as result
from customer_dim
where dob is null
 
-- 2.How many customers are there in each pincode and gender combination ?

select primary_pincode, gender,count(cust_id) 
from customer_dim
group by primary_pincode, gender

-- 3.Print product name and mrp for products which have more than 50000 mrp ?

select product_name, mrp
from product_dim
where mrp > 50000

-- 4.How many delivery personal are there in each pincode ?
select pincode, count(delivery_person_id)
from delivery_person_dim
group by pincode

-- 5.For each Pin code, print the count of orders, sum of total amount paid, average amount
-- paid, maximum amount paid, minimum amount paid for the transactions which were
-- paid by 'cash'. Take only 'buy' order types ?

select delivery_pincode,  
	count(order_id),
	sum(total_amount_paid),
	avg(total_amount_paid),
	max(total_amount_paid),
	min(total_amount_paid)
from order_dim
where payment_type like 'cash' and order_type like 'buy'
group by delivery_pincode

-- 6. For each delivery_person_id, print the count of orders and total amount paid for
-- product_id = 12350 or 12348 and total units > 8. Sort the output by total amount paid in
-- descending order. Take only 'buy' order types

select delivery_person_id,
		count(order_id) as order_count,
		sum(total_amount_paid) as total_pay
from order_dim
where product_id in (12350,12348) and tot_units > 8 and order_type like 'buy'
group by 1
order by 3 desc

-- 7. Print the Full names (first name plus last name) for customers that have email on
-- "gmail.com"?
select concat(trim(first_name), ' ', trim(last_name)) as full_name
from customer_dim
where email like '%gmail.com'

-- 8. Which pincode has average amount paid more than 150,000? Take only 'buy' order types
select delivery_pincode
from order_dim
where order_type like 'buy'
group by delivery_pincode
having avg(total_amount_paid) > 150000

-- 9. Create following columns from order_dim data -
--  order_date
--  Order day
--  Order month
--  Order year
select order_date,
		extract(day from order_date) as day,
		extract(month from order_date) as month,
		extract(year from order_date) as year
from order_dim

-- 10. How many total orders were there in each month and how many of them were
-- returned? Add a column for return rate too.
-- return rate = (100.0 * total return orders) / total buy orders
-- Hint: You will need to combine SUM() with CASE WHEN
select month, total_orders, total_returns,
		case
		when total_buys = 0 then null					--case statement is unnecessary here since none of the total_buys value is zero 
		else (100.0 * total_returns) / total_buys 		
		end as return_rate

from
(
select extract(month from order_date) as month,
		count(order_id) as total_orders,
		sum(case order_type when 'return' then 1 else 0 end) as total_returns,
		sum(case order_type when 'buy' then 1 else 0 end) as total_buys
from order_dim
group by month
)

-- 11. How many units have been sold by each brand? Also get total returned units for each
-- brand.
select p.brand,
		sum(case when o.order_type = 'buy' then o.tot_units  else 0 end)as total_unit_sold,
		sum(case when o.order_type = 'return' then o.tot_units else 0 end) as total_returns
from product_dim as p
join order_dim as o on p.product_id = o.product_id
group by 1

-- 12. How many distinct customers and delivery boys are there in each state?
select p.state as state,
		count(distinct(c.cust_id)) as customers_count, 
		count(distinct(d.delivery_person_id)) as deliveryboys_count
from customer_dim as c
join pincode_dim as p on c.primary_pincode = p.pincode
join order_dim as o on o.delivery_pincode = p.pincode
join delivery_person_dim as d on d.delivery_person_id = o.delivery_person_id
group by 1

-- 13. For every customer, print how many total units were ordered, how many units were
-- ordered from their primary_pincode and how many were ordered not from the
-- primary_pincode. Also calulate the percentage of total units which were ordered from
-- primary_pincode(remember to multiply the numerator by 100.0). Sort by the
-- percentage column in descending order.

























































