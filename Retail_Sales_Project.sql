

Create database Retail;

use Retail;

Create table Retail_Sales (
	transactions_id int Primary key,	
	sale_date Date,
	sale_time Time,
	customer_id int,
	gender varchar(255),
	age tinyint,
	category varchar(255),
	quantiy  int,
	price_per_unit float,
	cogs float,
	total_sale float
);

INSERT INTO Retail_Sales (
  transactions_id, sale_date, sale_time, customer_id, gender,
  age, category, quantiy, price_per_unit, cogs, total_sale
)
SELECT
  transactions_id, sale_date, sale_time, customer_id, gender,
  age, category, quantiy, price_per_unit, cogs, total_sale
FROM [SQL - Retail Sales Analysis_utf];

select * from Retail_Sales;

--alter table retail_sales
--rename column quantiy to quantity; works in MySQL

EXEC sp_rename 'Retail_Sales.quantiy', 'quantity', 'COLUMN'; 

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Retail_Sales';

SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Retail_Sales';

select * from Retail_Sales;

select COUNT(*) from Retail_Sales;

-- checking for null 
select * from Retail_Sales
where quantity is null;

--Deleting the null rows 
delete from Retail_Sales
where quantity is null;

select * from Retail_Sales
where quantity is null;

-- Data Exploration 

-- how many sales we have ?
select COUNT(*) [Total sales] from Retail_Sales;

--how many unique customer we have?
select COUNT(distinct customer_id ) as total_cutomer from Retail_Sales;

select distinct category from Retail_Sales;

--Data Analysis & Business key Problem

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from Retail_Sales
where sale_date='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select *
from retail_sales
where category='clothing'
and 
quantity>=4
and 
FORMAT(sale_date, 'yyyy-MM') = '2022-11';


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select
	distinct category,
	SUM(total_sale) [Total Sales by category],
	COUNT(*) [total orders]
from Retail_Sales
group by category
order by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select 
	category,AVG(age) [Avg age of customer]
from Retail_Sales
where category='Beauty'
group by category;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from Retail_Sales
where total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select distinct category,
	gender,
	count(transactions_id) [Total number of Transaction]
from 
	Retail_Sales
group by
	gender,
	category
order by count(transactions_id);


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select * from(
	SELECT
		YEAR(sale_date) AS [year],
		MONTH(sale_date) AS [month],
		AVG(total_sale) AS avg_total_sale,
		RANK() over(partition by  YEAR(sale_date) order by AVG(total_sale) desc) as Rank
	FROM 
		Retail_Sales
	GROUP BY
		YEAR(sale_date),
		MONTH(sale_date)) as ranked_data
where Rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT TOP 5 
    customer_id,
    SUM(total_sale) AS total_sales
FROM Retail_Sales
GROUP BY customer_id
ORDER BY total_sales DESC;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select 
	category,
	count(distinct customer_id ) [count of unique customer]
from Retail_Sales
group by category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with Hourly_sales as (
select *,
	case 
		when DATEPART(HOUR, sale_time) < 12 then 'Morning'
		when DATEPART(HOUR, sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as Shift
from Retail_Sales)
select COUNT(transactions_id) [Total Order] ,Shift from Hourly_sales
group by Shift


        