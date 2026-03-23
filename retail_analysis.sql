-- ============================================================
--  RETAIL STORE DATA ANALYSIS - SQL SCRIPTS
--  Dataset: retail_sales_data.csv (5,000 orders, 2023-2024)
--  Compatible with: SQLite / PostgreSQL / MySQL
-- ============================================================

-- ─────────────────────────────────────────────────────────────
-- SECTION 1: DATABASE SETUP (SQLite example)
-- ─────────────────────────────────────────────────────────────

-- Create main sales table
CREATE TABLE IF NOT EXISTS retail_sales (
    Order_ID         TEXT PRIMARY KEY,
    Order_Date       DATE,
    Year             INTEGER,
    Month            INTEGER,
    Quarter          TEXT,
    Region           TEXT,
    State            TEXT,
    Customer_Segment TEXT,
    Category         TEXT,
    Product_Name     TEXT,
    Quantity         INTEGER,
    Unit_Price       REAL,
    Unit_Cost        REAL,
    Discount         REAL,
    Sales            REAL,
    Cost             REAL,
    Profit           REAL,
    Profit_Margin    REAL
);

-- Load CSV (SQLite CLI):  .mode csv
--                         .import retail_sales_data.csv retail_sales


-- ─────────────────────────────────────────────────────────────
-- SECTION 2: TOP PERFORMING PRODUCTS
-- ─────────────────────────────────────────────────────────────

-- 2a. Top 10 Products by Total Revenue
SELECT
    Product_Name,
    Category,
    COUNT(Order_ID)            AS Total_Orders,
    SUM(Quantity)              AS Units_Sold,
    ROUND(SUM(Sales), 2)       AS Total_Revenue,
    ROUND(SUM(Profit), 2)      AS Total_Profit,
    ROUND(AVG(Profit_Margin),2)AS Avg_Margin_Pct
FROM retail_sales
GROUP BY Product_Name, Category
ORDER BY Total_Revenue DESC
LIMIT 10;

-- 2b. Top 10 Products by Profitability
SELECT
    Product_Name,
    Category,
    ROUND(SUM(Profit), 2)       AS Total_Profit,
    ROUND(AVG(Profit_Margin),2) AS Avg_Margin_Pct,
    ROUND(SUM(Sales), 2)        AS Total_Revenue
FROM retail_sales
GROUP BY Product_Name, Category
ORDER BY Total_Profit DESC
LIMIT 10;

-- 2c. Category Performance Summary
SELECT
    Category,
    COUNT(Order_ID)              AS Orders,
    SUM(Quantity)                AS Units_Sold,
    ROUND(SUM(Sales), 2)         AS Revenue,
    ROUND(SUM(Profit), 2)        AS Profit,
    ROUND(AVG(Profit_Margin), 2) AS Avg_Margin_Pct,
    ROUND(SUM(Profit)*100.0 / SUM(Sales), 2) AS Profit_Pct
FROM retail_sales
GROUP BY Category
ORDER BY Revenue DESC;

-- 2d. Products with High Discount but Low Profit (problem SKUs)
SELECT
    Product_Name,
    Category,
    ROUND(AVG(Discount)*100, 1) AS Avg_Discount_Pct,
    ROUND(AVG(Profit_Margin),2) AS Avg_Margin_Pct,
    COUNT(Order_ID)             AS Orders
FROM retail_sales
GROUP BY Product_Name, Category
HAVING Avg_Discount_Pct > 15 AND Avg_Margin_Pct < 20
ORDER BY Avg_Discount_Pct DESC;


-- ─────────────────────────────────────────────────────────────
-- SECTION 3: REGIONAL SALES COMPARISON
-- ─────────────────────────────────────────────────────────────

-- 3a. Revenue & Profit by Region
SELECT
    Region,
    COUNT(Order_ID)              AS Orders,
    ROUND(SUM(Sales), 2)         AS Revenue,
    ROUND(SUM(Profit), 2)        AS Profit,
    ROUND(AVG(Profit_Margin), 2) AS Avg_Margin_Pct,
    ROUND(SUM(Sales)*1.0 / COUNT(Order_ID), 2) AS Avg_Order_Value
