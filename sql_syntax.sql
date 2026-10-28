
-- 1. Create Database
CREATE DATABASE SalesDatabase

USE SalesDatabase
--2. create table
CREATE TABLE ProductSales (
		Date DATE,
		Region VARCHAR(50),
		ProductName VARCHAR(50),
		Quantity INT,
		UnitPrice DECIMAL(10, 2),
		Store VARCHAR(50),
		CustomerType VARCHAR(50),
		DiscountRate DECIMAL(5, 2),
		SalesPerson VARCHAR(50),
		TotalPrice DECIMAL(15, 2),
		PaymentMethod VARCHAR(50),
		Promotion VARCHAR(50),
		Returned INT,
		OrderID VARCHAR(50)NOT NULL PRIMARY KEY,
		CustomerID VARCHAR(50) NOT NULL,
		ShippingCost DECIMAL(10, 2),
		OrderDate DATE NOT NULL,
		DeliveryDate DATE,
		RegionManager VARCHAR(50)
		)

ALTER TABLE ProductSales
ALTER COLUMN SalesPerson VARCHAR(50)

-- Load Data from CSV in to the table

BULK INSERT ProductSales 
FROM 'C:\Data\Product-Sales-Region.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
	)
SELECT *
FROM ProductSales

-- ==================================================
--               Missing value check
-- ==================================================

SELECT 
	COUNT(*) AS TotalOrders,
	SUM(CASE WHEN OrderID IS NULL THEN 1 ELSE 0 END) AS Missing_Order_ID,
	SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS Missing_customer_ID,
	SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS Missing_Region,
	SUM(CASE WHEN ProductName IS NULL THEN 1 ELSE 0 END) AS Missing_Product_Name,
	SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS Missing_Order_Date,
	SUM(CASE WHEN DeliveryDate IS NULL THEN 1 ELSE 0 END) AS Missing_deliveryDate,
	SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Missing_Quantity,
	SUM(CASE WHEN Promotion IS NULL THEN 1 ELSE 0 END) AS Missing_promotion,
	SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) AS Missing_unit_price,
	SUM(CASE WHEN NetSales IS NULL THEN 1 ELSE 0 END) AS Missing_Net_Sales
FROM ProductSales

-- ==================================================
--            Replace Null values
-- ==================================================
UPDATE ProductSales
SET Promotion = 'No promotion'
WHERE Promotion IS NULL

-- ==================================================
--           Duplicate Record Check
-- ==================================================
SELECT OrderID,
		COUNT(*) AS Number_of_duplicates
FROM ProductSales
GROUP BY OrderID
HAVING COUNT(*) > 1

SELECT *
FROM ProductSales

-- ==================================================
--        Numerical value Validation
-- ==================================================

SELECT *
FROM ProductSales
WHERE Quantity <= 0
 
SELECT *
FROM ProductSales
WHERE UnitPrice < 0

SELECT *
FROM ProductSales
WHERE NetSales < 0

SELECT *
FROM ProductSales
WHERE DiscountRate < 0

SELECT *
FROM ProductSales
WHERE ShippingCost < 0

-- ==================================================
--        Categorial value Validation
-- ==================================================

SELECT DISTINCT Region
FROM ProductSales
ORDER BY Region

SELECT DISTINCT ProductName
FROM ProductSales
ORDER BY ProductName

SELECT DISTINCT Store
FROM ProductSales
ORDER BY Store

SELECT DISTINCT PaymentMethod
FROM ProductSales
ORDER BY PaymentMethod

SELECT DISTINCT CustomerType
FROM ProductSales
ORDER BY CustomerType

SELECT DISTINCT SalesPerson
FROM ProductSales
ORDER BY SalesPerson

SELECT DISTINCT Promotion
FROM ProductSales
ORDER BY Promotion

SELECT DISTINCT RegionManager
FROM ProductSales
ORDER BY RegionManager

