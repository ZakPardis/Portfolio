-- ! why SQL Query type conversion in microsoft sql server


-- ! SQL query Conversion

--Data types can be converted either implicitly or explicitly.

--Implicit conversions are not visible to the user. SQL Server automatically converts the data from one data type to another. For example, when a smallint is compared to an int, the smallint is implicitly converted to int before the comparison proceeds.

SELECT 10 + 1.5;  -- Implicitly converts 10 (INT) to 10.0 (FLOAT), result is 11.5



--? Explicit conversions use the CAST or CONVERT functions.

-- ! CAST:
--It is more straightforward and is compliant with the ANSI SQL standard.
--It can only change the data type without additional formatting options.
CAST(expression AS data_type)


-- ! CONVERT:
--It is specific to SQL Server and provides additional functionality.
--It allows for formatting of date and time data types using the style parameter.
--For example, when converting a DATETIME to a string, you can specify different formats using the style parameter.
CONVERT(data_type, expression [, style])



-- CAST()

SELECT CAST('2024-10-17' AS DATE) AS ConvertedDate;
SELECT CAST('123' AS INT);

-- CONVERT()
SELECT CONVERT(VARCHAR(10), GETDATE(), 120) AS FormattedDate; -- Outputs date in YYYY-MM-DD format



USE Northwind;

-- Better query performance by ensuring proper type conversion
-- SQL Server may not use indexes properly if there is a mismatch in data types between columns and query conditions. This can lead to performance degradation. By using explicit type conversion, you can ensure that indexes are properly utilized and the query runs efficiently
SELECT * FROM Orders WHERE OrderID = CAST('123' AS INT);




-- Convert a Date to a Specific Format (YYYY-MM-DD)
SELECT 
    OrderID,
    CONVERT(VARCHAR(10), OrderDate, 120) AS FormattedOrderDate
FROM Orders;

-- Convert a String to a Date
DECLARE @StringDate NVARCHAR(10) = '1996-07-04';

SELECT 
    OrderID,
    OrderDate
FROM Orders
WHERE OrderDate = CONVERT(DATE, @StringDate);

-- Convert Numeric Values to Strings
SELECT 
    ProductID,
    ProductName,
    CONVERT(NVARCHAR(20), UnitPrice) AS UnitPriceString
FROM Products;

-- Convert Decimal to Integer
SELECT 
    ProductID,
    ProductName,
    CONVERT(INT, UnitPrice) AS RoundedUnitPrice
FROM Products;

-- Use CAST for Conversion
SELECT 
    OrderID,
    CONCAT('Quantity Ordered: ', CAST(Quantity AS NVARCHAR(10))) AS QuantityMessage
FROM OrderDetails
WHERE OrderID = 10248;  -- Example for a specific order


-- ! Rounding and Truncating Numbers

--Rounding adjusts the number to the nearest value based on the precision you specify.
--Truncating removes the extra decimal places without rounding (it simply cuts off the digits).
-- ? Syntax:
ROUND ( numeric_expression, length [, function] )

--Rounding a number to 2 decimal places
SELECT ROUND(1234.5678, 2) AS RoundedNumber;


--Rounding a number to the nearest integer
SELECT ROUND(1234.5678, 0) AS RoundedNumber;

-- Rounds the number to the nearest multiple of 10

-- Rounding a number to the nearest ten (left of the decimal point)
SELECT ROUND(1237.5678, -1) AS RoundedNumber; -- 1240

-- ? Truncating Numbers
--Truncation removes the extra decimal places without rounding.

-- Truncating to the nearest integer
SELECT ROUND(1234.5678, 2, 1) AS TruncatedNumber;

SELECT ROUND(1234.5678, 0, 1) AS TruncatedNumber;

-- To make sure to display 1234, we will cast it to int
SELECT CAST(ROUND(1234.5678, 0, 1) AS INT) AS TruncatedNumber;


-- ! VIEW IN MS SQL
https://learn.microsoft.com/en-us/sql/relational-databases/views/views?view=sql-server-ver16

-- Views are generally used to focus, simplify, and customize the perception each user has of the database. Views can be used as security mechanisms by letting users access data through the view, without granting users permissions to directly access the underlying tables of the query. 
/*
https://hasura.io/learn/database/microsoft-sql-server/views/?gad_source=1&gclid=CjwKCAjwjsi4BhB5EiwAFAL0YClPjnlmr4i43vYW_3WhSKFdDO8AcYngiXLSbnMktmahxKVIPEU1OxoCyzIQAvD_BwE
*/
CREATE VIEW vwOrders AS 
	SELECT ProductName, CompanyName, OrderDate, OrderDetails.UnitPrice, Quantity, Discount
	FROM Orders LEFT JOIN Customers ON Orders.CustomerID=Customers.CustomerID
				INNER JOIN OrderDetails ON Orders.OrderID=OrderDetails.OrderID
				INNER JOIN Products ON OrderDetails.ProductID=Products.ProductID;
SELECT * FROM vwOrders;

-- To alter a view
ALTER VIEW vwOrders AS 
	SELECT ProductName, 
       CompanyName, 
       OrderDate, 
       OrderDetails.UnitPrice, 
       Quantity, 
       Discount, 
       (OrderDetails.UnitPrice * Quantity * (1 - Discount)) AS TotalPrice
FROM Orders 
LEFT JOIN Customers ON Orders.CustomerID = Customers.CustomerID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID;

