-- ================================================
-- Supermarket Sales Analysis
-- Author: rushil-data-analyst
-- Description: Data cleaning and sales analysis
-- ================================================

-- Create table
CREATE TABLE sales (
  sale_id INT,
  customer_name VARCHAR(50),
  product VARCHAR(50),
  category VARCHAR(50),
  city VARCHAR(50),
  amount DECIMAL(10,2),
  quantity INT
);

-- Clean data
UPDATE sales
SET
  customer_name = UPPER(TRIM(customer_name)),
  city = UPPER(TRIM(city));

-- Top selling product
SELECT product,
  SUM(amount) AS total_revenue,
  SUM(quantity) AS total_quantity
FROM sales
GROUP BY product
ORDER BY total_revenue DESC;

-- Best city by revenue
SELECT city,
  SUM(amount) AS total_revenue,
  COUNT(*) AS total_orders
FROM sales
GROUP BY city
ORDER BY total_revenue DESC;

-- Best customer
SELECT customer_name,
  SUM(amount) AS total_spent,
  COUNT(*) AS total_orders
FROM sales
GROUP BY customer_name
ORDER BY total_spent DESC;