SELECT
	COUNT(DISTINCT Region) AS UniqueRegions,
	COUNT(DISTINCT ProductName) AS UniqueProducts,
	COUNT(DISTINCT Store) AS UniqueStore,
	COUNT(DISTINCT CustomerType) AS UniqueCustomer,
	COUNT(DISTINCT SalesPerson) AS UniqueSalesPerson,
	COUNT(DISTINCT PaymentMethod) AS UniquePaymentMethod,
	COUNT(DISTINCT Promotion) AS UniquePromotion,
	COUNT(DISTINCT RegionManager) AS UniqueRegionManager
FROM ProductSales

-- ==================================================
--        Date value Validation
-- ==================================================
SELECT COUNT(*) AS Differnt_Dates
FROM ProductSales
WHERE Date <> OrderDate
	OR Date IS NULL
	OR OrderDate IS NULL

SELECT MAX(Date) AS Max_Date, MIN(Date) AS Min_Date,
		MAX(OrderDate) AS Max_order_date, MIN(OrderDate) AS Min_order_date
FROM ProductSales

ALTER TABLE ProductSales
DROP COLUMN Date

SELECT
	OrderID,
	OrderDate,
	DeliveryDate
FROM ProductSales
WHERE DeliveryDate < OrderDate

SELECT *
FROM ProductSales
WHERE OrderDate > GETDATE() OR DeliveryDate > GETDATE()

SELECT OrderID,
		DATEDIFF(Day, OrderDate, DeliveryDate) as DeliveyDays
FROM ProductSales
WHERE DATEDIFF(Day, OrderDate, DeliveryDate) < 0

EXEC sp_rename 'ProductSales.TotalPrice', 'NetSales', 'COLUMN'

-- ==================================================
--        Exploratory and business analysis
-- ==================================================
-- Explore overall KPIs

SELECT  COUNT(*) AS Total_Orders,
		SUM(NetSales) AS Total_Net_Revenue,
		COUNT(DISTINCT CustomerID) AS Number_Customers,
		SUM(Quantity) AS Total_units_sold,
		SUM(ShippingCost) AS Total_shipping_cost,
		CAST(SUM(ShippingCost)/NULLIF(SUM(NetSales), 0) AS DECIMAL(10,2)) AS shipping_cost_rate,
		SUM(Returned) as number_of_returns,
		CAST(AVG(CAST(Returned AS DECIMAL(10,2)))*100 AS DECIMAL(10,2)) AS Return_rate_percentage,
		CAST(SUM(NetSales)/COUNT(*) AS DECIMAL(10,2)) AS Average_order_value,
	    AVG(DATEDIFF(Day, OrderDate, DeliveryDate)) AS Average_delivery_days,
		MAX(DATEDIFF(Day, OrderDate, DeliveryDate)) AS Max_delivery_days,
		MIN(DATEDIFF(Day, OrderDate, DeliveryDate)) AS Min_delivery_days
FROM ProductSales

-- ============================================================
--            REGIONAL SALES PERFORMANCE
-- ============================================================

-- Calculate total revenue generated and total units sold by each region.
-- The results are sorted from highest to lowest revenue
-- to identify the strongest and weakest-performing regions.

SELECT Region, SUM(Netsales) AS Total_Net_Revenue,
		SUM(Quantity) AS Total_units_sold,
		COUNT(*) AS Total_Orders,
		CAST(SUM(Netsales)/NULLIF(COUNT(*), 0) AS DECIMAL(10,2)) AS Average_order_value,
		CAST(SUM(Quantity*UnitPrice*DiscountRate) AS DECIMAL (10,2)) AS Dicount_Money,
		SUM(ShippingCost) AS Total_shipping_cost,
		CAST(SUM(ShippingCost)/SUM(NetSales)*100 AS DECIMAL(10, 2)) AS Shipping_cost_rate,
		SUM(Returned) AS Number_of_returns,
		CAST(SUM(Returned)*100/NULLIF(COUNT(*), 0) AS DECIMAL(10,2)) AS Return_Rate
