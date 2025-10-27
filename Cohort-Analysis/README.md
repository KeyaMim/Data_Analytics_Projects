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

## Cancelled Order
```sql
SELECT INVOICENO FROM RETAIL_SALES WHERE INVOICENO LIKE 'C%';
```
## Sample Cancelled Invoices
| INVOICENO  |
|------------|
| C536379    |
| C536383    |
| C536391    |
| ...        |

**These rows likely correspond to cancelled orders or returns. It’s important to identify them before performing cohort or retention analysis**
```sql
SELECT COUNT(*) FROM RETAIL_SALES WHERE QUANTITY <= 0;-- '10624'
```
### Rows with Non-Positive Quantity

| COUNT(*) |
|----------|
| 10624    |

 **Valid Customer ID Count For Analysis**
 ```sql
SELECT COUNT(*) FROM RETAIL_SALES WHERE CUSTOMERID IS  NOT NULL; -- 406829
```
--Output--
| COUNT(*) |
|----------|
| 406829   |

### Cohort Analysis [Customer Retention]
**Preparing Valid Sales Data**
The following CTE prepares valid sales data for analysis. Since `INVOICEDATE` was stored as a string, it is formatted to a proper DATETIME.
```sql
WITH CTE1 AS
(SELECT
	CUSTOMERID,
    str_to_date(INVOICEDATE, '%m/%d/%Y %H:%i') AS FORMATTED_DATE,
    ROUND(QUANTITY*UNITPRICE, 2) AS SALE_VALUE
FROM RETAIL_SALES
WHERE 
	CUSTOMERID IS NOT NULL
     AND CUSTOMERID != ''
	AND INVOICENO NOT LIKE 'C%'
    AND QUANTITY > 0
    AND UNITPRICE > 0)
SELECT * FROM CTE1;
```

## Output 
| CUSTOMERID | FORMATTED_DATE       | SALE_VALUE |
|------------|--------------------|------------|
| 17850      | 2010-12-01 08:26:00 | 15.30      |
| 17850      | 2010-12-01 08:26:00 | 20.34      |
| 17850      | 2010-12-01 08:26:00 | 22.00      |
| 17850      | 2010-12-01 08:26:00 | 20.34      |
| ...        | ...                 | ...        |

### First Transaction and Purchase Month
(CTE2) calculates **each customer’s first transaction date** and **assigns purchase months** for cohort analysis:

```sql
WITH CTE2 AS (
    SELECT
        CUSTOMERID,
        FORMATTED_DATE AS PURCHASE_DATE,
        MIN(FORMATTED_DATE) OVER (PARTITION BY CUSTOMERID) AS FIRST_TRANSACTION_DATE,
        DATE_FORMAT(FORMATTED_DATE, '%Y-%m-01') AS PURCHASE_MONTH,
        DATE_FORMAT(MIN(FORMATTED_DATE) OVER (PARTITION BY CUSTOMERID), '%Y-%m-01') AS FIRST_TRANSACTION_MONTH
    FROM CTE1
)
SELECT * FROM CTE2;
```
## Output 
| CUSTOMERID | PURCHASE_DATE        | FIRST_TRANSACTION_DATE | PURCHASE_MONTH | FIRST_TRANSACTION_MONTH |
|-------------|----------------------|------------------------|----------------|-------------------------|
| 12346       | 2011-01-18 10:01:00  | 2011-01-18 10:01:00    | 2011-01-01     | 2011-01-01              |
| 12347       | 2011-01-26 14:30:00  | 2010-12-07 14:57:00    | 2011-01-01     | 2010-12-01              |
| 12347       | 2011-01-26 14:30:00  | 2010-12-07 14:57:00    | 2011-01-01     | 2010-12-01              |
| 12347       | 2011-01-26 14:30:00  | 2010-12-07 14:57:00    | 2011-01-01     | 2010-12-01              |
| ...         | ...                  | ...                    | ...            | ...                     |

### Cohort Retention Calculation
This QUERY creates the cohort month for each customer and builds the final cohort retention Table
```sql
CTE3 AS
(SELECT 
	CUSTOMERID,
    FIRST_TRANSACTION_DATE,
    PURCHASE_DATE,
   
	CONCAT(
		'Month_',
		ROUND(DATEDIFF(PURCHASE_DATE, FIRST_TRANSACTION_DATE)/30, 0)
        ) AS COHORT_MONTH,
    DATE_FORMAT(PURCHASE_DATE, '%Y-%m-01') as PURCHASE_MONTH,
    DATE_FORMAT(FIRST_TRANSACTION_DATE, '%Y-%m-01') AS FIRST_TRANSACTION_MONTH
FROM CTE2)

SELECT * FROM CTE3;
```
## Sample Output – Cohort Month Calculation (CTE3)

| CUSTOMERID | FIRST_TRANSACTION_DATE | PURCHASE_DATE        | COHORT_MONTH | PURCHASE_MONTH | FIRST_TRANSACTION_MONTH |
|-------------|------------------------|----------------------|---------------|----------------|-------------------------|
| 12346       | 2011-01-18 10:01:00    | 2011-01-18 10:01:00  | Month_0       | 2011-01-01     | 2011-01-01              |
| 12347       | 2010-12-07 14:57:00    | 2011-01-26 14:30:00  | Month_2       | 2011-01-01     | 2010-12-01              |
| 12347       | 2010-12-07 14:57:00    | 2011-01-26 14:30:00  | Month_2       | 2011-01-01     | 2010-12-01              |
| ...         | ...                    | ...                  | ...           | ...            | ...                     |

