-- Create database

CREATE DATABASE SQL_Project_1;

-- Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
		(
			transactions_id	INT PRIMARY KEY,
            sale_date DATE,
            sale_time TIME,	
            customer_id	INT,
            gender VARCHAR (15),
            age	INT,
            category VARCHAR (25),
            quantity INT,
            price_per_unit DECIMAL (10,2),	
            cogs DECIMAL (10,2),
            total_sale DECIMAL (10,2)
        );
        
SELECT * FROM retail_sales
LIMIT 10;

SELECT 
	COUNT(*)
FROM retail_sales;

-- DATA CLEANING

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
    sale_date IS NULL
	OR
    sale_time IS NULL
	OR
    customer_id IS NULL
	OR
    gender IS NULL
	OR
    age IS NULL
	OR
    category IS NULL
	OR
    quantity IS NULL
	OR
    price_per_unit IS NULL
	OR
    cogs IS NULL
	OR
    total_sale IS NULL;

--
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
    sale_date IS NULL
	OR
    sale_time IS NULL
	OR
    customer_id IS NULL
	OR
    gender IS NULL
	OR
    age IS NULL
	OR
    category IS NULL
	OR
    quantity IS NULL
	OR
    price_per_unit IS NULL
	OR
    cogs IS NULL
	OR
    total_sale IS NULL;
    
--
SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;

-- DATA EXPLORATION

-- How many records we have ?
SELECT COUNT(*) as records FROM retail_sales;

-- How many customers we have ?
SELECT COUNT(customer_id) as total_customer FROM retail_sales;

-- How many unique customers we have ?
SELECT COUNT(distinct customer_id) as unique_customer FROM retail_sales;

-- what categories we have ?
SELECT distinct category as category FROM retail_sales;

-- Data Analysis 10 business questions 

-- Q1 Retrieve all sales records from November 5, 2022.
SELECT *
FROM retail_sales 
WHERE sale_date = '2022-11-05';

-- Q2 Get transactions in the 'Clothing' category with a quantity sold greater than 4 during November 2022.
SELECT *
FROM retail_sales 
WHERE category = 'Clothing' 
	AND
	DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
    AND
    quantity >= 4;

-- Q3 Calculate the total sales amount for each product category.
SELECT  category ,  sum(total_sale) as 'Sales_amount'
FROM retail_sales
GROUP BY category;

-- Q4 Determine the average age of customers who bought products from the 'Beauty' category.
SELECT ROUND(avg (age), 2)
FROM retail_sales 
WHERE category = 'Beauty' ;

-- Q5 List transactions where the total sale amount exceeds 1000.
SELECT *
FROM retail_sales 
WHERE total_sale > 1000 ;

-- Q6 Count the total number of transactions per gender within each category.
SELECT gender, category, count(*) AS 'Transactions'
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Q7 Calculate the average monthly sales and identify the top-selling month for each year.
SELECT
YEAR,
MONTH,
Avg_sale
FROM 
(
SELECT 
		YEAR(sale_date) AS 'Year', 
		MONTH(sale_date) AS 'Month', 
		avg(total_sale) AS Avg_sale, 
		RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY avg(total_sale) DESC) AS 'rnk'
FROM retail_sales 
GROUP BY 1 ,2
) AS RANKED
WHERE RNK = 1;

-- Q8 Find the top 5 customers based on total purchase value.
SELECT customer_id, SUM(total_sale) AS Highest_sale
FROM retail_sales
group by customer_id
order by Highest_sale desc
limit 5 ;

-- Q9 Count the number of distinct customers who purchased from each category.
SELECT COUNT(distinct customer_id), category
FROM retail_sales
group by category;

-- Q10 Classify orders by shift (Morning, Afternoon, Evening) and count the number of orders in each shift.
SELECT 
  CASE 
    WHEN HOUR(sale_time) <12 THEN 'Morning'
    WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN HOUR(sale_time) BETWEEN 18 AND 23 THEN 'Evening'
    ELSE 'Night'
  END AS Shift,
  COUNT(*) AS Order_Count
FROM retail_sales
GROUP BY Shift;
