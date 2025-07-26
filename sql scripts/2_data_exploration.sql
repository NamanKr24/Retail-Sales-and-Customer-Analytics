SELECT COUNT(*) FROM OnlineRetail;

-- Count rows with missing CustomerID
SELECT COUNT(*) FROM OnlineRetail WHERE CustomerID IS NULL;

-- Count rows with missing Description
SELECT COUNT(*) FROM OnlineRetail WHERE Description IS NULL;

-- Count rows with zero or negative Quantity (likely returns/errors)
SELECT COUNT(*) FROM OnlineRetail WHERE Quantity <= 0;

-- Count rows with zero or negative UnitPrice (likely errors)
SELECT COUNT(*) FROM OnlineRetail WHERE UnitPrice <= 0;

SELECT COUNT(*) FROM OnlineRetail WHERE InvoiceNo LIKE 'C%';