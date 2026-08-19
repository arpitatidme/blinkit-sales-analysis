-- Blinkit Sales Analysis
-- Database: blinkit_db
-- Table: blinkit_sales

-- 1. Overall KPIs
SELECT SUM(sales) AS total_sales,
       AVG(sales) AS avg_sales,
       COUNT(*) AS number_of_records,
       COUNT(DISTINCT outlet_identifier) AS number_of_outlets,
       AVG(rating) AS average_rating
FROM blinkit_sales;

-- 2. Sales by Item Type
SELECT item_type,
       SUM(sales) AS total_sales,
       AVG(sales) AS avg_sales,
       COUNT(*) AS item_count
FROM blinkit_sales
GROUP BY item_type
ORDER BY total_sales DESC;

-- 3. Sales by Outlet Type
SELECT outlet_type,
       SUM(sales) AS total_sales,
       AVG(sales) AS avg_sales,
       COUNT(*) AS records
FROM blinkit_sales
GROUP BY outlet_type
ORDER BY total_sales DESC;

-- 4. Sales by Location and Size
SELECT outlet_location_type, SUM(sales) AS total_sales, AVG(sales) AS avg_sales, COUNT(*) AS records
FROM blinkit_sales
GROUP BY outlet_location_type
ORDER BY total_sales DESC;

SELECT outlet_size, SUM(sales) AS total_sales, AVG(sales) AS avg_sales, COUNT(*) AS records
FROM blinkit_sales
GROUP BY outlet_size
ORDER BY total_sales DESC;

-- 5. Sales by Fat Content and Establishment Year
SELECT item_fat_content, SUM(sales) AS total_sales, AVG(sales) AS avg_sales, COUNT(*) AS records
FROM blinkit_sales
GROUP BY item_fat_content
ORDER BY total_sales DESC;

SELECT outlet_establishment_year, SUM(sales) AS total_sales, AVG(sales) AS avg_sales, COUNT(*) AS records
FROM blinkit_sales
GROUP BY outlet_establishment_year
ORDER BY outlet_establishment_year;

-- 6. Correlation checks
SELECT CORR(item_visibility, sales) AS visibility_sales_correlation
FROM blinkit_sales;

SELECT CORR(rating, sales) AS rating_sales_correlation
FROM blinkit_sales;

-- 7. Rank item types within each outlet type
WITH item_type_sales AS (
    SELECT outlet_type, item_type, SUM(sales) AS total_sales
    FROM blinkit_sales
    GROUP BY outlet_type, item_type
)
SELECT outlet_type, item_type,
       ROUND(total_sales, 2) AS total_sales,
       RANK() OVER (PARTITION BY outlet_type ORDER BY total_sales DESC) AS sales_rank
FROM item_type_sales
ORDER BY outlet_type, sales_rank;

-- 8. Outlet sales contribution to total company sales
WITH outlet_sales AS (
    SELECT outlet_identifier, outlet_type, SUM(sales) AS total_sales
    FROM blinkit_sales
    GROUP BY outlet_identifier, outlet_type
)
SELECT outlet_identifier, outlet_type,
       ROUND(total_sales, 2) AS total_sales,
       ROUND(100 * total_sales / SUM(total_sales) OVER (), 2) AS sales_contribution_pct
FROM outlet_sales
ORDER BY total_sales DESC;
