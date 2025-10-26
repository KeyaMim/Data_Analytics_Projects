# Cohort Analysis Using SQL and Excel
Using cohort analysis in this online retail project helps to uncover customer behavior and performance trends over time.It shows how different groups of customers behave after their first purchase and how often they return.This helps the business understand loyalty patterns, improve overall customer engagement, and make better strategic decisions.
## Key Customer Metrics

- **Customer Retention** – Number of customers who returned in later months. *Shows how well the business keeps existing customers engaged.*  
- **Retention Rate** – Percentage of customers retained over time. *Helps measure customer loyalty and satisfaction.*  
- **Churn Rate** – Percentage of customers who stopped purchasing. *Indicates when customers lose interest or stop engaging with the brand.*  
- **Customer Lifetime Value (CLV)** – Total revenue expected from a customer during their relationship with the business. *Shows how valuable each customer is in the long term.*  
- **Customer Average Spend** – Average of CLV across all customers. *Gives a general idea of overall customer profitability.*

## Business Value
- **Improve Retention** – Identify patterns in customer behavior to increase repeat purchases over time.  
- **Targeted Marketing** – Use cohort insights to design campaigns for specific customer groups.  
- **Focus on High-Value Customers** – Discover which cohorts contribute the most revenue and prioritize them for business strategies.
## Data Preparation

- Create a database `online_retail_db`.
```sql
CREATE DATABASE online_retail_db;
CREATE TABLE retail_sales (
    InvoiceNo VARCHAR(50),
    StockCode VARCHAR(50),
    Description VARCHAR(70),
    Quantity INT,
    InvoiceDate VARCHAR(70),
    UnitPrice DECIMAL(10,2),
    CustomerID INT,
    Country VARCHAR(50)
);
```
- Import Data Using Python
## Dataset Exploration
```sql
SELECT * FROM retail_sales LIMIT 5;
```
### Sample Output of `retail_sales` Table

| InvoiceNo | StockCode | Description | Quantity | InvoiceDate | UnitPrice | CustomerID | Country |
|-----------|-----------|-------------|---------|------------|-----------|------------|---------|
| 536365    | 85123A    | WHITE HANGING HEART T-LIGHT HOLDER | 6 | 12/01/2010 08:26 | 2.55 | 17850 | United Kingdom |
| 536365    | 71053     | WHITE METAL LANTERN | 6 | 12/01/2010 08:26 | 3.39 | 17850 | United Kingdom |
| 536365    | 84406B    | CREAM CUPID HEARTS COAT HANGER | 8 | 12/01/2010 08:26 | 2.75 | 17850 | United Kingdom |
| 536365    | 84029G    | KNITTED UNION FLAG HOT WATER BOTTLE | 6 | 12/01/2010 08:26 | 3.39 | 17850 | United Kingdom |
| 536365    | 84029E    | RED WOOLLY HOTTIE WHITE HEART | 6 | 12/01/2010 08:26 | 3.39 | 17850 | United Kingdom |
```sql  
SELECT COUNT(*) FROM retail_sales;-- '541909'
```
-- Output --
| COUNT(*) |
|----------|
| 541,909  |

## Checking Null or Empty
```sql
SELECT * FROM retail_sales WHERE CustomerID IS NULL;
```
-- OUTPUT --
## Sample Data

| InvoiceNo | StockCode | Description                        | Quantity | InvoiceDate       | UnitPrice | CustomerID | Country        |
|-----------|-----------|------------------------------------|---------|-----------------|-----------|------------|----------------|
| 536414    | 22139     | NULL                               | 56      | 12/01/2010 11:52 | 0.00      | NULL       | United Kingdom |
| 536544    | 21773     | DECORATIVE ROSE BATHROOM BOTTLE   | 1       | 12/01/2010 14:32 | 2.51      | NULL       | United Kingdom |
| 536544    | 21774     | DECORATIVE CATS BATHROOM BOTTLE  | 2       | 12/01/2010 14:32 | 2.51      | NULL       | United Kingdom |
...
```sql
SELECT *
FROM retail_sales
WHERE InvoiceNo IS NULL OR InvoiceNo = ''
   OR StockCode IS NULL OR StockCode = ''
   OR Description IS NULL OR Description = ''
   OR Quantity IS NULL OR Quantity = ''
   OR InvoiceDate IS NULL OR InvoiceDate = ''
   OR UnitPrice IS NULL OR UnitPrice = ''
   OR CustomerID IS NULL OR CustomerID = ''
   OR Country IS NULL OR Country = '';
```
## Output
| InvoiceNo | StockCode | Description | Quantity | InvoiceDate       | UnitPrice | CustomerID | Country        |
|-----------|-----------|-------------|-----------|-------------------|-----------|------------|----------------|
| 536414    | 22139     | NULL        | 56        | 12/01/2010 11:52 | 0.00      | NULL       | United Kingdom |
| 536545    | 21134     | NULL        | 1         | 12/01/2010 14:32 | 0.00      | NULL       | United Kingdom |
| 536546    | 22145     | NULL        | 1         | 12/01/2010 14:33 | 0.00      | NULL       | United Kingdom |
| …         | …         | …           | …         | …                 | …         | …          | …              |

## Distinct Values
```sql
SELECT DISTINCT COUNTRY FROM retail_sales;  
```
--Output--
| COUNTRY |
|----------|
| United Kingdom |
| France |
| Australia |
| Netherlands |
| Germany |
| ... |

```sql
SELECT DISTINCT CUSTOMERID FROM RETAIL_SALES; 
```
-- Output --
| CustomerID |
|------------|
| 17850      |
| 13047      |
| 12583      |
| ...        |
## Minimum Quantities Check
```sql
SELECT min(Quantity) FROM RETAIL_SALES; --  min(Quantity)'-80995'
```
-- Output --
| min(Quantity) |
|---------------|
| -80995        |
