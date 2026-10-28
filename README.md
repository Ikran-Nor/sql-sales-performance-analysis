# Sales Performance and Business Insights | SQL Portfolio Project

## Project Overview

This project uses SQL to study sales data and understand how a business is performing. I analyzed sales from **January 2023 to June 2025** to find useful information about revenue, products, customers, stores, promotions, returns, and delivery times.

The main goal is to help the company understand its performance and find areas where it can improve.

## Business Problem

The company sells different products across several regions and stores. However, it needs a clearer picture of its sales performance.

Some regions and products generate more sales than others. The business also has product returns, delivery delays, and costs related to discounts and shipping.

Using SQL, I explored these problems and found insights that can help management make better decisions.

## Project Objectives

- Understand overall sales performance.
- Identify the strongest and weakest regions, products, and stores.
- Find valuable customers and study buying behavior.
- Compare salesperson performance.
- Study promotions and discounts.
- Understand product returns and delivery times.
- Analyze sales trends and suggest business improvements.

## Dataset Overview

The dataset is called **Product-Sales-Region.csv**.

| Dataset Information | Value |
|---|---:|
| Total orders | 1,500 |
| Original columns | 19 |
| Unique customers | 1,371 |
| Products | 7 |
| Regions | 5 |
| Stores | 4 |
| Salespeople | 6 |
| Date range | January 2023 - June 2025 |

The data includes order dates, products, quantities, prices, discounts, promotions, regions, store names, salespeople, customer IDs, returned orders, shipping costs, and delivery dates.

## Tools and SQL Skills

**Tool:** Microsoft SQL Server

**SQL skills used:**

- Creating databases and tables
- Importing CSV data with `BULK INSERT`
- Checking and cleaning data
- `SELECT`, `WHERE`, `GROUP BY`, and `ORDER BY`
- `SUM`, `COUNT`, `AVG`, and `CASE`
- Subqueries and Common Table Expressions (CTEs)
- `DATEDIFF` for delivery times
- `LAG` for yearly sales growth
- `CAST` and `NULLIF` for calculations

## Data Cleaning and Preparation

Before the analysis, I:

1. Created a SQL Server database and table.
2. Loaded the CSV file using `BULK INSERT`.
3. Checked missing values. The **Promotion** column had 370 blank values, which I filled with **No promotion**.
4. Checked for duplicate order IDs and found none.
5. Checked numbers, categories, and dates for invalid values. No invalid values were found.
6. Found that **Date** and **OrderDate** contained the same information, so I removed the extra **Date** column.

## Business Questions

1. Which regions have the highest and lowest revenue?
2. Which products generate high revenue but also have high return rates?
3. Which customers bring the most value to the business?
4. Are promotions linked to better sales performance?
5. Which stores perform best?
6. Do larger discounts bring enough extra sales to justify their cost?
7. Which products and regions have the longest delivery times?
8. Which salespeople generate the highest revenue?
9. How do sales change over time?
10. Where should management focus to improve business performance?

## Key Findings

### 1. Overall Sales Performance

| Measure | Result |
|---|---:|
| Orders | 1,500 |
| Sales value after discounts | 4,379,992.96 |
| Units sold | 15,616 |
| Customers | 1,371 |
| Average order value | 2,920.00 |
| Shipping cost | 41,260.94 |
| Shipping cost rate | 0.94% |
| Returned orders | 372 |
| Return rate | 24.80% |
| Average delivery time | About 6 days |

**Insight:** The company recorded about **4.38 million** in sales after discounts. However, almost **1 in 4 orders** was marked as returned.

### 2. Regional Performance

- **North** had the highest sales value: **967,958.10**.
- **South** had the lowest sales value: **827,768.26**.
- North had the longest average delivery time among regions: **6.39 days**.
- East, West, and South each had return rates of about **26%**.

**Insight:** North leads in sales, but its delivery time needs attention. South may need more support to improve sales.

### 3. Product Performance

- **Tablet** had the highest sales value: **684,539.44**.
- Tablet also had the highest number of units sold: **2,577**.
- Laptop and Printer each generated about **684,000** in sales.
- **Chair** had the highest product return rate: **28.23%**.
- **Laptop** also had a high return rate: **27.43%**.
- Desk had the lowest product return rate: **21.74%**.

