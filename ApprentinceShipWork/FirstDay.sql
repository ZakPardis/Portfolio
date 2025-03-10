USE Northwind;

-- Retrieve the first 5 records from the Customers table.
SELECT TOP 5 * FROM Customers;

-- Skip the first 5 records in the Employees table and return the rest.
SELECT * FROM Employees ORDER BY EmployeeID OFFSET 5 ROWS;

-- To skip the first 3 records and return the next 5 records from the Employees table
SELECT * FROM Employees 
ORDER BY EmployeeID 
OFFSET 3 ROWS 
FETCH NEXT 5 ROWS ONLY;

-- Select all customers located in Germany from the Customers table.

SELECT * FROM Customers WHERE Country = 'Germany';

-- UNION
-- UNION ALL
-- INTERSECT
-- EXCEPT
-- IN
-- BETWEEN
-- LIKE
-- LIKE
-- IS NULL
-- IS NOT NULL
-- ANY
-- ALL
-- EXISTS
-- SOME




--UNION (Combines results of two queries, removing duplicates)
--UNION ALL (Combines results of two queries, including duplicates)
--INTERSECT (Returns common records from two queries)
--EXCEPT (Returns records from the first query that are not in the second query)
--10. Other Operators
--IN (Checks if a value is within a set of values)
--BETWEEN (Checks if a value is within a specified range)
--LIKE (Matches a pattern)
--IS NULL (Checks for null values)
--IS NOT NULL (Checks for non-null values)
--ANY (Compares a value to any value in a list)
--ALL (Compares a value to all values in a list)
--EXISTS (Checks if a subquery returns any rows)
--SOME (Similar to ANY, used with subqueries)

-- ------------------------- INTERSECT
-- Employees table
SELECT EmployeeID, Name FROM Employees;

-- Managers table
SELECT EmployeeID, Name FROM Managers;

-- Find common records between Employees and Managers (those who are both employees and managers)
SELECT EmployeeID, Name
FROM Employees
INTERSECT
SELECT EmployeeID, Name
FROM Managers;





-- ! Aggregate functions
-- An aggregate function is a function that performs a calculation on a set of values, and returns a single value
-- AVG(), MAX(), MIN(), SUM(), COUNT()

-- Find out number of employees working in your company
SELECT COUNT(*) AS 'Number of Emp' FROM Employees;
-- Count the number of customers in each country.
SELECT Country, COUNT(*) AS CustomerCount FROM Customers GROUP BY Country;


-- ! SQL Alias
-- SQL aliases are used to give a table, or a column in a table, a temporary name. Aliases are often used to make column names more readable. 

-- ! Group By

--For example, let us suppose you have a table of sales data of an organization consisting of date, product, and sales amount. To calculate the total sales in a particular year, the GROUP BY clause can be used to group the sales of products made in that year. Similarly, you can group the data by date to calculate the total sales for each day, or by a combination of product and date to calculate the total sales for each product on each day.

-- Count the Number of Customers per City
SELECT City, COUNT(CustomerID) AS NumberOfCustomers
FROM Customers
GROUP BY City
ORDER BY NumberOfCustomers DESC;

-- Count the Number of Products per Supplier
SELECT SupplierID, COUNT(ProductID) AS NumberOfProducts
FROM Products
GROUP BY SupplierID
ORDER BY NumberOfProducts DESC;


-- List Customers and the Number of Orders They Placed
SELECT c.CustomerID, c.CompanyName, COUNT(o.OrderID) AS TotalOrders
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY TotalOrders DESC;

-- ! HAVING
-- Find Cities with More than 5 Customers
SELECT City, COUNT(CustomerID) AS NumberOfCustomers
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) > 5
ORDER BY NumberOfCustomers DESC;



-- --------------------------------------------------------------------

-- Retrieve products sorted from the most expensive to the least expensive.
SELECT * FROM Products ORDER BY Price DESC;

-- Sort employees first by their city and then by last name within each city.
SELECT * FROM Employees ORDER BY City, LastName;

-- Count the number of customers in each country.
SELECT Country, COUNT(*) AS CustomerCount FROM Customers GROUP BY Country;

-- Task 12: Count the number of customers in each city and country.
SELECT City, Country, COUNT(*) AS CustomerCount FROM Customers GROUP BY City, Country;

-- Task 13: Calculate the average price of products in each category.
SELECT CategoryID, AVG(Price) AS AveragePrice FROM Products GROUP BY CategoryID;

