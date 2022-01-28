--Question1
/*
fullName: Angenita Lousi
Username: alou149
*/

--Question2
SELECT ProductID AS 'Product ID', ProductName AS 'Product Name', SupplierID AS 'Supplier ID', 
	   CategoryID AS 'Category ID', QuantityPerUnit AS 'Quantity Per Unit', UnitPrice AS 'Unit Price', 
	   UnitsInStock AS 'Units In Stock', UnitsOnOrder AS 'Units On Order', ReorderLevel As 'Re-order Level', Discontinued
FROM Product;

--Question3
SELECT ProductName, UnitPrice, UnitsInStock
FROM Product
ORDER BY UnitPrice DESC;

--Question4
SELECT Phone
FROM Shipper
WHERE CompanyName = 'United Package';

--Question5
SELECT *
FROM Customer
WHERE Fax IS NOT NULL;

--Question6
SELECT *
FROM 'Order'
WHERE OrderDate BETWEEN '1996-07-01' AND '1996-07-32';

--Question7
SELECT DISTINCT(Country)
FROM Customer
GROUP BY Country;

--Question8
SELECT COUNT(*) AS 'Number of Order'
FROM 'Order';

--Question9
SELECT ProductName 
FROM Product
WHERE ProductName LIKE '_____';

SELECT ProductName
FROM Product
WHERE LENGTH(ProductName) = 5;

--Question10
SELECT ProductName, UnitsInStock
FROM Product
ORDER BY UnitsInStock DESC
LIMIT 10;

--Question11
SELECT UPPER(LastName) || ', ' || FirstName  AS 'full name', Address || ', ' || City || ', ' || PostalCode || ', ' || Country AS 'full address'
FROM Employee;

--Question12
SELECT OrderID, ProductID, '$'||printf('%.2f',UnitPrice) AS 'UnitPrice', Quantity, (Discount * 100) ||'%' AS 'Discount', '$'|| printf('%.2f',((UnitPrice * Quantity) - (UnitPrice*Quantity*Discount))) AS 'Subtotal'
FROM OrderDetail
WHERE OrderID = 10250;

--Question13
SELECT ProductName
FROM Product
WHERE ProductName LIKE 'C%'
	AND (CategoryID = 1 OR CategoryID = 2)
	AND (UnitPrice > 20)
	AND Discontinued = false;

--Question14
INSERT INTO [Shipper]([CompanyName], [Phone]) 
VALUES('Trustworthy Delivery', '(503) 555-1122'),
	   ('Amazing Pace', '(503) 555-3421'),
	   ('Angenita Lousi', '(503) 292-4286')
	   
--Question15
SELECT FirstName, LastName, CAST((JULIANDAY('now') - JULIANDAY(BirthDate))/365 AS INT) AS Age 
FROM Employee;

--Question16
UPDATE Employee
SET TitleOfCourtesy = 'Mrs.',
	LastName = (
		SELECT LastName 
		FROM Employee
		WHERE EmployeeID = 2
		)
WHERE EmployeeID = 1;

--Question17
UPDATE Employee
SET(Address, City, Region, PostalCode, HomePhone) = (
		SELECT Address, City, Region, PostalCode, HomePhone 
		FROM Employee
		WHERE EmployeeID = 2)	
WHERE EmployeeID = 1;

--Question18
CREATE TABLE [ProductHistory](
[ProductID] INTEGER NOT NULL,
[EntryDate] DATE NOT NULL,
[UnitPrice] REAL, 
[UnitsInStock] INTEGER,
[UnitsOnOrder] INTEGER,
[ReorderLevel] INTEGER,
[Discontinued] INTEGER NOT NULL,
CONSTRAINT prodhistory_PK PRIMARY KEY ([ProductID], [EntryDate]),
CONSTRAINT prodhistory_FK FOREIGN KEY ([ProductID])
REFERENCES Product([ProductID])
);

--Question19
INSERT INTO [ProductHistory]([ProductID], [EntryDate], [UnitPrice], [UnitsInStock], [UnitsOnOrder], [ReorderLevel], [Discontinued])
SELECT ProductID, datetime('now','localtime'), UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued
FROM Product;

--Question20
SELECT 
	   CASE CAST (strftime('%w', HireDate) as INT)
			WHEN 0 THEN 'Sunday'
			WHEN 1 THEN 'Monday'
			WHEN 2 THEN 'Tuesday'
			WHEN 3 THEN 'Wednesday'
			WHEN 4 THEN 'Thursday'
			WHEN 5 THEN 'Friday'
		ELSE 'Saturday'
		END AS 'Day of Week', COUNT(*) AS 'Hired'
FROM Employee
GROUP BY 
	   CASE CAST (strftime('%w', HireDate) as INT)
			WHEN 0 THEN 'Sunday'
			WHEN 1 THEN 'Monday'
			WHEN 2 THEN 'Tuesday'
			WHEN 3 THEN 'Wednesday'
			WHEN 4 THEN 'Thursday'
			WHEN 5 THEN 'Friday'
		ELSE 'Saturday'
		END;

--Question21
SELECT e.LastName, e.FirstName, '$'||printf('%.2f',SUM(OD.Quantity * OD.UnitPrice)) AS 'Total'
FROM 'Order' o
	JOIN Employee e 
		ON e.EmployeeID = o.EmployeeID
	JOIN OrderDetail OD 
		ON o.OrderID = OD.OrderID
GROUP BY e.EmployeeID
ORDER BY SUM(OD.Quantity * OD.UnitPrice) DESC
LIMIT 1;

--Question22
SELECT e.FirstName AS 'Employee', ifnull(manager.FirstName, 'No manager') Manager
FROM Employee e
LEFT JOIN Employee manager ON e.ReportsTo = manager.EmployeeID
GROUP BY e.EmployeeID;

--Question23
SELECT c.CompanyName AS 'Company', 
	   '$'||printf('%.2f', ROUND(p.UnitPrice, 2))  AS 'Recommended', 
	   '$'||printf('%.2f', ROUND(OD.UnitPrice, 2)) AS 'Ordered', 
	   '$'||printf('%.2f', abs(ROUND((p.UnitPrice - OD.UnitPrice), 2))) AS 'Discount', 
	   printf('%.2f', ROUND(((p.UnitPrice - OD.UnitPrice) / p.UnitPrice) * 100, 2)) || '%' AS 'Percentage'
FROM 'Order' o
	 JOIN Customer c     ON c.CustomerID = o.CustomerID 
	 JOIN OrderDetail OD ON o.OrderID = OD.OrderID
	 JOIN Product p      ON OD.ProductID = p.ProductID
GROUP BY o.OrderID
ORDER BY ((p.UnitPrice - OD.UnitPrice)/ p.UnitPrice) DESC;

--Question24
SELECT o.ShipCountry, s.CompanyName
FROM 'Order' o
INNER JOIN Shipper s ON o.ShipVia = s.ShipperID
GROUP BY o.ShipCountry
order by round(AVG(o.Freight),2) DESC;