**Insight:** Tablet is a strong product. The company should investigate why customers return Chair and Laptop more often.

### 4. Customer Analysis

- Retail customers generated about **2.20 million** in sales.
- Wholesale customers generated about **2.18 million**.
- **Cust 9159** had the highest customer sales value: **17,313.60** from two orders.
- **1,247 of 1,371 customers** placed only one order in the dataset.

**Insight:** Both customer groups are important. The business also has an opportunity to encourage customers to buy again.

### 5. Store and Salesperson Performance

- **Store D** had the highest sales value: **1,205,526.00**.
- **Store B** had the lowest sales value: **1,029,649.30**.
- Store B also had the highest store return rate: about **27%**.
- **Bob** generated the highest salesperson revenue: **796,780.58**.
- **Alice** followed with **786,166.01**.
- Carlos had the highest salesperson return rate: **28.15%**.

**Insight:** The company can learn from its strongest stores and salespeople. High return rates should be reviewed to understand the reasons.

### 6. Promotions and Discounts

- **FREESHIP** had the highest sales value among promotion groups: **1,238,077.01**.
- FREESHIP was linked to **419 orders**.
- Orders with a **15% discount** had an average order value of about **2,685.71**.
- Orders with **no discount** had an average order value of about **3,067.19**.

**Insight:** FREESHIP was linked to strong sales, but it also had more orders than the other promotion groups. These results do not prove that the promotion caused higher sales. The company should also check profit and promotion costs.

### 7. Delivery Performance

- The average delivery time was about **6 days**.
- Delivery times ranged from **2 to 10 days**.
- **681 orders** took longer than the overall average delivery time.
- **North** had the longest average delivery time by region: **6.39 days**.
- **Monitor** had the longest average delivery time by product: **6.32 days**.

**Insight:** Delivery can be improved, especially for orders in North.

### 8. Sales Trends

- Sales in **2024 increased by 4.36%** compared with 2023.
- **March 2023** had the highest monthly sales value: about **208,549**.
- Sales in **January-June 2025** were about **0.2% lower** than in January-June 2024.

**Insight:** Sales grew in 2024. The first six months of 2025 were almost the same as the first six months of 2024.

## Business Recommendations

1. **Reduce returns:** Find out why Chair and Laptop orders are returned. Review product quality, descriptions, and customer feedback.
2. **Support the South region:** Study customer demand, stock levels, and local sales activities to find ways to increase sales.
3. **Improve delivery:** Review shipping steps, especially in North, to reduce delivery times.
4. **Learn from strong stores:** Study the good practices of Store D. Review Store B to understand its lower sales and higher return rate.
5. **Review promotions and discounts:** Test offers such as FREESHIP and check whether the extra sales cover the costs.
6. **Encourage repeat purchases:** Use follow-up messages, helpful customer service, and loyalty offers to bring customers back.
7. **Support salespeople:** Share good sales practices and review return patterns before deciding what needs improvement.
8. **Track results each month:** Monitor sales, returns, delivery times, discounts, and profit after returns.

## Important Notes

- The reported sales value is **after discounts**, but **returned orders are still included**. It should not be treated as final revenue after returns.
- The dataset does not name a currency, so values are shown without a currency symbol.
- The dataset ends in **June 2025**. Full-year 2025 sales should not be compared directly with the full year 2024.
- The dataset does not include all costs needed to calculate profit. Promotion results show a relationship with sales, not proof of cause.

## Conclusion

This project helped me understand sales performance and find areas where a business can improve.

The company recorded about **4.38 million** in sales after discounts. North was the strongest region, Tablet had the highest product sales value, and Store D had the best store performance.

The analysis also found important challenges. The company had a **24.80% return rate**, some products had many returns, and delivery was slower in North.

Based on these findings, the company should focus on **reducing returns, improving delivery, keeping customers, and measuring the real value of promotions**.

This project shows my ability to use **SQL for data cleaning, data validation, sales analysis, and business recommendations**.
