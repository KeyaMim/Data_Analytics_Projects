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

