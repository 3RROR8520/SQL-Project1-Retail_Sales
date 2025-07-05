-- SQL Retail Sales Analysis - P1
CREATE DATABASE Project1;


-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id SMALLINT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	TINYINT,
                gender	VARCHAR(50),
                age	TINYINT,
                category VARCHAR(50),	
                quantity	TINYINT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales


    

SELECT 
    COUNT(*) 
FROM retail_sales

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transaction_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL
    OR
    age is NULL;
    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales



SELECT DISTINCT category FROM retail_sales


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022

SELECT 
    *
FROM retail_sales
WHERE
    category = 'clothing'
    AND
    sale_date like '%2022-11%'
    AND
    quantity >=3;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
    category,
    SUM(total_sale) AS net_sales,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
    AVG(age) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
    category,
    gender,
    COUNT(transaction_id) AS total_trans
FROM 
    retail_sales
GROUP BY 
    category, gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT sale_year, sale_month, avg_sale FROM
(
    SELECT 
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS monthly_rank
    FROM 
        retail_sales
    GROUP BY 
        YEAR(sale_date),
        MONTH(sale_date)
) AS t1
WHERE monthly_rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
    TOP 5
    customer_id, 
    SUM(total_sale) as total_sales
FROM 
    retail_sales
GROUP BY 
    customer_id
ORDER BY 
    SUM(total_sale) DESC;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
    category,
    COUNT(DISTINCT customer_id) as unique_customer
FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

SELECT 
    CASE
        WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 
    CASE
        WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END;

