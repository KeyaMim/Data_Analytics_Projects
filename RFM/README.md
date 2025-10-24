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



  