-- Task 14: Find the total number of orders placed by each customer.
SELECT CustomerID, COUNT(*) AS OrderCount FROM Orders GROUP BY CustomerID;

-- Task 15: Retrieve categories that have more than 10 products.
SELECT CategoryID, COUNT(*) AS ProductCount FROM Products GROUP BY CategoryID HAVING COUNT(*) > 10;

-- Task 16: Find employees whose total freight amounts exceed 1000.
-- Ensure Freight column exists in Orders table.
SELECT EmployeeID, SUM(Freight) AS TotalFreight FROM Orders GROUP BY EmployeeID HAVING SUM(Freight) > 1000;

-- Task 17: Get the total sales for each customer, but only for those with total sales greater than 5000.
-- Assuming there's a TotalAmount or equivalent in Orders.
SELECT CustomerID, SUM(TotalAmount) AS TotalSales FROM Orders GROUP BY CustomerID HAVING SUM(TotalAmount) > 5000;

-- Task 18: Count the number of orders per employee and return only those with more than 5 orders.
SELECT EmployeeID, COUNT(*) AS OrderCount FROM Orders GROUP BY EmployeeID HAVING COUNT(*) > 5;

-- -------------------------------------------------------------------------



-- ! JOINS
-- INNER JOIN =>
-- LEFT JOIN =>
-- RIGHT JOIN =>



-- SINGLE JOINS --
USE Northwind;
-- 1. Retrieve a list of all products along with their category names (INNER JOIN)
SELECT 
    Products.ProductID,
    Products.ProductName,
    Categories.CategoryName
FROM Products
JOIN Categories ON Products.CategoryID = Categories.CategoryID;

-- 2. Fetch all orders with customer names, including orders without a customer (LEFT JOIN)
SELECT 
    Orders.OrderID,
	Orders.OrderDate,
    Customers.CompanyName
FROM Orders
LEFT JOIN Customers ON Orders.CustomerID = Customers.CustomerID;

-- 3. List orders with the name of the employee who handled them
SELECT 
    Orders.OrderID,
    Employees.FirstName,
    Employees.LastName
FROM Orders
JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID;


-- DOUBLE JOINS --

-- Retrieve detailed order information, product names, and category names
SELECT 
    OrderDetails.OrderID,
    Products.ProductName,
    Categories.CategoryName,
    OrderDetails.Quantity,
    OrderDetails.UnitPrice
FROM OrderDetails
JOIN Products ON OrderDetails.ProductID = Products.ProductID
JOIN Categories ON Products.CategoryID = Categories.CategoryID;

-- List all orders, employees, and customers, including customers who haven't placed orders 
SELECT 
    Orders.OrderID,
    Employees.FirstName,
    Employees.LastName,
    Customers.CompanyName
FROM Orders
RIGHT JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
RIGHT JOIN Customers ON Orders.CustomerID = Customers.CustomerID;

-- 3. Retrieve product details with supplier and category information (INNER JOIN)
SELECT 
    Products.ProductID,
    Products.ProductName,
    Suppliers.CompanyName,
    Categories.CategoryName
FROM Products
JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
JOIN Categories ON Products.CategoryID = Categories.CategoryID;


-- TRIPLE JOINS --

-- 1. Get detailed order information with product and supplier details
SELECT 
    Orders.OrderID,
    Products.ProductName,
    Suppliers.CompanyName,
    OrderDetails.Quantity
FROM Orders
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID;

-- 2. List all orders with product and category details, even if there's missing product or category information 
SELECT 
    Orders.OrderID,
    Products.ProductName,
    Categories.CategoryName,
    OrderDetails.Quantity
FROM Orders
LEFT JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
LEFT JOIN Products ON OrderDetails.ProductID = Products.ProductID
LEFT JOIN Categories ON Products.CategoryID = Categories.CategoryID;

-- 3. Retrieve a list of orders, employees, customers, and shippers (INNER JOIN)
SELECT 
    Orders.OrderID,
    CONCAT(Employees.FirstName,' ',Employees.LastName) AS 'Employee',
    Customers.CompanyName,
    Shippers.CompanyName AS 'Shipping Company'
FROM Orders
JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
JOIN Shippers ON Orders.ShipVia = Shippers.ShipperID;



