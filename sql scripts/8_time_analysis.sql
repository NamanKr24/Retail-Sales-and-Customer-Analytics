-- Total Sales by Year
SELECT
    InvoiceYear,
    SUM(LineTotal) AS TotalSales
FROM
    OnlineRetail_Cleaned
GROUP BY
    InvoiceYear
ORDER BY
    InvoiceYear;
    
-- Total Sales by Month (Overall Seasonality)
SELECT
    InvoiceMonth,
    SUM(LineTotal) AS TotalSales
FROM
    OnlineRetail_Cleaned
GROUP BY
    InvoiceMonth
ORDER BY
    InvoiceMonth;

-- Total Sales by Month-Year Combination
SELECT
    InvoiceYear,
    InvoiceMonth,
    SUM(LineTotal) AS TotalSales
FROM
    OnlineRetail_Cleaned
GROUP BY
    InvoiceYear,
    InvoiceMonth
ORDER BY
    InvoiceYear,
    InvoiceMonth;

-- Total Sales by Day of Week
SELECT
    DayOfWeek,
    SUM(LineTotal) AS TotalSales
FROM
    OnlineRetail_Cleaned
GROUP BY
    DayOfWeek
ORDER BY
    -- You might want to order by a specific day order, not alphabetically
    CASE DayOfWeek
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6
        WHEN 'Sunday' THEN 7
        ELSE 8
    END;