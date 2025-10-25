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

SELECT * From sales_data LIMIT 5;
SELECT COUNT(*) FROM sales_data;-- 2823
SELECT MAX(STR_TO_DATE(ORDERDATE,'%d/%m/%y')) as last_business_date -- 2005-05-31        
FROM sales_data;
SELECT MIN(STR_TO_DATE(ORDERDATE,'%d/%m/%y')) AS min_business_date 
FROM sales_data;    -- 2003-01-06
select distinct status from sales_data;


SELECT 
customername,
 MAX(STR_TO_DATE(ORDERDATE,'%d/%m/%y')) as customer_last_transaction_date ,
-- SUM(QUANTITY) AS total_qty_order,
 DATEDIFF((SELECT MAX(STR_TO_DATE(ORDERDATE,'%d/%m/%y'))FROM sales_data), MAX(STR_TO_DATE(ORDERDATE,'%d/%m/%y'))) AS recency_Value,
COUNT(DISTINCT ORDER_NUMBER) AS frequency_Value,
ROUND(SUM(SALES),0) AS monitary_Value
FROM sales_data
GROUP BY customername;

CREATE VIEW  RFM_SEGMENTATION_DATA AS
WITH CLV AS 
(SELECT 
customername,
 MAX(STR_TO_DATE(ORDERDATE,'%d/%m/%y')) as customer_last_transaction_date ,
-- SUM(QUANTITY) AS total_qty_order,
 DATEDIFF((SELECT MAX(STR_TO_DATE(ORDERDATE,'%d/%m/%y'))FROM sales_data), MAX(STR_TO_DATE(ORDERDATE,'%d/%m/%y'))) AS recency_Value,
COUNT(DISTINCT ORDER_NUMBER) AS frequency_Value,
ROUND(SUM(SALES),0) AS monitary_Value
FROM sales_data
GROUP BY customername),

RFM_SCORE AS
(
SELECT 
C.* ,
NTILE(5) OVER(ORDER BY recency_value DESC) AS R_SCORE,
NTILE(5) OVER(ORDER BY frequency_value ASC) AS F_SCORE,
NTILE(5) OVER(ORDER BY monitary_value ASC) AS M_SCORE
FROM CLV AS C
),

RFM_COMBINATION AS(
SELECT 
RC.*,
R_SCORE + F_SCORE + M_SCORE AS total_RFM_score,
CONCAT_WS('',R_SCORE, F_SCORE, M_SCORE) AS RFM_combination
FROM RFM_SCORE AS RC)

SELECT 
RC.*,

CASE
	   WHEN  RFM_combination IN (455,525,544,554,555) THEN 'VIP'
	   WHEN RFM_combination IN (334,335,344,355,433,434,443,444,455 ,542,543  ) THEN 'Loyal Customers'
	   WHEN RFM_combination IN (421,441,442,521,522) THEN 'Potential Loyalists'
       WHEN RFM_combination IN (223,233,331,332,333,352,451) THEN 'Promising Customers'
	   WHEN RFM_combination IN (224,225,244,243,244,245,334) THEN 'Potential Customers'
	   WHEN RFM_combination IN (141,211,212,221,222) THEN 'Needs Attention'
	   WHEN RFM_combination IN (111,112,113) THEN 'About to Sleep'
	   WHEN RFM_combination IN (114,115,124,125) THEN 'At Risk'
	   ELSE "Other"
	
       END AS customer_segment
FROM RFM_COMBINATION RC;

SELECT * FROM RFM_SEGMENTATION_DATA;


CREATE VIEW RFM_SEGMENT_AGG AS
SELECT
customer_segment,
COUNT(customername) AS Total_Customers,  
SUM(monitary_Value) AS Total_Spend,
ROUND(AVG(monitary_Value),0) AS Avg_Spend,
SUM(frequency_value) AS Total_order,
SUM(total_qty_order) AS Total_qty_order
FROM RFM_SEGMENTATION_DATA 
GROUP BY customer_segment;

SELECT * FROM RFM_SEGMENT_AGG;
-- analyse 

SELECT 
SUM(total_spend)
FROM RFM_SEGMENT_AGG;

 WITH CLV AS 
(
  SELECT 
      customername,
      MAX(STR_TO_DATE(ORDERDATE,'%d/%m/%y')) as customer_last_transaction_date,
      SUM(QUANTITY) AS total_qty_order,
      DATEDIFF((SELECT MAX(STR_TO_DATE(ORDERDATE,'%d/%m/%y')) FROM sales_data),
               MAX(STR_TO_DATE(ORDERDATE,'%d/%m/%y'))) AS recency_Value,
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


CREATE VIEW RFM_SEGMENTATION_DETAIL AS
WITH CLV AS 
(
  SELECT 
      customername,
      MAX(STR_TO_DATE(ORDERDATE,'%d/%m/%y')) as customer_last_transaction_date,
      SUM(QUANTITY) AS total_qty_order,
      DATEDIFF((SELECT MAX(STR_TO_DATE(ORDERDATE,'%d/%m/%y')) FROM sales_data),
               MAX(STR_TO_DATE(ORDERDATE,'%d/%m/%y'))) AS recency_Value,
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
),
RFM_COMBINATION AS(SELECT 
    customername,
    R_SCORE + F_SCORE + M_SCORE AS Total_RFM_Score,
    CONCAT_WS('', R_SCORE, F_SCORE, M_SCORE) AS RFM_combination
FROM RFM_SCORE AS RS)

SELECT
customername,
RFM_combination,
CASE 
	-- customer who,s spend,order,frequency high assigned vip
	   WHEN  RFM_combination IN (455,525,544,554,555) THEN 'VIP'
     --   loyal becuase their their  rfm combination score is mid to high which to 3 to 5
	   WHEN RFM_combination IN (334,335,344,355,433,434,443,444,455 ,542,543  ) THEN 'Loyal Customers'
	   WHEN RFM_combination IN (421,441,442,521,522) THEN 'Potential Loyalists'
       WHEN RFM_combination IN (223,233,331,332,333,352,451) THEN 'Promising Customers'
	   -- (Potential Customers) they have potentiality turn to be a loyal becuase their spend high order and frequency is not very low
       WHEN RFM_combination IN (224,225,244,243,244,245,334) THEN 'Potential Customers'
	   WHEN RFM_combination IN (141,211,212,221,222) THEN 'Needs Attention'
       WHEN RFM_combination IN (111,112,113) THEN 'About to Sleep'
	   WHEN RFM_combination IN (114,115,124,125) THEN 'At Risk'
	   ELSE "Other"
	
       END AS customer_segment
FROM RFM_COMBINATION RC;
SELECT * FROM RFM_SEGMENTATION_DETAIL; 








