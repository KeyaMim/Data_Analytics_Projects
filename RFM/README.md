# RFM Segmentation
RFM segmentation is a method divides customers into groups based on Recency, Frequency, and Monetary value. It helps businesses understand customer purchase behavior and activity patterns,and spend together.This enables management to implement targeted marketing campaigns for the customers.
## Why RFM Analysis Should Be Used
RFM scoring helps segment customers based on their scores — such as **VIP Customers**, **Loyal Customers**, **Potential Loyalists**, **Promising Customers**, **About to Sleep**, **Need Attention**, and **At-Risk Customers**.  
This segmentation allows businesses to design targeted and personalized marketing campaigns that are far more effective than generic ones.  
By identifying high-value and concerning customers early, companies can take immediate action to retain valuable customers and re-engage inactive ones.


## Database Setup
- Create a database named `RFM_SALES`.
```sql
CREATE database RFM_SALES;
USE  RFM_SALES;
DROP TABLE IF EXISTS sales_data;

CREATE TABLE sales_data (
ORDER_NUMBER INT,
QUANTITY INT,
PRICEEACH DECIMAL(10,2),
ORDERLINENUMBER INT,
SALES DECIMAL(10,2),
ORDERDATE TEXT,
STATUS TEXT,
QTR_ID INT,
MONTH_ID INT,
YEAR_ID INT,
PRODUCTLINE TEXT,
MSRP INT,
PRODUCTCODE TEXT,
CUSTOMERNAME TEXT,
PHONE TEXT,
ADDRESSLINE1 TEXT,
ADDRESSLINE2 TEXT,
CITY TEXT,
STATE TEXT,
POSTALCODE TEXT,
COUNTRY TEXT,
TERRITORY TEXT,
CONTACTLASTNAME TEXT,
CONTACTFIRSTNAME TEXT,
DEALSIZE TEXT
);
```
### Import Wizard Data
Data insertion into the `sales_data` table was performed using the **Import Wizard** tool.

## Dataset Exploration

```sql
SELECT * FROM sales_data LIMIT 5;
```
-- OUTPUT --
### Sample Output of `sales_data` Table

| ORDERNUMBER | QUANTITYORDERED | PRICEEACH | ORDERLINENUMBER | SALES   | ORDERDATE | STATUS  | QTR_ID | MONTH_ID | YEAR_ID | PRODUCTLINE | MSRP | PRODUCTCODE | CUSTOMERNAME              | PHONE          | ADDRESSLINE1                    | ADDRESSLINE2 | CITY          | STATE | POSTALCODE | COUNTRY | TERRITORY | CONTACTLASTNAME | CONTACTFIRSTNAME | DEALSIZE |
|-------------|-----------------|-----------|-----------------|---------|-----------|---------|--------|----------|---------|-------------|------|-------------|---------------------------|----------------|--------------------------------|--------------|---------------|-------|------------|---------|-----------|-----------------|-----------------|----------|
| 10107       | 30              | 95.70     | 2               | 2871.00 | 24/2/03   | Shipped | 1      | 2        | 2003    | Motorcycles | 95   | S10_1678    | Land of Toys Inc.         | 2125557818     | 897 Long Airport Avenue        |              | NYC           | NY    | 10022      | USA     | NA        | Yu              | Kwai            | Small    |
| 10121       | 34              | 81.35     | 5               | 2765.90 | 7/5/03    | Shipped | 2      | 5        | 2003    | Motorcycles | 95   | S10_1678    | Reims Collectables        | 26.47.1555     | 59 rue de l'Abbaye              |              | Reims         |       | 51100      | France  | EMEA      | Henriot         | Paul            | Small    |
| 10134       | 41              | 94.74     | 2               | 3884.34 | 1/7/03    | Shipped | 3      | 7        | 2003    | Motorcycles | 95   | S10_1678    | Lyon Souveniers           | +33 1 46 62 7555 | 27 rue du Colonel Pierre Avia  |              | Paris         |       | 75508      | France  | EMEA      | Da Cunha        | Daniel          | Medium   |
| 10145       | 45              | 83.26     | 6               | 3746.70 | 25/8/03   | Shipped | 3      | 8        | 2003    | Motorcycles | 95   | S10_1678    | Toys4GrownUps.com         | 6265557265     | 78934 Hillside Dr.              |              | Pasadena      | CA    | 90003      | USA     | NA        | Young           | Julie           | Medium   |
| 10159       | 49              | 100.00    | 14              | 5205.27 | 10/10/03  | Shipped | 4      | 10       | 2003    | Motorcycles | 95   | S10_1678    | Corporate Gift Ideas Co. | 6505551386     | 7734 Strong St.                 |              | San Francisco | CA    |            | USA     | NA        | Brown           | Julie           | Medium   |

