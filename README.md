# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis    
**Database**: `Reatail`


## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Retail`.
- **Table Creation**: A table named `Retail_Sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
EXEC sp_rename 'Retail_Sales.quantiy', 'quantity', 'COLUMN'; --Rename a column

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Retail_Sales';

SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Retail_Sales';

select * from Retail_Sales;

select COUNT(*) from Retail_Sales;
```

checking for null 
Deleting the null rows 
Data Exploration 
```sql
checking for null 
select * from Retail_Sales
where quantity is null;

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

```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
select * from Retail_Sales
where sale_date='2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
select *
from retail_sales
where category='clothing'
and 
quantity>=4
and 
FORMAT(sale_date, 'yyyy-MM') = '2022-11';
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select
	distinct category,
	SUM(total_sale) [Total Sales by category],
	COUNT(*) [total orders]
from Retail_Sales
group by category
order by category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
select 
	category,AVG(age) [Avg age of customer]
from Retail_Sales
where category='Beauty'
group by category;
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
select * from Retail_Sales
where total_sale>1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select distinct category,
	gender,
	count(transactions_id) [Total number of Transaction]
from 
	Retail_Sales
group by
	gender,
	category
order by count(transactions_id);
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT TOP 5 
    customer_id,
    SUM(total_sale) AS total_sales
FROM Retail_Sales
GROUP BY customer_id
ORDER BY total_sales DESC;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
select 
	category,
	count(distinct customer_id ) [count of unique customer]
from Retail_Sales
group by category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset consists of over 600 unique customers spanning diverse age groups. Categories like Clothing and Beauty saw significant engagement, with Clothing leading in total orders.
- **High-Value Transactions**: Multiple transactions recorded sales above ₹1000, indicating the presence of high-ticket purchases — possibly premium product segments or   bulk orders.
- **Sales Trends**: 1. November 2022 emerged as the top-performing month based on average sales
    2. Afternoon hours (12 PM – 5 PM) showed the highest order volume, suggesting it as the busiest time window for sales.
- **Customer Insights**: 1. Identified the top 5 highest spending customers, helping target loyal or high-value users.
   2. Each product category attracted a different demographic; for example, Beauty products were mostly purchased by customers aged 30–40
- **Category Performance**: 1. Clothing led in both total sales and number of orders.
   2. Profit margins and cost-to-sales analysis (via total_sale - cogs) can be leveraged for pricing strategy.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.
- **Category-Level Analysis**: The analysis revealed total orders and total sales by category, along with the average age of buyers and a detailed gender-wise breakdown for                                 each product category, helping identify target customer segments.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance. Apply key SQL concepts like GROUP BY, RANK(), CASE, DATEPART, and subqueries in a business context







