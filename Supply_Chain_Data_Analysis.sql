-- =====================================
-- Task 1  Create Database and Table
-- =====================================

CREATE DATABASE supplychain_db;
USE supplychain_db;

CREATE TABLE supply (
	Product_type VARCHAR (50),
    SKU VARCHAR (50),
    Price DECIMAL(10,2),
    Availability INT,
    Number_of_Sold INT,
    Revenue DECIMAL(10,2),
    Customer_gender VARCHAR(50),
    Stock_level INT,
    Procurement_Lead_time INT,
    Order_quantities INT,
    Shipping_times INT,
    Shipping_carriers varchar(50),
    Shipping_costs DECIMAL(10,2),
    Supplier_Name VARCHAR(50),
    Location VARCHAR(50),
	Supplier_Lead_time INT,
    Production_volumes INT,
    Manufacturing_lead_time INT,
	Manufacturing_costs DECIMAL(10,2),
    Inspection_results VARCHAR(50),
    Defect_dates DECIMAL(10,2),
    Transportation_models VARCHAR(50),
    Routes VARCHAR(50),
    Logistics_Cost DECIMAL(10,2)
);
-- =====================================
-- Task 2  Check Tables 
-- =====================================
    USE supplychain_db;
    Select count(*) as Total_rows From supply;
-- =====================================
-- Inventory Analysis: 1. Which product categories have the highest inventory levels?
-- =====================================
    Select Product_type, sum(stock_level) as total_Inventory From supply
    Group by Product_type
    Order by Total_Inventory desc;
-- haircare have the highest inventory levels.

-- =====================================
-- 2. Which SKUs are at risk of stock shortages based on current inventory and order quantities?
-- =====================================
Select * FROM (
	SELECT
		sku,
		availability,
		stock_level,
		order_quantities,
    
	CASE
		WHEN stock_level <= order_quantities 
		AND availability <= stock_level 
        THEN 'Shortage Risk'
        ELSE 'Sufficient Stock'
    END AS inventory_status
FROM supply
)t
Where inventory_status = 'shortage Risk';
-- =====================================
-- 3. What is the average inventory level by product category, supplier, and location?
-- =====================================
Select product_type,Supplier_name, Location, avg(stock_level) as average_inventory_level  From supply
Group by product_type, supplier_name, location 
Order by average_inventory_level DESC;
-- =====================================
-- Supplier Performance Analysis: 1. Which suppliers provide the largest number of products?
-- =====================================
SELECT Supplier_name, count(distinct SKU) as number_of_products from supply
Group by supplier_name
Order by number_of_products DESC;
-- Supplier 1 have the largets number of products.

-- =====================================
-- 2. Which suppliers have the longest average lead times?
-- =====================================
SELECT Supplier_name, avg(supplier_lead_time) as average_lead_time from supply
Group by supplier_name
order by average_lead_time desc; 
-- Supplier 3 have the longest average lead times.

-- =====================================
-- 3. Which suppliers have the highest defect rates?
-- =====================================
SELECT Supplier_name, avg(defect_dates) as average_defect_rate from supply
Group by Supplier_name
order by average_defect_rate desc; 
-- Supplier 5 have the highest average defect rates.

-- =====================================
-- 4. Which suppliers contribute the most revenue?
-- =====================================
SELECT Supplier_name, sum(revenue) as total_revenue from supply
Group by Supplier_name
order by total_revenue desc; 
-- Supplier 1 contribute the most revenue.

-- =====================================
-- 5. Which suppliers offer the best balance between lead time, cost, and quality?
-- =====================================
SELECT *
FROM (
    SELECT
        supplier_name,
        AVG(manufacturing_lead_time) AS avg_lead_time,
        AVG(manufacturing_costs) AS avg_cost,
        AVG(defect_dates) AS avg_defect_rate,
        CASE
            WHEN AVG(manufacturing_lead_time) < (SELECT AVG(manufacturing_lead_time) FROM supply)
             AND AVG(manufacturing_costs) < (SELECT AVG(manufacturing_costs) FROM supply)
             AND AVG(defect_dates) < (SELECT AVG(defect_dates) FROM supply)
            THEN 'Best Balance'
            ELSE 'Not Best Balance'
        END AS supplier_status
    FROM supply
    GROUP BY supplier_name
) t
WHERE supplier_status = 'Best Balance';
-- Supplier 1 offer the best balance between lead time, cost, and quality.alter