-- Display all Customers and the product name they have ordered.
-- display all products and their categories and sort the result based on the product name in ascending order.
-- display all customers and number of order they have made
-- display a customer who has made the most orders.


-- Subquery in SQL?
-- In SQL, a subquery is a query that is nested inside another query. SQL subqueries are also called nested queries or inner queries, while the SQL statement containing the subquery is typically referred to as an outer query.
-- You can use SQL subqueries in SELECT, INSERT, UPDATE, and DELETE statements. Specifically, you can nest a subquery in the SELECT, FROM, WHERE, JOIN, and HAVING SQL clauses. Also, you can adopt SQL queries in conjunction with several SQL operators, such as =, <, >, >=, <=, IN, NOT IN, EXISTS, NOT EXISTS, and more.


-- Why Use SQL Subqueries?
-- Subqueries are particularly useful because they allow you to embed specific query logic into a more general query. Thus, by running a single query, you can get results that would naturally require multiple queries. This can lead to benefits in terms of readability, maintainability, and even performance.


-- Type of Subqueries:
-- There are several types of subqueries. The most important ones are:
-- Single-row subquery => This type of subquery is often used in conjunction with comparison operators
-- Multi-row subquery => his type of subquery typically uses operators such as IN, ANY, or ALL
-- Correlated subquery => A subquery that references columns from the outer query. It is executed once for each row processed by the outer query.
-- Scalar Subquery => A subquery that returns a single value (a single row with a single column). This can be used wherever a single value is expected.

USE Northwind;
 -- ? ?????????????
--IN	Checks if a value is in a set or results from a subquery.
--EXISTS	Checks for the existence of records from a subquery.
--ANY	Checks if a condition is true for any value in the result of a subquery.
--ALL	Checks if a condition is true for all values returned by a subquery.

-- ? Single-row subquery
-- Retrieve all products which has the highest price
SELECT * FROM Products
WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM Products);

-- Explanation: 
-- This query selects the product with the highest price from the Products table. 
-- The subquery (SELECT MAX(UnitPrice) FROM Products) returns the highest price, and the main query fetches the product that matches this price.

-- 2. Find the employee with the earliest hire date
SELECT * FROM Employees
WHERE HireDate = (SELECT MIN(HireDate) FROM Employees);

-- Explanation: 
-- This query selects the employee with the earliest birthdate from the Employees table.
-- The subquery (SELECT MIN(BirthDate) FROM Employees) returns the earliest birthdate, and the main query fetches the employee with that birthdate.

-- ? Multi-row subquery

-- 2. Find all customers from countries where there are employees located
SELECT * FROM Customers
WHERE Country IN (
    SELECT DISTINCT Country FROM Employees
);

-- Explanation:
-- This query selects all customers who live in countries where employees are also located.
-- The subquery (SELECT DISTINCT Country FROM Employees) fetches all distinct countries where employees are located.
-- The main query returns all customers from those countries.


-- ? Correlated Subquery
-- List all employees who have placed orders with a total order amount greater than their own average order amount.
SELECT EmployeeID, OrderID, OrderDate, TotalAmount
FROM Orders AS o
WHERE TotalAmount > (
    SELECT AVG(TotalAmount)
    FROM Orders
    WHERE EmployeeID = o.EmployeeID
);

-- Find all orders where the order date is earlier than the customer's first order
SELECT * FROM Orders o
WHERE OrderDate < (
    SELECT MIN(OrderDate) FROM Orders o2 WHERE o.CustomerID = o2.CustomerID
);

-- Explanation:
-- This is a correlated subquery because the inner query refers to the outer query's `CustomerID`.
-- The subquery (SELECT MIN(OrderDate) FROM Orders o2 WHERE o.CustomerID = o2.CustomerID) finds the earliest order date for each customer.
-- The main query selects orders where the order date is earlier than the first order date.

-- 2. List all products that have a price greater than the average price of products from the same supplier
SELECT * FROM Products p1
WHERE Price > (
    SELECT AVG(Price) FROM Products p2 WHERE p1.SupplierID = p2.SupplierID
);

-- Explanation:
-- This is another correlated subquery where the inner query refers to the outer query's `SupplierID`.
-- The subquery (SELECT AVG(Price) FROM Products p2 WHERE p1.SupplierID = p2.SupplierID) calculates the average price of products for each supplier.
-- The main query retrieves products that are priced above their supplier's average product price.