```sql
SELECT COUNT(*) FROM sales_data;-- 2823
```
-- OUTPUT --
| COUNT(*) |
|----------|
| 2823     |

## Checking unique values
```sql
select distinct status from sales_data;
```
-- OUTPUT --
| status     |
|------------|
| Shipped    |
| Disputed   |
| In Process |
| Cancelled  |
| On Hold    |
| Resolved   |

```sql
select distinct year_id from sales_data;
```
-- OUTPUT --
| year_id |
|---------|
| 2003    |
| 2004    |
| 2005    |

select distinct PRODUCTLINE from SALES_SAMPLE_DATA;
```
-- OUTPUT --
| PRODUCTLINE      |
|------------------|
| Motorcycles      |
| Classic Cars     |
| Trucks and Buses |
| Vintage Cars     |
| Planes           |
| Ships            |
| Trains           |

```sql
select distinct COUNTRY from sales_data;
```
-- OUTPUT --
| COUNTRY     |
|-------------|
| USA         |
| France      |
| Norway      |
| Australia   |
| Finland     |
| Austria     |
| UK          |
| Spain       |
| Sweden      |
| Singapore   |
| Canada      |
| Japan       |
| Italy       |
| Denmark     |
| Belgium     |
| Philippines |
| Germany     |
| Switzerland |
| Ireland     |

```sql
SELECT MAX(STR_TO_DATE(ORDERDATE,'%d/%m/%y')) as last_business_date FROM sales_data;-- 2005-05-31 
```
-- OUTPUT --
| last_business_date |
|-------------------|
| 2005-05-31        |

### RFM Analysis Query

The following SQL query calculates **Recency, Frequency, and Monetary (RFM) values** for each customer from the `sales_data` table:

- **Recency_Value:** Number of days since the customer's last purchase  
- **Frequency_Value:** Number of orders placed by the customer  
- **Monetary_Value:** Total sales amount generated by the customer  

```sql
SELECT 
    customername,
    -- MAX(STR_TO_DATE(ORDERDATE,'%d/%m/%y')) as customer_last_transaction_date ,
    SUM(QUANTITY) AS total_qty_order,
    DATEDIFF(
        (SELECT MAX(STR_TO_DATE(ORDERDATE,'%d/%m/%y')) FROM sales_data),
        MAX(STR_TO_DATE(ORDERDATE,'%d/%m/%y'))
    ) AS recency_Value,
    COUNT(DISTINCT ORDER_NUMBER) AS frequency_Value,
    ROUND(SUM(SALES),0) AS monitary_Value
FROM sales_data
GROUP BY customername;
```
### Sample Output

The result of the query for selected customers (showing first 5 rows):

| customername                  | total_qty_order | recency_Value | frequency_Value | monitary_Value |
|-------------------------------|----------------|---------------|----------------|----------------|
| Alpha Cognac                  | 687            | 64            | 3              | 70488          |
| Amica Models & Co.            | 843            | 264           | 2              | 94117          |
| Anna's Decorations, Ltd       | 1469           | 83            | 4              | 153996         |
| Atelier graphique             | 270            | 187           | 3              | 24180          |
| Australian Collectables, Ltd  | 705            | 22            | 3              | 64591          |
| …                             | …              | …             | …              | …              |

**RFM Score Calculation per Customer
```sql
WITH CLV AS 
(
  SELECT 
      customername,
      MAX(STR_TO_DATE(ORDERDATE,'%d/%m/%y')) AS customer_last_transaction_date,
      SUM(QUANTITY) AS total_qty_order,
      DATEDIFF(
          (SELECT MAX(STR_TO_DATE(ORDERDATE,'%d/%m/%y')) FROM sales_data),
          MAX(STR_TO_DATE(ORDERDATE,'%d/%m/%y'))
      ) AS recency_Value,
      COUNT(DISTINCT ORDER_NUMBER) AS frequency_Value,
      ROUND(SUM(SALES),0) AS monitary_Value
  FROM sales_data
  GROUP BY customername
),