-- =====================================
-- Logistics & Transportation Analysis: 1. Which transportation mode has the highest average transportation cost?
-- =====================================
SELECT TransporTation_models, avg(logistics_cost) as average_logistics
From supply
Group by TransporTation_models
Order by average_logistics DESC;
-- =====================================
-- 2. Which transportation mode delivers products the fastest?
-- =====================================
SELECT TransporTation_models, round(avg(shipping_times),2) as average_time
From supply
Group by TransporTation_models
Order by average_time DESC;
-- =====================================
-- 3. How do transportation costs vary across shipping carriers?
-- =====================================
SELECT Shipping_carriers, round(avg(logistics_cost),2) as average_costs
From supply
Group by Shipping_carriers
Order by average_costs DESC;
-- =====================================
-- 4. Which routes have the longest shipping times?
-- =====================================
SELECT routes, round(avg(shipping_times),2) as average_time
From supply
Group by routes
Order by average_time DESC;
-- =====================================
-- 5. What is the transportation cost per unit shipped for each transportation mode?
-- =====================================
SELECT transportation_models , round(sum(logistics_cost),2)/sum(number_of_sold)  as Transportation_cost_per_units 
From supply
Group by transportation_models
Order by Transportation_cost_per_units  DESC;

-- =====================================
--  Revenue & Profitability Analysis: 1. Which product categories generate the highest revenue?
-- =====================================
SELECT Product_type , sum(revenue) as total_revenue
From supply
Group by Product_type
Order by  total_revenue DESC;

-- =====================================
--  2. Which products generate the highest profit?
-- =====================================
SELECT Product_type , sum(revenue) - sum(shipping_costs) - sum(manufacturing_costs) - sum(logistics_cost) as Estimated_total_Profit
From supply
Group by Product_type
Order by Estimated_total_Profit DESC;
-- =====================================
--  3. Which suppliers contribute the highest profit margins?
-- =====================================
SELECT Supplier_Name , (sum(revenue) - sum(shipping_costs) - sum(manufacturing_costs) - sum(logistics_cost))/SUM(revenue)  as Estimated_Profit_Margin
From supply
Group by Supplier_Name
Order by Estimated_Profit_Margin DESC;
-- =====================================
--  4. Which geographic locations generate the highest revenue?
-- =====================================
SELECT Location, sum(revenue) as total_revenue
From supply
Group by Location
Order by total_revenue DESC;

-- =====================================
--  Manufacturing & Operations Analysis: 1. Which products have the longest manufacturing lead times?
-- =====================================
SELECT Product_type, avg(Manufacturing_lead_time) as manufacturing_lead_time
From supply
Group by Product_type
Order by manufacturing_lead_time DESC;
-- =====================================
-- 2. Is there a relationship between manufacturing lead time and defect rate?
-- =====================================
SELECT Product_type, avg(Manufacturing_lead_time) as manufacturing_lead_time, avg(defect_dates) as average_defect
From supply
Group by Product_type
Order by manufacturing_lead_time DESC;
-- Manufacturing lead time has a positive relationship with defect rates.

-- =====================================
-- 3. Which product categories have the highest defect rates?
-- =====================================
SELECT Product_type, avg(defect_dates) as average_defect
From supply
Group by Product_type
Order by average_defect DESC;
-- =====================================
-- 4. How does production volume vary across product categories?
-- =====================================
SELECT Product_type, sum(Production_volumes) as total_volumes
From supply
Group by Product_type
Order by total_volumes DESC;