-- ? Scalar Subquery
-- Show each product's name and unit price along with the average unit price across all products.
SELECT ProductName, UnitPrice,
       (SELECT AVG(UnitPrice) FROM Products) AS AvgUnitPrice
FROM Products;


-- ? Multi-column subquery- Can't do in MS SQL Server
-- 1. Find the products that have the same unit price and quantity per unit as any product in the Beverages category
SELECT ProductName, UnitPrice, QuantityPerUnit, UnitsInStock FROM Products
WHERE (UnitPrice, QuantityPerUnit) IN (
    SELECT  UnitPrice, QuantityPerUnit FROM Products WHERE CategoryID = 1
);

-- Explanation:
-- This query selects all products that have the same price and unit as products in the Beverages category.
-- The subquery (SELECT Price, Unit FROM Products WHERE CategoryID = 1) finds the price and unit for products in the Beverages category (assuming CategoryID = 1).
-- The main query returns products that match those price and unit combinations.

-- 2. Get the employees who are located in the same city and country as "Ernst Handel" customer
SELECT * FROM Employees
WHERE (City, Country) IN (
    SELECT City, Country FROM Customers WHERE CustomerName = 'Ernst Handel'
);

-- Explanation:
-- This query retrieves employees located in the same city and country as the customer "Ernst Handel".
-- The subquery (SELECT City, Country FROM Customers WHERE CustomerName = 'Ernst Handel') retrieves the city and country of the customer.
-- The main query fetches employees who are in the same location.



-- ! LIKE Keyword

-- SQL WildCard and REGEXP

-- SQL Server Pattern Matching using LIKE and PATINDEX
USE NorthWind;
-- Task 1: Find customers whose names contain a digit (SQL Server)
SELECT CustomerID, CompanyName
FROM Customers
WHERE PATINDEX('%[0-9]%', CompanyName) > 0;

-- Task 2: Find customers whose names start with 'A' and end with 'n' (SQL Server)
SELECT CustomerID, CompanyName
FROM Customers
WHERE CompanyName LIKE 'A%n';

-- Task 3: Find customers whose names are exactly 5 characters long (SQL Server)
SELECT CustomerID, CustomerName
FROM Customers
WHERE CompanyName LIKE '_____';  -- Five underscores for five characters

-- Task 4: Find customers whose names contain either 'S', 'T', or 'U' (SQL Server)
SELECT CustomerID, CompanyName
FROM Customers
WHERE CompanyName LIKE '%[STU]%';


-- ! PATINDEX 
-- function is used to find the starting position of a specified pattern within a given expression, typically a string. It returns the starting position as an integer. If the pattern is not found, it returns 0


-- Task 5: Find the position of the letter 'e' in customer names (SQL Server)
SELECT CustomerID, CompanyName, PATINDEX('%e%', CompanyName) AS PositionOfE
FROM Customers
WHERE PATINDEX('%e%', CompanyName) > 0;


-- !CHARINDEX()
-- CHARINDEX: Searches for an exact substring within a string
-- is case sensitive
SELECT CHARINDEX('SQL', 'Microsoft SQL Server');

-------------------------------------------------------------
-- MySQL Regular Expression Matching using REGEXP

-- Task 6: Find customers whose names contain a digit (MySQL)
SELECT CustomerID, CustomerName
FROM Customers
WHERE CustomerName REGEXP '[0-9]';

-- Task 7: Find customers whose names start with 'A' and end with 'n' (MySQL)
SELECT CustomerID, CustomerName
FROM Customers
WHERE CustomerName REGEXP '^A.*n$';

-- Task 8: Find customers whose names are exactly 5 characters long (MySQL)
SELECT CustomerID, CustomerName
FROM Customers
WHERE CustomerName REGEXP '^.{5}$';  -- Regex for exactly 5 characters

-- Task 9: Find customers whose names contain either 'S', 'T', or 'U' (MySQL)
SELECT CustomerID, CustomerName
FROM Customers
WHERE CustomerName REGEXP '[STU]';

-- Task 10: Find customers whose names start with a vowel and end with a consonant (MySQL)
SELECT CustomerID, CustomerName
FROM Customers
WHERE CustomerName REGEXP '^[AEIOUaeiou].*[bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ]$';


