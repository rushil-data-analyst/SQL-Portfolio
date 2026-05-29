-- ================================================
-- E-Commerce Business Intelligence Report
-- Author: Rushil Beladiya
-- Skills: JOINs, CTEs, CASE WHEN, NULL handling,
--         DATE functions, Data Cleaning
-- ================================================

-- ================================================
-- SETUP: Create Tables and Insert Data
-- ================================================
CREATE TABLE customers (
  id INT, name VARCHAR(50),
  email VARCHAR(100), city VARCHAR(50),
  signup_date DATE
);
CREATE TABLE products (
  id INT, name VARCHAR(50),
  category VARCHAR(50), price DECIMAL(10,2)
);
CREATE TABLE orders (
  id INT, customer_id INT, product_id INT,
  quantity INT, order_date DATE, status VARCHAR(20)
);

-- ================================================
-- QUERY 1: Clean Customer Data
-- Skills: UPPER, LOWER, TRIM, COALESCE, NULL
-- ================================================
SELECT
  id,
  UPPER(TRIM(name)) AS name,
  LOWER(TRIM(email)) AS email,
  COALESCE(UPPER(TRIM(city)), 'Unknown') AS city,
  signup_date
FROM customers;

-- ================================================
-- QUERY 2: Full Sales Report (3 Tables Joined)
-- Skills: JOIN, ROUND, ORDER BY
-- ================================================
SELECT
  UPPER(c.name) AS customer,
  COALESCE(UPPER(c.city), 'Unknown') AS city,
  p.name AS product,
  p.category,
  o.quantity,
  ROUND(p.price * o.quantity, 2) AS total_spent,
  o.order_date,
  o.status
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN products p ON o.product_id = p.id
ORDER BY total_spent DESC;

-- ================================================
-- QUERY 3: Customer Loyalty Report
-- Skills: CTE, LEFT JOIN, CASE WHEN, COALESCE
-- ================================================
WITH customer_totals AS (
  SELECT
    c.id,
    UPPER(TRIM(c.name)) AS name,
    COALESCE(UPPER(c.city), 'Unknown') AS city,
    COUNT(o.id) AS total_orders,
    ROUND(SUM(p.price * o.quantity), 2) AS total_spent
  FROM customers c
  LEFT JOIN orders o ON c.id = o.customer_id
  LEFT JOIN products p ON o.product_id = p.id
  GROUP BY c.id, c.name, c.city
)
SELECT
  name, city, total_orders, total_spent,
  CASE
    WHEN total_spent > 1000 THEN 'VIP'
    WHEN total_spent BETWEEN 500 AND 1000 THEN 'Regular'
    WHEN total_spent > 0 THEN 'New'
    ELSE 'Inactive'
  END AS loyalty
FROM customer_totals
ORDER BY total_spent DESC;

-- ================================================
-- QUERY 4: Best Selling Categories
-- Skills: JOIN, GROUP BY, SUM, COUNT, ORDER BY
-- ================================================
SELECT
  p.category,
  COUNT(o.id) AS total_orders,
  SUM(o.quantity) AS units_sold,
  ROUND(SUM(p.price * o.quantity), 2) AS revenue
FROM orders o
JOIN products p ON o.product_id = p.id
GROUP BY p.category
ORDER BY revenue DESC;