RFM_SCORE AS
(
  SELECT 
      C.*,
      NTILE(5) OVER(ORDER BY recency_value DESC) AS R_SCORE,
      NTILE(5) OVER(ORDER BY frequency_value ASC) AS F_SCORE,
      NTILE(5) OVER(ORDER BY monitary_value ASC) AS M_SCORE
  FROM CLV AS C
)
SELECT 
    customername,
    R_SCORE + F_SCORE + M_SCORE AS Total_RFM_Score,
    CONCAT_WS('', R_SCORE, F_SCORE, M_SCORE) AS RFM_Combination
FROM RFM_SCORE AS RS;
```
### Sample Output
| Customer Name           | Total_RFM_Score | RFM_Combination |
| ----------------------- | --------------- | --------------- |
| Boards & Toys Co.       | 7               | 421             |
| Atelier graphique       | 7               | 331             |
| Auto-Moto Classics Inc. | 7               | 331             |
| Microscale Inc.         | 4               | 211             |
| ...                     | ...             | ...             |

**This SQL query uses CTEs (Common Table Expressions) and a VIEW to organize complex RFM calculations in a readable, modular way.
The CTEs calculate recency, frequency, and monetary values, while the final view segments customers into groups like VIP, Loyal, and At Risk based on their RFM combination scores.
```sql
CREATE VIEW RFM_SEGMENTATION_DETAIL AS
WITH CLV AS (
    SELECT 
        customername,
        DATEDIFF(
            (SELECT MAX(STR_TO_DATE(orderdate, '%d/%m/%y')) FROM sales_data),
            MAX(STR_TO_DATE(orderdate, '%d/%m/%y'))
        ) AS recency_value,
        COUNT(DISTINCT order_number) AS frequency_value,
        ROUND(SUM(sales), 0) AS monitary_value
    FROM sales_data
    GROUP BY customername
),
RFM_SCORE AS (
    SELECT 
        customername,
        NTILE(5) OVER (ORDER BY recency_value DESC) AS R_SCORE,
        NTILE(5) OVER (ORDER BY frequency_value ASC) AS F_SCORE,
        NTILE(5) OVER (ORDER BY monitary_value ASC) AS M_SCORE
    FROM CLV
),
RFM_COMBINATION AS (
    SELECT 
        customername,
        (R_SCORE + F_SCORE + M_SCORE) AS total_rfm_score,
        CONCAT_WS('', R_SCORE, F_SCORE, M_SCORE) AS RFM_combination
    FROM RFM_SCORE
)
SELECT 
    customername,
    RFM_combination,
    CASE 
        WHEN RFM_combination IN ('455','525','544','554','555') THEN 'VIP'
        WHEN RFM_combination IN ('334','335','344','355','433','434','443','444','455','542','543') THEN 'Loyal Customers'
        WHEN RFM_combination IN ('421','441','442','521','522') THEN 'Potential Loyalists'
        WHEN RFM_combination IN ('223','233','331','332','333','352','451') THEN 'Promising Customers'
        WHEN RFM_combination IN ('224','225','244','243','245','334') THEN 'Potential Customers'
        WHEN RFM_combination IN ('141','211','212','221','222') THEN 'Needs Attention'
        WHEN RFM_combination IN ('111','112','113') THEN 'About to Sleep'
        WHEN RFM_combination IN ('114','115','124','125') THEN 'At Risk'
        ELSE 'Other'
    END AS customer_segment
FROM RFM_COMBINATION;
```