-- ? The CHARINDEX function in MS SQL Server is used to find the position of a substring within a string. It returns the starting position of the first occurrence of the substring in the string. If the substring is not found, it returns 0.
-- Task 1: Find the position of the first occurrence of the letter 'A' in customer names (case-insensitive).
SELECT CustomerID, CustomerName, CHARINDEX('A', CustomerName) AS PositionOfA
FROM Customers
WHERE CHARINDEX('A', CustomerName) > 0;

-- Task 2: Find the position of the substring 'Ltd' in customer names and return only customers where 'Ltd' is present.
SELECT CustomerID, CustomerName, CHARINDEX('Ltd', CustomerName) AS PositionOfLtd
FROM Customers
WHERE CHARINDEX('Ltd', CustomerName) > 0;

-- Task 3: Search for the first occurrence of the letter 'n' in customer names, starting from the 5th position.
SELECT CustomerID, CustomerName, CHARINDEX('n', CustomerName, 5) AS PositionOfN_After5thChar
FROM Customers
WHERE CHARINDEX('n', CustomerName, 5) > 0;

-- Task 4: Find customers whose name contains the word 'International' and display the position where it starts.
SELECT CustomerID, CustomerName, CHARINDEX('International', CustomerName) AS PositionOfInternational
FROM Customers
WHERE CHARINDEX('International', CustomerName) > 0;

-- Task 5: Find customers whose names contain the letter 'e' and return the position of its first occurrence.
SELECT CustomerID, CustomerName, CHARINDEX('e', CustomerName) AS PositionOfE
FROM Customers
WHERE CHARINDEX('e', CustomerName) > 0;




-- ! ISNULL vs COALESCE
-- ISNULL(expression, replacement) returns replacement if expression is NULL; otherwise, it returns expression.
-- COALESCE(expression1, expression2, ..., expressionN) returns the first non-NULL expression from a list of expressions.

-- ? ISNULL is slightly faster than COALESCE when checking for NULL in a single expression, 

-- ?
-- ISNULL returns the data type of the first argument.
-- COALESCE returns the data type with the highest precedence among the expressions.


-- Task 1: Retrieve all customers and show 'No Address Provided' if the Address field is NULL using COALESCE.
SELECT CustomerID, 
       CustomerName, 
       COALESCE(Address, 'No Address Provided') AS Address
FROM Customers;

-- Task 2: Find products that do not have a description and display 'No Description' if ProductDescription is NULL using IFNULL.
SELECT ProductID, 
       ProductName, 
       ISNULL(ProductDescription, 'No Description') AS ProductDescription
FROM Products;

-- Task 3: Get the total freight amount for each order, showing 'Freight not available' for orders with NULL freight using COALESCE.
SELECT OrderID, 
       COALESCE(Freight, 'Freight not available') AS FreightAmount
FROM Orders;

-- Task 4: List all employees and show 'Unknown Hire Date' if the HireDate is NULL using IFNULL.
SELECT EmployeeID, 
       EmployeeName, 
       ISNULL(CONVERT(VARCHAR, HireDate, 101), 'Unknown Hire Date') AS HireDate
FROM Employees;

-- Task 5: Retrieve categories, and for any NULL CategoryName, display 'No Category' instead using COALESCE.
SELECT CategoryID, 
       COALESCE(CategoryName, 'No Category') AS CategoryName
FROM Categories;

-- Task 6: Find all orders and display the CustomerID; if the CustomerID is NULL, show 'Unknown Customer' using IFNULL.
SELECT OrderID, 
       ISNULL(CustomerID, 'Unknown Customer') AS CustomerID
FROM Orders;

-- Task 7: Get a list of products with their unit prices, showing 'Price Not Available' for any NULL UnitPrice using COALESCE.
SELECT ProductID, 
       ProductName, 
       COALESCE(CONVERT(VARCHAR, UnitPrice), 'Price Not Available') AS UnitPrice
FROM Products;

-- Task 8: List all suppliers and indicate 'No Contact Name' if the ContactName is NULL using IFNULL.
SELECT SupplierID, 
       SupplierName, 
       ISNULL(ContactName, 'No Contact Name') AS ContactName
FROM Suppliers;

-- Task 9: Retrieve a list of customers, showing their phone numbers; if NULL, display 'No Phone Number' using COALESCE.
SELECT CustomerID, 
       CompanyName, 
       COALESCE(Phone, 'No Phone Number') AS PhoneNumber
FROM Customers;

-- Task 10: Find orders with NULL shipping information and display 'Shipping Info Not Available' using IFNULL.
SELECT OrderID, 
       ISNULL(ShipVia, 'Shipping Info Not Available') AS ShippingInfo
