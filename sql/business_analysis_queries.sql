use ecommerce;

select top 10 *
from ecommerce_analytics;

/* ============================================================
   E-COMMERCE ANALYTICS — BUSINESS ANALYSIS QUERIES (INDIA)
   Dataset : ecommerce_analytics (India-cleaned flat table)
   ============================================================ */


/* ============================================================
   SECTION 1: DATA VALIDATION & SANITY CHECKS
   ============================================================ */

-- 1. Row Count Check
SELECT COUNT(*) AS total_rows
FROM ecommerce_analytics;


-- 2. Total Revenue Validation
SELECT 
    SUM(total_price) AS total_revenue
FROM ecommerce_analytics;


-- 3. Date Range Validation
SELECT 
    MIN([date]) AS min_date,
    MAX([date]) AS max_date
FROM ecommerce_analytics;


-- 4. Null Safety Check (Critical Columns)
SELECT
    SUM(CASE WHEN payment_key IS NULL THEN 1 ELSE 0 END) AS payment_key_nulls,
    SUM(CASE WHEN customer_key IS NULL THEN 1 ELSE 0 END) AS customer_key_nulls,
    SUM(CASE WHEN total_price IS NULL THEN 1 ELSE 0 END) AS revenue_nulls
FROM ecommerce_analytics;


/* ============================================================
   SECTION 2: CORE BUSINESS KPIs
   ============================================================ */

-- 5. Total Customers
SELECT 
    COUNT(DISTINCT customer_key) AS total_customers
FROM ecommerce_analytics;


-- 6. Total Sales Records
SELECT 
    COUNT(*) AS total_sales_records
FROM ecommerce_analytics;


/* ============================================================
   SECTION 3: TIME-BASED ANALYSIS
   ============================================================ */

-- 7. Yearly Revenue Trend
SELECT 
    year,
    SUM(total_price) AS yearly_revenue
FROM ecommerce_analytics
GROUP BY year
ORDER BY year;


-- 8. Monthly Revenue by Year
SELECT 
    year,
    month,
    SUM(total_price) AS monthly_revenue
FROM ecommerce_analytics
GROUP BY year, month
ORDER BY year, month;


/* ============================================================
   SECTION 4: PRODUCT ANALYSIS
   ============================================================ */

-- 9. Top 10 Products by Revenue
SELECT TOP 10
    item_name,
    SUM(total_price) AS total_revenue
FROM ecommerce_analytics
GROUP BY item_name
ORDER BY total_revenue DESC;


-- 10. Quantity vs Revenue (Top Products)
SELECT TOP 10
    item_name,
    SUM(quantity) AS total_quantity,
    SUM(total_price) AS total_revenue
FROM ecommerce_analytics
GROUP BY item_name
ORDER BY total_revenue DESC;


/* ============================================================
   SECTION 5: CUSTOMER ANALYSIS
   ============================================================ */

-- 11. Top 10 Customers by Revenue
SELECT TOP 10
    customer_key,
    SUM(total_price) AS customer_revenue
FROM ecommerce_analytics
GROUP BY customer_key
ORDER BY customer_revenue DESC;


-- 12. Most Frequent Customers
SELECT TOP 10
    customer_key,
    COUNT(*) AS purchase_frequency
FROM ecommerce_analytics
GROUP BY customer_key
ORDER BY purchase_frequency DESC;


-- 13. Average Revenue per Customer
SELECT 
    SUM(total_price) * 1.0 
        / COUNT(DISTINCT customer_key) AS avg_revenue_per_customer
FROM ecommerce_analytics;


/* ============================================================
   SECTION 6: GEOGRAPHICAL ANALYSIS 
   ============================================================ */

-- 14. Revenue by Region
SELECT
    region,
    SUM(total_price) AS region_revenue
FROM ecommerce_analytics
GROUP BY region
ORDER BY region_revenue DESC;


-- 15. Revenue by State (Top 10)
SELECT TOP 10
    state,
    SUM(total_price) AS state_revenue
FROM ecommerce_analytics
GROUP BY state
ORDER BY state_revenue DESC;


-- 16. Top 10 Performing Stores
SELECT TOP 10
    store_key,
    SUM(total_price) AS store_revenue
FROM ecommerce_analytics
GROUP BY store_key
ORDER BY store_revenue DESC;


/* ============================================================
   SECTION 7: ADVANCED 
   ============================================================ */

-- 17. Revenue Contribution by Region (%)
SELECT
    region,
    SUM(total_price) AS region_revenue,
    SUM(total_price) * 100.0 
        / SUM(SUM(total_price)) OVER () AS revenue_percentage
FROM ecommerce_analytics
GROUP BY region
ORDER BY region_revenue DESC;


-- 18. Year-over-Year Revenue Growth
SELECT
    year,
    SUM(total_price) AS yearly_revenue,
    SUM(total_price)
      - LAG(SUM(total_price)) OVER (ORDER BY year) AS yoy_revenue_change
FROM ecommerce_analytics
GROUP BY year
ORDER BY year;
