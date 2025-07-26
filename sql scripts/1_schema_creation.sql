CREATE TABLE OnlineRetail (
    InvoiceNo   VARCHAR2(20) NOT NULL,
    StockCode   VARCHAR2(20) NOT NULL,
    Description VARCHAR2(255),
    Quantity    NUMBER(10,0) NOT NULL,  -- Assuming whole numbers for quantity
    InvoiceDate DATE NOT NULL,          -- Oracle's DATE includes time
    UnitPrice   NUMBER(10,2) NOT NULL,  -- Price with 2 decimal places
    CustomerID  NUMBER(10,0),           -- Can be NULL based on dataset info
    Country     VARCHAR2(50) NOT NULL
);

SELECT * FROM OnlineRetail;