FROM Orders;





-- ! Date and Time 
https://learn.microsoft.com/en-us/sql/t-sql/functions/date-and-time-data-types-and-functions-transact-sql?view=sql-server-ver16

--GETDATE(): Returns the current system date and time.
--DATEADD(): Adds or subtracts intervals (such as days, months, years) to a date. In Task 2, 10 days are added to the current date.
--DATEDIFF(): Calculates the difference between two dates in the specified interval (e.g., years, months, days). In Task 3, the difference in years is calculated.
--DATENAME(): Returns a specific date part (e.g., month, year) as a string. In Task 4, the name of the current month is returned.
--DATEPART(): Extracts a part of a date (e.g., year, month, day) as an integer. In Task 5, the current month number is returned.
--CONVERT(): Converts a date to a string using a specified format. Task 6 converts the current date to the YYYY-MM-DD format.
--YEAR(), MONTH(), DAY(): These functions individually extract the year, month, and day from a date. Task 7 demonstrates extracting all three.
-- ? EOMONTH(): Returns the last day of the specified month. In Task 8, the last day of the current month is retrieved.
--SYSDATETIME(): Similar to GETDATE(), but provides higher precision, down to fractions of a second.
--ISDATE(): Checks if a value is a valid date format. In Task 10, it checks if a string is a valid date and returns 1 (true) or 0 (false).
--Use Cases:
--DATEADD is often used for calculating due dates, deadlines, or scheduling.
--DATEDIFF is useful in calculating the time difference between two events.
--CONVERT and FORMAT are useful for formatting dates for display purposes.

-- Task 1: Get the current date and time using GETDATE()
SELECT GETDATE() AS CurrentDateTime;

-- Task 2: Add 10 days to the current date using DATEADD()
SELECT DATEADD(day, 10, GETDATE()) AS DateAfter10Days;

-- Task 3: Calculate the difference in years between two dates using DATEDIFF()
-- Let's compare the difference between '2024-01-01' and today's date
SELECT DATEDIFF(year, '2023-01-01', GETDATE()) AS YearsDifference;

SELECT OrderID, DATEDIFF(YEAR, OrderDate, GETDATE()) AS YearsSinceOrder
FROM Orders;

-- Task 4: Get the name of the current month using DATENAME()
SELECT DATENAME(month, GETDATE()) AS CurrentMonthName;

-- Task 5: Get the numeric value of the current month using DATEPART()
SELECT DATEPART(month, GETDATE()) AS CurrentMonthNumber;

-- Task 6: Convert a date to a specific format using CONVERT()
-- Example of converting to 'YYYY-MM-DD' format (style 23)
SELECT CONVERT(VARCHAR(10), GETDATE(), 23) AS FormattedDate;

-- Task 7: Extract the year, month, and day using YEAR(), MONTH(), and DAY()
SELECT 
    YEAR(GETDATE()) AS CurrentYear,
    MONTH(GETDATE()) AS CurrentMonth,
    DAY(GETDATE()) AS CurrentDay;

-- Task 8: Get the last day of the current month using EOMONTH()
SELECT EOMONTH(GETDATE()) AS LastDayOfCurrentMonth;

-- Task 9: Get the current system date and time with higher precision using SYSDATETIME()
SELECT SYSDATETIME() AS HighPrecisionCurrentDateTime;

-- Task 10: Check if a value is a valid date using ISDATE()
SELECT ISDATE('2024-10-14') AS IsValidDate;  -- Returns 1 if valid, 0 if invalid


-- ! USER DEFINED Functions
-- Users create custom functions that can be reused throughout the database. These functions can encapsulate complex logic, enabling users to perform operations on data in a modular way.

-- ? Syntax:
CREATE FUNCTION function_name (parameters)
RETURNS return_type
AS
BEGIN
    -- function logic
    RETURN value; -- or RETURN table; for table-valued functions
END;

-- ? Why Use User Defined Functions?
--Code Reusability: UDFs allow you to encapsulate frequently used logic in one place. This reduces code duplication and makes it easier to maintain and update code.

--Modularity: Functions help organize code by breaking it down into smaller, manageable pieces. This modularity improves readability and maintainability.

--Complex Calculations: UDFs can perform complex calculations that would be cumbersome to replicate in multiple queries. This helps centralize business logic in the database.