sp_helptext 'dbo.vwOrders';

SELECT ProductID, 
       Quantity, 
       SUM(Quantity) OVER (PARTITION BY ProductID) AS TotalQuantity
FROM OrderDetails;


-- ! GROUPING EXTENSION


CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY IDENTITY(1,1),
    Warehouse NVARCHAR(100),
    Product NVARCHAR(100),
    Model NVARCHAR(100),
    Quantity INT CHECK (Quantity >= 0)  -- Ensures quantity is not negative
);

INSERT INTO Inventory (Warehouse, Product, Model, Quantity) VALUES
('San Francisco', 'iPhone', '6s', 50),
('San Francisco', 'iPhone', '7', 10),
('San Francisco', 'iPhone', 'x', 200),
('San Francisco', 'Samsung', 'Galaxy S', 200),
('San Francisco', 'Samsung', 'Note 8', 100),
('San Jose', 'iPhone', '6s', 100),
('San Jose', 'iPhone', '7', 50),
('San Jose', 'iPhone', 'x', 150),
('San Jose', 'Samsung', 'Galaxy S', 200),
('San Jose', 'Samsung', 'Note 8', 150);

SELECT
	Warehouse, SUM(Quantity)
FROM 
	Inventory
GROUP BY Warehouse;

-- ? ROLLUP()
--  An extension of the GROUP BY clause that produces subtotals for each level of aggregation, leading to a grand total. It generates a hierarchical set of summaries for the specified columns.
SELECT
	Warehouse, SUM(Quantity)
FROM 
	Inventory
GROUP BY ROLLUP (Warehouse);

SELECT
	Warehouse,Product, SUM(Quantity)
FROM 
	Inventory
GROUP BY ROLLUP(Warehouse, Product);

-- ? CUBE()
-- An extension of the GROUP BY clause that generates subtotals for all possible combinations of the specified columns. It creates a multi-dimensional view of the data, summarizing across multiple dimensions.
SELECT
	Warehouse,Product, SUM(Quantity)
FROM 
	Inventory
GROUP BY CUBE(Warehouse, Product);

-- ? GROUPING()
-- A function that indicates whether a column is part of a grouping or not. It returns 1 for aggregated columns (subtotals) and 0 for detail rows, useful for distinguishing between them in results.
SELECT 
    Warehouse,
    Product,
    SUM(Quantity) AS TotalQuantity,
    GROUPING(Warehouse) AS IsWarehouseSubtotal,
    GROUPING(Product) AS IsProductSubtotal
FROM Inventory
GROUP BY CUBE(
    Warehouse,
    Product);

-- ? GROUPING SETS()
-- A feature that allows specifying multiple groupings within a single GROUP BY clause. It enables flexible aggregation by defining distinct combinations of columns to summarize data.
SELECT 
    Warehouse,
    Product,
    SUM(Quantity) AS TotalQuantity
FROM Inventory
GROUP BY GROUPING SETS (
    (Warehouse, Product),  -- Total by Warehouse and Product
    (Warehouse),           -- Total by Warehouse
    (Product),             -- Total by Product
    ()                     -- Grand total
);

USE Northwind;

-- Backup and Restoring database
-- ? Full Backup
BACKUP DATABASE Northwind
TO DISK = 'E:\YourDatabaseName_Full.bak';

-- ? Differential Backup:
-- A backup of all changes made since the last full backup. It is smaller and faster than a full backup and can be used alongside it for recovery.

BACKUP DATABASE [YourDatabaseName]
TO DISK = 'C:\SQL2019\Express_ENU\YourDatabaseName_Diff.bak'
WITH DIFFERENTIAL;

CREATE DATABASE Northwind;
-- ? Restore Full Database:
RESTORE DATABASE newDatabase
FROM DISK ='E:\YourDatabaseName_Full.bak';

-- ? Restore Differential Backup:
RESTORE DATABASE [YourDatabaseName]
FROM DISK = 'C:\Backups\YourDatabaseName_Full.bak'
WITH DIFFERENTIAL;


-- CLEANING DATA
SELECT 
    -- REPLICATE: Repeats a string for a specified number of times.
    REPLICATE('SQL', 3) AS RepeatedString,
    -- FORMAT: Formats a value based on a format pattern (e.g., date or numeric).
    FORMAT(GETDATE(), 'dd-MM-yyyy') AS FormattedDate, 
    -- TRIM: Removes leading and trailing spaces from a string.
    TRIM('   Hello World   ') AS TrimmedString, 
    -- REPLACE: Replaces all occurrences of a substring within a string.
    REPLACE('Microsoft SQL Server', 'SQL', 'MySQL') AS ReplacedString;

USE Northwind;

SELECT 
	REPLICATE('0',9 -LEN(CAST(ProductID AS VARCHAR(10))))+CAST(ProductID AS VARCHAR(10)) AS Formated_Ship
FROM Products;


SELECT 
		DISTINCT FORMAT(ShipVia, '0000000') AS Formated_Ship
FROM Orders;



-- ! Window Functions
USE Northwind;
SELECT od.OrderID, 
       SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS OrderAmount,
       SUM(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))) 
           OVER (ORDER BY od.OrderID) AS RunningTotal
FROM [OrderDetails] od
GROUP BY od.OrderID
ORDER BY od.OrderID;



-- ! Programming in SQL