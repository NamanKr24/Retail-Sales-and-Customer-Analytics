-- Create the cleaned table by selecting only valid rows
CREATE TABLE OnlineRetail_Cleaned AS
SELECT
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country
FROM
    OnlineRetail
WHERE
    Quantity > 0                          -- Exclude returns/cancellations
    AND UnitPrice > 0                     -- Exclude invalid prices
    AND CustomerID IS NOT NULL            -- Exclude transactions without a customer
    AND Description IS NOT NULL           -- Exclude transactions with no product description
    AND InvoiceNo NOT LIKE 'C%';         -- Explicitly exclude cancelled invoices
    
-- Count total records in the cleaned table
SELECT COUNT(*) FROM OnlineRetail_Cleaned;

-- Verify no NULL CustomerIDs (should be 0)
SELECT COUNT(*) FROM OnlineRetail_Cleaned WHERE CustomerID IS NULL;

-- Verify no NULL Descriptions (should be 0)
SELECT COUNT(*) FROM OnlineRetail_Cleaned WHERE Description IS NULL;

-- Verify no Quantity <= 0 (should be 0)
SELECT COUNT(*) FROM OnlineRetail_Cleaned WHERE Quantity <= 0;

-- Verify no UnitPrice <= 0 (should be 0)
SELECT COUNT(*) FROM OnlineRetail_Cleaned WHERE UnitPrice <= 0;

-- Verify no InvoiceNo LIKE 'C%' (should be 0)
SELECT COUNT(*) FROM OnlineRetail_Cleaned WHERE InvoiceNo LIKE 'C%';