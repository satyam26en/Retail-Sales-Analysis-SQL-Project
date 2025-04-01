Project Overview

Project Title: Retail Sales Analysis   
Database: sql_project

This project demonstrates the essential SQL skills used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, cleaning and exploring the data, and answering specific business questions through SQL queries. It serves as a solid foundation for those starting their journey in data analysis using SQL.

Objectives
1. Database Setup: Create and populate a retail sales database with provided sales data.
2. Data Cleaning: Identify and remove records with missing or null values.
3. Exploratory Data Analysis (EDA): Perform various analyses to understand the dataset.
4. Business Analysis: Use SQL queries to answer targeted business questions and extract actionable insights.

Project Structure

1. Database Setup
  
   The project begins with the creation of a database named "sql_project" and a table called "project_1" to store sales data. The table includes columns for transaction details, sale date and time, customer information, and sales figures.

   SQL Code:
   ```
   -- SQL Retail Sales Analysis - P1
   CREATE DATABASE sql_project;
   USE sql_project;

   -- Create TABLE
   CREATE TABLE project_1
   (
       transaction_id INT PRIMARY KEY,
       sale_date DATE,
       sale_time TIME,
       customer_id INT,
       gender VARCHAR(15),
       age INT,
       category VARCHAR(15),
       quantity INT,
       price_per_unit FLOAT,
       cogs FLOAT,
       total_sale FLOAT
   );
   ```
   

2. Data Exploration & Cleaning
   -----------------------------
   This section includes queries to preview the data, count records, and clean the dataset by removing any rows with missing values.

   SQL Code:
   ```
   -- Preview Data
   SELECT * FROM project_1
   LIMIT 10;

   -- Count Total Sales Records
   SELECT COUNT(*) FROM project_1;

   -- Data Cleaning: Identify records with null values
   SELECT * FROM project_1
   WHERE 
        ï»¿transactions_id IS NULL OR 
        sale_date IS NULL OR 
        sale_time IS NULL OR 
        customer_id IS NULL OR  
        gender IS NULL OR 
        age IS NULL OR 
        quantiy IS NULL OR  
        price_per_unit IS NULL OR  
        cogs IS NULL OR 
        total_sale IS NULL;

   -- Delete records with null values (Note: Adjust table name if necessary)
   DELETE FROM retail_sales
   WHERE 
        ï»¿transactions_id IS NULL OR 
        sale_date IS NULL OR 
        sale_time IS NULL OR 
        customer_id IS NULL OR  
        gender IS NULL OR 
        age IS NULL OR 
        quantiy IS NULL OR  
        price_per_unit IS NULL OR  
        cogs IS NULL OR 
        total_sale IS NULL;
   ```
  

