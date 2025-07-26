SELECT MAX(InvoiceDate) FROM OnlineRetail_Cleaned;

-- Your updated query with the correct SNAPSHOT_DATE
DEFINE SNAPSHOT_DATE = TO_DATE('09-12-11', 'DD-MM-RR');

WITH CustomerRFM_Metrics AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS Frequency,
        SUM(LineTotal) AS Monetary,
        MAX(InvoiceDate) AS LastPurchaseDateTime,
        COUNT(DISTINCT InvoiceNo) AS TotalOrdersForCustomer
    FROM
        OnlineRetail_Cleaned
    GROUP BY
        CustomerID
)
SELECT
    c.CustomerID,
    c.Frequency,
    c.Monetary,
    TRUNC(&&SNAPSHOT_DATE) - TRUNC(c.LastPurchaseDateTime) AS RecencyDays,
    CASE
        WHEN c.TotalOrdersForCustomer > 0 THEN ROUND(c.Monetary / c.TotalOrdersForCustomer, 2)
        ELSE 0
    END AS AverageOrderValue
FROM
    CustomerRFM_Metrics c
ORDER BY
    c.CustomerID;

-- Create the new table to store customer-level metrics
CREATE TABLE Customer_Metrics AS
WITH CustomerRFM_Metrics AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS Frequency,
        SUM(LineTotal) AS Monetary,
        MAX(InvoiceDate) AS LastPurchaseDateTime,
        COUNT(DISTINCT InvoiceNo) AS TotalOrdersForCustomer
    FROM
        OnlineRetail_Cleaned
    GROUP BY
        CustomerID
)
SELECT
    c.CustomerID,
    c.Frequency,
    c.Monetary,
    TRUNC(&&SNAPSHOT_DATE) - TRUNC(c.LastPurchaseDateTime) AS RecencyDays,
    CASE
        WHEN c.TotalOrdersForCustomer > 0 THEN ROUND(c.Monetary / c.TotalOrdersForCustomer, 2)
        ELSE 0
    END AS AverageOrderValue
FROM
    CustomerRFM_Metrics c;
    
SELECT * FROM Customer_Metrics WHERE ROWNUM <= 10;