FROM ProductSales
GROUP BY Region
Order BY Total_Net_Revenue DESC

-- ============================================================
--    PRODUCT PERFORMANCE ANALYSIS
-- ============================================================

-- Identify the products with the highest sales volume and the products generating the highest revenue.

SELECT ProductName, COUNT(DISTINCT OrderID) AS total_orders,
		SUM(NetSales) AS Total_Net_Revenue,
		SUM(Quantity) as total_units_sold,
		CAST(SUM(NetSales)/NULLIF(COUNT(DISTINCT OrderID), 0) AS DECIMAL(10, 2)) AS Average_order_value,
		SUM(ShippingCost) AS Total_shipping_cost,
		CAST(SUM(ShippingCost)/NULLIF(SUM(NetSales), 0)*100 AS DECIMAL(10, 2)) AS Shipping_cost_rate,
		CAST(SUM(Quantity*UnitPrice * DiscountRate) AS DECIMAL(10,2)) AS Discount_Money,
		SUM(CASE WHEN Returned =1 THEN 1 ELSE 0 END) AS Number_of_returns,
		CAST(SUM(Returned)*100/NULLIF(COUNT(DISTINCT OrderID), 0) AS DECIMAL(10,2)) AS Percentage_returns
FROM ProductSales
GROUP BY ProductName
ORDER BY Total_Net_Revenue DESC

-- ============================================================
--    Customer PERFORMANCE ANALYSIS
-- ============================================================

SELECT CustomerType, COUNT(DISTINCT OrderID) AS Total_orders,
		SUM(NetSales) AS Total_net_revenue,
		SUM(Quantity) AS Total_units_sold,
		SUM(ShippingCost) AS Total_shipping_cost,
		CAST(SUM(Quantity * UnitPrice * DiscountRate) AS DECIMAL(10, 2)) AS discount_money,
		CAST(SUM(NetSales)/NULLIF(COUNT(DISTINCT OrderID),0) AS DECIMAL(10,2)) AS Average_Order_value,
		SUM(Returned) as Number_of_returns,
		AVG(Returned *100) AS Percentage_returns,
		CAST(SUM(Returned)*100/NULLIF(COUNT(DISTINCT OrderID), 0) AS DECIMAL(10,2)) AS Percent_Return
FROM ProductSales
GROUP BY CustomerType


SELECT  CustomerID, COUNT(DISTINCT OrderID) AS Total_orders,
		SUM(NetSales) AS Total_net_revenue,
		SUM(Quantity) AS Total_units_sold,
		SUM(ShippingCost) AS Total_shipping_cost,
		CAST(SUM(NetSales)/NULLIF(COUNT(DISTINCT OrderID), 0) AS Decimal(10,2)) AS Average_Order_Value,
		CAST(SUM(Quantity * UnitPrice * DiscountRate) AS DECIMAL(10, 2)) AS discount_money,
		SUM(Returned) as Number_of_returns,
		CAST(SUM(Returned)*100/NULLIF(COUNT(DISTINCT OrderID), 0) AS DECIMAL(10,2)) AS Percentage_return,
		Max(OrderDate) AS Latest_Order,
		MIN(OrderDate) AS First_Order
FROM ProductSales
GROUP BY CustomerID
HAVING COUNT(DISTINCT OrderID) = SUM(Returned) 
ORDER BY Total_net_revenue DESC

-- Customers with 100% return rate

With Customer_Returns AS (SELECT CustomerID,
		COUNT(DISTINCT OrderID) AS Total_Orders,
		SUM(NetSales) AS Total_Net_Sales,
		SUM(Returned) AS Total_returns
FROM ProductSales
GROUP BY CustomerID)
SELECT COUNT(CustomerID) AS Number_of_customers,
		SUM(Total_Orders) AS Total_orders,
		SUM(Total_Net_Sales) AS Total_Net_Sales,
		SUM(Total_returns) AS Total_returns