3. Data Analysis & Business Insights
   -----------------------------------
   The following SQL queries address key business questions and provide insights into the sales data:

   1. Retrieve All Sales on a Specific Date  
      Retrieve all columns for sales made on '2022-11-05'.
      
      ```
      SELECT *
      FROM project_1
      WHERE sale_date = '2022-11-05';
      ```
    

   2. Transactions for 'Clothing' Category in November 2022  
      Retrieve transactions for the 'Clothing' category where quantity is at least 3.
     
      ```
      SELECT * 
      FROM project_1
      WHERE category = 'Clothing'
        AND quantiy >= 3
        AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';
      ```
      

   3. Average Age for 'Beauty' Category Customers  
      Calculate the average age of customers who purchased items from the 'Beauty' category.
     
      ```
      SELECT 
          ROUND(AVG(age), 2) AS average_age
      FROM project_1
      WHERE category = 'Beauty';
      ```
      

   4. High-Value Transactions  
      Retrieve all transactions where the total sale exceeds 1000.
     
      ```
      SELECT *
      FROM project_1
      WHERE total_sale > 1000;
      ```
      

   5. Transactions by Gender & Category  
      Count the number of transactions by each gender within each product category.
      
      ```
      SELECT 
          gender,
          category,
          COUNT(*) AS total_transaction
      FROM project_1
      GROUP BY gender, category
      ORDER BY gender;
      ```
     
   6. Best Selling Month per Year  
      Calculate the average sale per month and determine the best selling month for each year.
     
      ```
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
      ```
      

   7. Top 5 Customers by Total Sales  
      Identify the top 5 customers based on their total sales.
   
      ```
      SELECT 
          DISTINCT(customer_id),
          SUM(total_sale) AS total_sales
      FROM project_1
      GROUP BY customer_id
      ORDER BY total_sales DESC
      LIMIT 5;
      ```
      

   8. Unique Customers per Category  
      Find the number of unique customers for each product category.
      
      ```
      SELECT 
          category,
          COUNT(DISTINCT(customer_id)) AS unique_customers
      FROM project_1
      GROUP BY category;
      ```
      

   9. Shifts & Order Counts  
      Analyze the number of orders during different shifts (Morning, Afternoon, Evening) based on sale time.
      
      ```
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
      ```
      
   10. Customer Segmentation Analysis  
       Categorize customers based on their total sale value.
      
       ```
       SELECT 
           CASE 
               WHEN total_sale >= 1000 THEN 'High-Value Customers'
               WHEN total_sale BETWEEN 500 AND 999 THEN 'Mid-Value Customers'
               ELSE 'Low-Value Customers'
           END AS customer_segment,
           COUNT(DISTINCT customer_id) AS num_customers
       FROM project_1
       GROUP BY customer_segment;
       ```
       
   11. Combined Sales Performance by Category  
       Analyze overall sales performance by category including total sales, average sale, and unique customers.
       
       ```
       SELECT 
           category,
           SUM(total_sale) AS total_sales,
           ROUND(AVG(total_sale), 2) AS avg_sale,
           COUNT(*) AS num_transactions,
           COUNT(DISTINCT customer_id) AS unique_customers
       FROM project_1
       GROUP BY category
       ORDER BY total_sales DESC;
       ```
       

   12. Top Performing Categories Per Month  
       Identify top categories based on monthly total sales.
       
       ```
       SELECT 
           DATE_FORMAT(sale_date, '%Y-%m') AS month,
           category,
           SUM(total_sale) AS total_sales
       FROM project_1
       GROUP BY month, category
       ORDER BY month, total_sales DESC;
       ```
       

   13. Customer Age Group Analysis  
       Analyze customer distribution and sales by defined age groups.
      
       ```
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
       ```
       
   14. Month-over-Month Sales Growth Rate  
       Calculate the sales growth rate from one month to the next.
       
       ```
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
           ROUND(((total_sales - LAG(total_sale, 1) OVER (ORDER BY month)) / LAG(total_sale, 1) OVER (ORDER BY month)) * 100, 2) AS growth_rate
       FROM monthly_sales;
       ```
       

   15. Returning vs. New Customers Analysis  
       Analyze customer behavior by comparing first-time and returning customers.
       
       ```
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
       ```
       
   16. Sales Performance by Gender & Category  
       Summarize sales and transaction counts by gender within each category.
       
       ```
       SELECT 
           gender,
           category,
           SUM(total_sale) AS total_sales,
           COUNT(*) AS total_transactions
       FROM project_1
       GROUP BY gender, category
       ORDER BY total_sales DESC;
       ```
       

Findings
--------
- Data Quality & Cleaning: Early queries help ensure data integrity by identifying and removing records with missing values.
- Customer & Sales Insights: The analysis covers various dimensions including high-value transactions, demographic trends, and shifting customer segments.
- Performance Trends: Monthly and shift-based analyses reveal key trends and performance metrics to guide business decisions.
- Segmentation: Customer segmentation and age group analyses provide insights into customer behavior and spending patterns.

Conclusion
----------
This project serves as an in-depth introduction to SQL for retail sales analysis. By setting up a dedicated database, cleaning the data, and executing targeted queries, the analysis provides a comprehensive view of sales performance, customer behavior, and market trends. These insights are crucial for making data-driven decisions in a retail environment.

How to Use
----------
1. Clone the Repository:  
   Clone this project from GitHub.
2. Set Up the Database:  
   Run the provided SQL script to create the "sql_project" database and the "project_1" table.
3. Execute the Queries:  
   Run the analysis queries to explore the data and derive business insights.
4. Customize & Extend:  
   Modify the queries as needed to further explore the dataset or answer additional questions.

Author
------
Satyam Kumar

This project has been built by Satyam Kumar as part of his portfolio to showcase essential SQL skills for data analysis roles. If you have any questions, feedback, or collaboration ideas, feel free to reach out.

Stay Connected
--------------
You can connect with me through the following platforms:
- Email: satyamkumar26en@gmail.com
- LinkedIn: https://www.linkedin.com/in/satyam26en/

Thank you for your support and interest!
--------------------------------------------------


