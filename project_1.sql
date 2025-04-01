-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project;
use sql_project;

-- Create TABLE
CREATE TABLE project_1
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM project_1
LIMIT 10;

SELECT 
    COUNT(*) 
FROM project_1;

-- Data Cleaning

SELECT * FROM project_1
WHERE 
     ï»¿transactions_id is null or 
     sale_date  is null or 
     sale_time is null or 
     customer_id is null or  
     gender is null or 
     age is null or 
     quantiy is null or  
     price_per_unit is null or  
     cogs is null or 
     total_sale is null;
     
DELETE FROM retail_sales
WHERE 
     ï»¿transactions_id is null or 
     sale_date  is null or 
     sale_time is null or 
     customer_id is null or  
     gender is null or 
     age is null or 
     quantiy is null or  
     price_per_unit is null or  
     cogs is null or 
     total_sale is null;

-- Data Exploration

-- 1. how many sales we have
select count(*)
as total_no_of_sales from project_1;

-- 2.  how many customers we have
select count(distinct customer_id) 
as total_customer_number from project_1;

-- 3. total number of category
select distinct(category)
as category_type from project_1;

-- Data Analysis 

-- Q.1 Retrieve All Columns for Sales Made on '2022-11-05'
SELECT *
FROM project_1
WHERE sale_date = '2022-11-05';

-- Q.2 Retrieve Transactions for 'Clothing' Category with Quantity >= 3 in November 2022
SELECT * 
FROM project_1
WHERE category = 'Clothing'
  AND quantiy >= 3
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';

-- Q.3 Find Average Age of Customers Who Purchased 'Beauty' Category
SELECT 
    ROUND(AVG(age), 2) AS average_age
FROM project_1
WHERE category = 'Beauty';

-- Q.4 Retrieve All Transactions Where Total Sale is Greater Than 1000
SELECT *
FROM project_1
WHERE total_sale > 1000;

-- Q.5 Total Number of Transactions by Each Gender in Each Category
SELECT 
    gender,
    category,
    COUNT(*) AS total_transaction
FROM project_1
GROUP BY gender, category
ORDER BY gender;

-- Q.6 Average Sale Per Month & Best Selling Month in Each Year
SELECT 
    year,
    month,
    avg_sale
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS month_rank
    FROM project_1
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
) AS t1
WHERE month_rank = 1;

-- Q.7 Top 5 Customers Based on Highest Total Sales
SELECT 
    DISTINCT(customer_id),
    SUM(total_sale) AS total_sales
FROM project_1
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q.8 Number of Unique Customers Who Purchased Items From Each Category
SELECT 
    category,
    COUNT(DISTINCT(customer_id)) AS unique_customers
FROM project_1
GROUP BY category;

-- Q.9 Shifts & Number of Orders (Morning, Afternoon, Evening)
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM project_1
)
SELECT 
    shift,
    COUNT(*) AS total_orders    
FROM hourly_sale
GROUP BY shift;

-- Q.10 Customer Segmentation Analysis
SELECT 
    CASE 
        WHEN total_sale >= 1000 THEN 'High-Value Customers'
        WHEN total_sale BETWEEN 500 AND 999 THEN 'Mid-Value Customers'
        ELSE 'Low-Value Customers'
    END AS customer_segment,
    COUNT(DISTINCT customer_id) AS num_customers
FROM project_1
GROUP BY customer_segment;

-- Q.11 Combined Sales Performance by Category (Updated from Q3)
SELECT 
    category,
    SUM(total_sale) AS total_sales,
    ROUND(AVG(total_sale), 2) AS avg_sale,
    COUNT(*) AS num_transactions,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM project_1
GROUP BY category
ORDER BY total_sales DESC;

-- Q.12 Top Performing Categories Per Month
SELECT 
    DATE_FORMAT(sale_date, '%Y-%m') AS month,
    category,
    SUM(total_sale) AS total_sales
FROM project_1
GROUP BY month, category
ORDER BY month, total_sales DESC;

-- Q.13 Customer Age Group Analysis
SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        WHEN age > 50 THEN '50+'
        ELSE 'Unknown'
    END AS age_group,
    COUNT(*) AS num_customers,
    SUM(total_sale) AS total_sales
FROM project_1
GROUP BY age_group
ORDER BY total_sales DESC;

-- Q.14 Month-over-Month Sales Growth Rate
WITH monthly_sales AS (
    SELECT 
        DATE_FORMAT(sale_date, '%Y-%m') AS month,
        SUM(total_sale) AS total_sales
    FROM project_1
    GROUP BY month
)
SELECT 
    month,
    total_sales,
    LAG(total_sales, 1) OVER (ORDER BY month) AS previous_month_sales,
    ROUND(((total_sales - LAG(total_sales, 1) OVER (ORDER BY month)) / LAG(total_sales, 1) OVER (ORDER BY month)) * 100, 2) AS growth_rate
FROM monthly_sales;

-- Q.15 Returning vs. New Customers Analysis
WITH first_purchase AS (
    SELECT 
        customer_id,
        MIN(sale_date) AS first_purchase_date
    FROM project_1
    GROUP BY customer_id
)
SELECT 
    CASE 
        WHEN p.sale_date = f.first_purchase_date THEN 'New Customer'
        ELSE 'Returning Customer'
    END AS customer_type,
    COUNT(DISTINCT p.customer_id) AS num_customers,
    SUM(p.total_sale) AS total_sales
FROM project_1 p
LEFT JOIN first_purchase f
ON p.customer_id = f.customer_id
GROUP BY customer_type;

-- Q.16 Sales Performance By Gender & Category
SELECT 
    gender,
    category,
    SUM(total_sale) AS total_sales,
    COUNT(*) AS total_transactions
FROM project_1
GROUP BY gender, category
ORDER BY total_sales DESC;