FROM Customer_Returns
WHERE Total_Orders = Total_returns

-- Customers who returned more than one order
With Customer_Returns AS (SELECT CustomerID,
		COUNT(DISTINCT OrderID) AS Total_Orders,
		SUM(NetSales) AS Total_Net_Sales,
		SUM(Returned) AS Total_returns
FROM ProductSales
GROUP BY CustomerID)
SELECT COUNT(CustomerID) AS Number_of_customers,
		SUM(Total_Orders) AS Total_orders,
		SUM(Total_Net_Sales) AS Total_Net_Sales,
		SUM(Total_returns) AS Total_returns
FROM Customer_Returns
WHERE Total_returns > 1

-- Number of customers with zero return rate

With Customer_Returns AS (SELECT CustomerID,
		COUNT(DISTINCT OrderID) AS Total_Orders,
		SUM(NetSales) AS Total_Net_Sales,
		SUM(Returned) AS Total_returns
FROM ProductSales
GROUP BY CustomerID)
SELECT COUNT(CustomerID) AS Number_of_customers,
		SUM(Total_Orders) AS Total_orders,
		SUM(Total_Net_Sales) AS Total_Net_Sales,
		SUM(Total_returns) AS Total_returns,
		CAST(SUM(Total_returns)*100/NULLIF(COUNT(DISTINCT Total_orders), 0) AS DECIMAL(10,2)) AS Return_Rate
FROM Customer_Returns
WHERE Total_returns = 0

-- Sales Person Performance Analysis

SELECT SalesPerson, count(Distinct OrderID) AS Total_Orders,
		SUM(Quantity) AS Total_Units_Sold,
		SUM(NetSales) AS Total_Net_Sales,
		SUM(ShippingCost) AS Total_Shipping_cost,
		CAST(SUM(NetSales)/NULLIF(COUNT(DISTINCT OrderID), 0) AS DECIMAL(10,2)) AS Average_Order_value,
		CAST(SUM(Quantity * UnitPrice * DiscountRate) AS DECIMAL(10,2)) AS Total_discount_money,
		SUM(Returned) AS Total_Returns,
		CAST(SUM(Returned)*100.0/NULLIF(COUNT(DISTINCT OrderID), 0) AS DECIMAL(10,2)) AS Return_Rate
FROM ProductSales
GROUP BY SalesPerson
ORDER BY Total_Net_Sales DESC

-- Store performance analysis
SELECT Store, count(Distinct OrderID) AS Total_Orders,
		SUM(Quantity) AS Total_Units_Sold,
		SUM(NetSales) AS Total_Net_Sales,
		SUM(ShippingCost) AS Total_Shipping_cost,
		CAST(SUM(NetSales)/NULLIF(COUNT(DISTINCT OrderID), 0) AS DECIMAL(10,2)) AS Average_Order_value,
		CAST(SUM(Quantity * UnitPrice * DiscountRate) AS DECIMAL(10,2)) AS Total_discount_money,
		SUM(Returned) AS Total_Returns,
		CAST(SUM(Returned)*100.0/NULLIF(COUNT(DISTINCT OrderID), 0) AS DECIMAL(10,2)) AS Return_Rate
FROM ProductSales
GROUP BY Store
ORDER BY Total_Net_Sales DESC

-- Promotion Analysis
SELECT Promotion, count(Distinct OrderID) AS Total_Orders,
		SUM(Quantity) AS Total_Units_Sold,
		SUM(NetSales) AS Total_Net_Sales,
		SUM(ShippingCost) AS Total_Shipping_cost,
		CAST(SUM(NetSales)/NULLIF(COUNT(DISTINCT OrderID), 0) AS DECIMAL(10,2)) AS Average_Order_value,
		CAST(SUM(Quantity * UnitPrice * DiscountRate) AS DECIMAL(10,2)) AS Total_discount_money,
		SUM(Returned) AS Total_Returns,
		CAST(SUM(Returned)*100.0/NULLIF(COUNT(DISTINCT OrderID), 0) AS DECIMAL(10,2)) AS Return_Rate