FROM retail_sales
GROUP BY Region
ORDER BY Revenue DESC;

-- 3b. Year-over-Year Regional Growth
SELECT
    Region,
    Year,
    ROUND(SUM(Sales), 2)   AS Revenue,
    ROUND(SUM(Profit), 2)  AS Profit,
    COUNT(Order_ID)        AS Orders
FROM retail_sales
GROUP BY Region, Year
ORDER BY Region, Year;

-- 3c. Top States by Revenue
SELECT
    State,
    Region,
    COUNT(Order_ID)        AS Orders,
    ROUND(SUM(Sales), 2)   AS Revenue,
    ROUND(SUM(Profit), 2)  AS Profit
FROM retail_sales
GROUP BY State, Region
ORDER BY Revenue DESC
LIMIT 15;

-- 3d. Regional Category Mix (which categories dominate each region)
SELECT
    Region,
    Category,
    ROUND(SUM(Sales), 2)   AS Revenue,
    ROUND(SUM(Sales)*100.0 / SUM(SUM(Sales)) OVER (PARTITION BY Region), 1) AS Revenue_Share_Pct
FROM retail_sales
GROUP BY Region, Category
ORDER BY Region, Revenue DESC;

-- 3e. Quarterly Revenue Trend by Region
SELECT
    Region,
    Year,
    Quarter,
    ROUND(SUM(Sales), 2)  AS Revenue,
    ROUND(SUM(Profit), 2) AS Profit
FROM retail_sales
GROUP BY Region, Year, Quarter
ORDER BY Region, Year, Quarter;


-- ─────────────────────────────────────────────────────────────
-- SECTION 4: PROFIT vs REVENUE ANALYSIS
-- ─────────────────────────────────────────────────────────────

-- 4a. Overall P&L Summary
SELECT
    ROUND(SUM(Sales), 2)                           AS Total_Revenue,
    ROUND(SUM(Cost), 2)                            AS Total_Cost,
    ROUND(SUM(Profit), 2)                          AS Total_Profit,
    ROUND(SUM(Profit)*100.0 / SUM(Sales), 2)       AS Overall_Margin_Pct,
    COUNT(Order_ID)                                AS Total_Orders,
    ROUND(SUM(Sales)*1.0 / COUNT(Order_ID), 2)     AS Avg_Order_Value
FROM retail_sales;

-- 4b. Monthly Revenue vs Profit Trend
SELECT
    Year,
    Month,
    ROUND(SUM(Sales), 2)                         AS Revenue,
    ROUND(SUM(Cost), 2)                          AS Cost,
    ROUND(SUM(Profit), 2)                        AS Profit,
    ROUND(SUM(Profit)*100.0 / SUM(Sales), 2)     AS Margin_Pct
FROM retail_sales
GROUP BY Year, Month
ORDER BY Year, Month;

-- 4c. Discount Impact on Profit Margin
SELECT
    CASE
        WHEN Discount = 0        THEN '0% - No Discount'
        WHEN Discount <= 0.10    THEN '1-10% Discount'
        WHEN Discount <= 0.20    THEN '11-20% Discount'
        ELSE '21%+ Discount'
    END                                           AS Discount_Band,
    COUNT(Order_ID)                               AS Orders,
    ROUND(SUM(Sales), 2)                          AS Revenue,
    ROUND(SUM(Profit), 2)                         AS Profit,
    ROUND(AVG(Profit_Margin), 2)                  AS Avg_Margin_Pct
FROM retail_sales
GROUP BY Discount_Band
ORDER BY Avg_Margin_Pct DESC;

-- 4d. Profit Margin by Category (with revenue context)
SELECT
    Category,
    ROUND(SUM(Sales), 2)                           AS Revenue,
    ROUND(SUM(Profit), 2)                          AS Profit,
    ROUND(AVG(Profit_Margin), 2)                   AS Avg_Margin_Pct,
    ROUND(SUM(Profit)*100.0 / (SELECT SUM(Profit) FROM retail_sales), 1) AS Profit_Share_Pct