--Improved Performance: In some cases, using UDFs can lead to performance improvements by reducing the need for repetitive calculations across multiple queries. However, this can vary depending on the specific use case.

--Integration with SQL Queries: UDFs can be easily integrated into SQL queries, making it straightforward to apply complex logic to data manipulation and retrieval.

--Encapsulation of Business Logic: UDFs allow you to encapsulate business rules within the database. This ensures consistency across applications that interact with the database.

--Parameterization: Functions can accept parameters, allowing for dynamic behavior based on input values. This makes them versatile and useful for various scenarios.


-- ? Type of Functions
-- Scalar Functions: These return a single value (e.g., an integer, decimal, or string) and can be used in SQL statements wherever an expression is valid.

-- Table-Valued Functions: These return a table and can be used in the FROM clause of a SELECT statement, similar to a view.


-- ? Example Use Cases
--Validation: A function that checks if a given string is a valid date.
--Calculations: Functions that calculate tax, discounts, or shipping costs based on order details.
--Data Transformation: Functions that format or convert data, such as converting currency values or formatting dates.


-- Task 1: Easy Task - Create a scalar function to return the total number of products
CREATE FUNCTION TotalProducts()
RETURNS INT
AS
BEGIN
    DECLARE @Total INT;
    SELECT @Total = COUNT(*) FROM Products;
    RETURN @Total;
END;
GO

-- Call the function to get the total number of products
SELECT dbo.TotalProducts() AS TotalProducts;


-- Task 2: Medium Task - Create a scalar function to calculate the total price of an order
CREATE FUNCTION dbo.OrderTotalPrice(@OrderID INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalPrice DECIMAL(10, 2);
    SELECT @TotalPrice = SUM(UnitPrice * Quantity)
    FROM [Order Details]
    WHERE OrderID = @OrderID;
    RETURN @TotalPrice;
END;
GO

-- Call the function for a specific order (example: OrderID = 10248)
SELECT dbo.OrderTotalPrice(10248) AS TotalOrderPrice;


-- Task 3: Medium Task - Create a table-valued function to return customers from a specific country
CREATE FUNCTION dbo.CustomersByCountry(@Country NVARCHAR(50))
RETURNS @Customers TABLE
(
    CustomerID NVARCHAR(5),
    CompanyName NVARCHAR(40),
    ContactName NVARCHAR(30),
    Country NVARCHAR(15)
)
AS
BEGIN
    INSERT INTO @Customers
    SELECT CustomerID, CompanyName, ContactName, Country
    FROM Customers
    WHERE Country = @Country;
    RETURN;
END;
GO


-- Call the function to get customers from 'Germany'
SELECT * FROM dbo.CustomersByCountry('Germany');


-- Task 4: Complex Task - Create a scalar function to calculate the average order total for a specific customer
CREATE FUNCTION dbo.AverageOrderTotalByCustomer(@CustomerID NVARCHAR(5))
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @AverageTotal DECIMAL(10, 2);
    SELECT @AverageTotal = AVG(OrderTotal)
    FROM (
        SELECT SUM(UnitPrice * Quantity) AS OrderTotal
        FROM [Order Details] OD
        INNER JOIN Orders O ON O.OrderID = OD.OrderID
        WHERE O.CustomerID = @CustomerID
        GROUP BY O.OrderID
    ) AS OrderTotals;
    RETURN @AverageTotal;
END;
GO

-- Call the function for a specific customer (example: 'ALFKI')
SELECT dbo.AverageOrderTotalByCustomer('ALFKI') AS AvgOrderTotal;


-- Task 5: Complex Task - Create a table-valued function to return orders within a date range
CREATE FUNCTION dbo.OrdersWithinDateRange(@StartDate DATE, @EndDate DATE)
RETURNS @Orders TABLE
(
    OrderID INT,
    CustomerID NVARCHAR(5),
    OrderDate DATE,
    ShipCountry NVARCHAR(15)
)
AS
BEGIN
    INSERT INTO @Orders
    SELECT OrderID, CustomerID, OrderDate, ShipCountry
    FROM Orders
    WHERE OrderDate BETWEEN @StartDate AND @EndDate;
    RETURN;
END;
GO

-- Call the function to get orders between '1996-07-01' and '1996-07-31'
SELECT * FROM dbo.OrdersWithinDateRange('1996-07-01', '1996-07-31');