FROM ProductSales
GROUP BY Promotion
ORDER BY Total_Net_Sales DESC

-- ============================================================
--      PRODUCTS WITH ABOVE-AVERAGE REVENUE
-- ============================================================

-- Identify products whose total revenue is greater than
-- the average revenue generated across all products.
--
-- The subquery first calculates revenue at product level.
-- The outer query then compares each product against
-- the average product revenue.

SELECT ProductName, SUM(Netsales) AS Total_Net_Revenue
FROM ProductSales
GROUP BY ProductName
HAVING SUM(Netsales) >(SELECT AVG(Total_Revenue) 
						FROM(
							SELECT ProductName, SUM(NetSales) AS Total_Revenue
							FROM ProductSales group by ProductName) AS ProductRevenue) 

-- ============================================================
--     REGIONS WITH ABOVE-AVERAGE REVENUE
-- ============================================================

-- Identify regions whose total revenue is greater than
-- the average revenue generated across all regions.

WITH Region_Revenue AS (
		SELECT Region, SUM(Netsales) AS Total_net_revenue
		FROM ProductSales
		Group BY Region
),
Average_Revenue AS (
		SELECT AVG(Total_net_revenue) AS Average_revenue
		FROM Region_Revenue
)
SELECT Region, Total_net_revenue
FROM Region_Revenue
WHERE Total_net_revenue >(SELECT Average_revenue FROM Average_Revenue)

-- ============================================================
--         HIGH-VALUE CUSTOMER ANALYSIS
-- ============================================================

-- Identify customers whose total spending exceeds the
-- average customer spending.
--
-- This can help identify potentially high-value customers
-- for retention, loyalty, or targeted marketing strategies.

WITH Customer_spending AS (
		SELECT CustomerID, SUM(NetSales) AS Total_net_revenue
		FROM ProductSales
		GROUP BY CustomerID
),
Aerage_customer_spending AS (
		SELECT AVG(Total_net_revenue) AS Average_spending
		FROM Customer_spending
)
SELECT *
FROM Customer_spending
WHERE Total_net_revenue > (SELECT Average_spending FROM Aerage_customer_spending)

-- ============================================================
--        MONTHLY REVENUE TREND
-- ============================================================

-- Calculate monthly revenue to identify changes in sales
-- performance over time.

WITH Monthly_Revenue AS (
		SELECT DATENAME(MONTH, OrderDate) AS Monthly_Sales,
				Year(OrderDate) AS Yearly_Sales,
				SUM(Netsales) AS Total_net_revenue
		FROM ProductSales
		GROUP BY DATENAME(MONTH, OrderDate), Year(OrderDate)
		)
SELECT Monthly_Sales, Yearly_Sales, Total_net_revenue
FROM Monthly_Revenue
ORDER BY Total_net_revenue DESC
-- ============================================================
--      MONTHS WITH ABOVE-AVERAGE REVENUE
-- ============================================================

-- Identify months whose total revenue is greater than
-- the average revenue generated across all months.

SELECT DATENAME(MONTH, Orderdate) AS MonthlySales, Year(OrderDate) AS Yearly_Sales,
		SUM(NetSales) AS Total_net_reveue
FROM ProductSales
GROUP BY DATENAME(MONTH, Orderdate), Year(OrderDate)
HAVING SUM(NetSales) > (SELECT AVG(Total_revenue)
						FROM(SELECT DATENAME(MONTH, Orderdate) AS Monthly_Sales, SUM(Netsales) AS Total_revenue 
							FROM ProductSales
							GROUP BY DATENAME(MONTH, Orderdate), Year(OrderDate)) t)