FROM retail_sales
GROUP BY Category
ORDER BY Avg_Margin_Pct DESC;

-- 4e. High Revenue Low Margin Orders (Revenue quality check)
SELECT
    Order_ID,
    Product_Name,
    Region,
    Sales,
    Profit,
    Profit_Margin,
    Discount
FROM retail_sales
WHERE Sales > 1000 AND Profit_Margin < 15
ORDER BY Sales DESC
LIMIT 20;


-- ─────────────────────────────────────────────────────────────
-- SECTION 5: CUSTOMER SEGMENT ANALYSIS
-- ─────────────────────────────────────────────────────────────

-- 5a. Segment Overview
SELECT
    Customer_Segment,
    COUNT(Order_ID)                                AS Orders,
    ROUND(SUM(Sales), 2)                           AS Revenue,
    ROUND(SUM(Profit), 2)                          AS Profit,
    ROUND(AVG(Profit_Margin), 2)                   AS Avg_Margin_Pct,
    ROUND(SUM(Sales)*1.0 / COUNT(Order_ID), 2)     AS Avg_Order_Value,
    ROUND(SUM(Sales)*100.0 / (SELECT SUM(Sales) FROM retail_sales), 1) AS Revenue_Share_Pct
FROM retail_sales
GROUP BY Customer_Segment
ORDER BY Revenue DESC;

-- 5b. Segment x Category Cross-Analysis
SELECT
    Customer_Segment,
    Category,
    ROUND(SUM(Sales), 2)  AS Revenue,
    ROUND(SUM(Profit), 2) AS Profit,
    COUNT(Order_ID)       AS Orders
FROM retail_sales
GROUP BY Customer_Segment, Category
ORDER BY Customer_Segment, Revenue DESC;

-- 5c. Segment x Region Matrix
SELECT
    Customer_Segment,
    Region,
    ROUND(SUM(Sales), 2)  AS Revenue,
    COUNT(Order_ID)       AS Orders
FROM retail_sales
GROUP BY Customer_Segment, Region
ORDER BY Customer_Segment, Revenue DESC;

-- 5d. Segment Discount Behaviour
SELECT
    Customer_Segment,
    ROUND(AVG(Discount)*100, 1)    AS Avg_Discount_Pct,
    ROUND(AVG(Quantity), 1)        AS Avg_Units_Per_Order,
    ROUND(AVG(Sales), 2)           AS Avg_Order_Value,
    ROUND(AVG(Profit_Margin), 2)   AS Avg_Margin_Pct
FROM retail_sales
GROUP BY Customer_Segment;

-- 5e. Segment Revenue Trend (Year x Quarter)
SELECT
    Customer_Segment,
    Year,
    Quarter,
    ROUND(SUM(Sales), 2)  AS Revenue,
    COUNT(Order_ID)       AS Orders
FROM retail_sales
GROUP BY Customer_Segment, Year, Quarter
ORDER BY Customer_Segment, Year, Quarter;


-- ─────────────────────────────────────────────────────────────
-- SECTION 6: EXECUTIVE KPI SUMMARY VIEW
-- ─────────────────────────────────────────────────────────────

CREATE VIEW IF NOT EXISTS vw_kpi_summary AS
SELECT
    Year,
    ROUND(SUM(Sales), 2)                       AS Total_Revenue,
    ROUND(SUM(Profit), 2)                      AS Total_Profit,
    ROUND(SUM(Profit)*100.0/SUM(Sales), 2)     AS Margin_Pct,
    COUNT(Order_ID)                            AS Total_Orders,
    ROUND(AVG(Sales), 2)                       AS Avg_Order_Value,
    ROUND(AVG(Discount)*100, 2)                AS Avg_Discount_Pct
FROM retail_sales
GROUP BY Year;

SELECT * FROM vw_kpi_summary;

-- ─────────────────────────────────────────────────────────────
-- END OF SCRIPT
-- ─────────────────────────────────────────────────────────────
