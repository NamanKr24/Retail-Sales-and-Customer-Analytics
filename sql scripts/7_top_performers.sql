-- Top 10 Products by Total Revenue
SELECT
    Description,
    StockCode,
    SUM(LineTotal) AS TotalRevenue
FROM
    OnlineRetail_Cleaned
GROUP BY
    Description,
    StockCode
ORDER BY
    TotalRevenue DESC
FETCH FIRST 10 ROWS ONLY;

-- Top 10 Products by Total Quantity Sold
SELECT
    Description,
    StockCode,
    SUM(Quantity) AS TotalQuantitySold
FROM
    OnlineRetail_Cleaned
GROUP BY
    Description,
    StockCode
ORDER BY
    TotalQuantitySold DESC
FETCH FIRST 10 ROWS ONLY;