-- ============================================================
--      Years WITH ABOVE-AVERAGE REVENUE
-- ============================================================

-- Identify years whose total revenue is greater than
-- the average revenue generated across all years.

WITH Yearly_Sales AS (
		SELECT Year(OrderDate) AS Yearly_Sales,
				SUM(NetSales) AS Total_net_revenue
		FROM ProductSales
		GROUP BY Year(OrderDate)
),
Average_yearly_revenue AS (
		SELECT AVG(Total_net_revenue) AS Average_revenue
		FROM Yearly_Sales
)
SELECT *
FROM Yearly_Sales
WHERE Total_net_revenue > (SELECT Average_revenue FROM Average_yearly_revenue)

-- ============================================================
-- 6. PRODUCT RETURN RATE
-- ============================================================

-- Calculate the return rate for each product.
-- Products with unusually high return rates should be
-- investigated further to identify possible quality,
-- fulfillment, or customer-experience issues.

SELECT ProductName,
		COUNT(*) AS TotalOrders,
		SUM(Returned) AS Total_Returns,
		CAST(SUM(Returned)*100/COUNT(*) AS DECIMAL(10,2)) AS Return_Rate
FROM ProductSales
GROUP BY ProductName
ORDER BY Return_Rate DESC

-- ============================================================
-- 7. ORDER-TO-DELIVERY PERFORMANCE
-- ============================================================
-- Calculate the number of days between order placement
-- and delivery completion.

SELECT OrderID, OrderDate, DeliveryDate,
		DATEDIFF(DAY, OrderDate, DeliveryDate) AS Delivery_days
FROM ProductSales

-- Count orders with delivery times above the overall average.

WITH Delivery_time_above_average AS (
		SELECT OrderID,
				OrderDate,
				DeliveryDate,
				DATEDIFF(Day, OrderDate, DeliveryDate) AS DeliveryDays,
				AVG(DATEDIFF(Day, OrderDate, DeliveryDate)) OVER () AS AVGDeliveryDays,
				COUNT(OrderID) Over() AS Number_of_orders
		FROM ProductSales
)
SELECT *, SUM(CASE WHEN DeliveryDays > AVGDeliveryDays THEN 1 ELSE 0 END) OVER() AS Orders_more_than_average
from Delivery_time_above_average
WHERE DeliveryDays > AVGDeliveryDays

-- Calculate annual revenue and year-over-year growth.

WITH AnnualRevenue AS (
    SELECT
        YEAR(OrderDate) AS SalesYear,
        SUM(NetSales) AS Revenue
    FROM ProductSales
    GROUP BY YEAR(OrderDate))
SELECT
    SalesYear,
    Revenue,
    LAG(Revenue) OVER (ORDER BY SalesYear) AS PreviousYearRevenue,
    ROUND(
        (Revenue - LAG(Revenue) OVER (ORDER BY SalesYear))
        * 100.0
        / LAG(Revenue) OVER (ORDER BY SalesYear),
        2
    ) AS YoYGrowthPercent
FROM AnnualRevenue
ORDER BY SalesYear;

-- Calculate Monthly revenue and month-over-month growth.

WITH MonthlyRevenue AS(
		SELECT MONTH(OrderDate) AS Monthly_Sales,
				SUM(NetSales) AS Total_Net_revenue
		FROM ProductSales
		GROUP BY MONTH(OrderDate)
)
SELECT *, 
		LAG(Total_Net_revenue) OVER(ORDER BY Monthly_Sales) AS PreviousMonthRevenue,
		ROUND((Total_Net_revenue - LAG(Total_Net_revenue) OVER(ORDER BY Monthly_Sales))*100.0
			/LAG(Total_Net_revenue) OVER(ORDER BY Monthly_Sales), 2) AS MOM_Growth_Percentage
FROM MonthlyRevenue
ORDER BY Monthly_Sales




