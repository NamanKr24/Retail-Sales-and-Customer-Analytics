-- Add the new columns to the OnlineRetail_Cleaned table
ALTER TABLE OnlineRetail_Cleaned ADD (
    LineTotal NUMBER(15,2),
    InvoiceMonth NUMBER(2,0),
    InvoiceYear NUMBER(4,0),
    DayOfWeek VARCHAR2(10)
);

-- Populate the new columns with calculated values
UPDATE OnlineRetail_Cleaned
SET
    LineTotal = Quantity * UnitPrice,
    InvoiceMonth = TO_NUMBER(TO_CHAR(InvoiceDate, 'MM')),
    InvoiceYear = TO_NUMBER(TO_CHAR(InvoiceDate, 'YYYY')),
    DayOfWeek = TO_CHAR(InvoiceDate, 'Day'); -- 'Day' gives full name, 'DY' for abbreviation
COMMIT; -- Save the changes

SELECT * FROM OnlineRetail_Cleaned;