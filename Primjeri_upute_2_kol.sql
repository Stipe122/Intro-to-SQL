/*PRIMJERI SQL*/

/*PODUPITI*/

--Pronađite naziv tvrtke koja je naručila narudžbu OrderId = 10290.
SELECT CustomerID, CompanyName
FROM Customers
WHERE CustomerID = (SELECT CustomerID
 FROM Orders
 WHERE OrderID = 10290);

 --Pronađite naziv tvrtke koja je ostvarila narudžbu OrderId = 10290.
SELECT CustomerID, CompanyName
FROM Customers c INNER JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE OrderID = 10290

-- Pronađite nazive tvrtki koja su ostvarile narudžbu 1997 g.
SELECT CustomerID, CompanyName
FROM Customers
WHERE CustomerID IN (SELECT CustomerID
 FROM Orders
 WHERE OrderDate BETWEEN '1997-01-01' AND '1997-12-31');

-- Pronađite nazive tvrtki koje nisu ostvarile narudžbu 1997 g.
SELECT CustomerID, CompanyName
FROM Customers
WHERE CustomerID NOT IN (SELECT CustomerID
 FROM Orders
 WHERE OrderDate BETWEEN '1997-01-01' AND '1997-12-31');

 /* PODUPITI U LISTI ATRIBUTA*/

 /* Napravite upit koji daje OrderID i OrderDate zadnje narudžbe otpremljene
u Pariz.
 Takoðer ispišite datum zadnje narudžbe bez obzira na grad dostave
narudžbe.
 Ispišite razliku u danima izmeðu ta dva datuma. */

SELECT TOP 1 OrderId,
 OrderDate AS Last_Paris_Order,
 (SELECT MAX(OrderDate) FROM Northwind.dbo.Orders) Last_OrderDate,
 DATEDIFF(dd,OrderDate,(SELECT MAX(OrderDate) FROM
Northwind.dbo.Orders)) Day_Diff
 FROM Northwind.dbo.Orders
 WHERE ShipCity = 'Paris'
 ORDER BY OrderDate DESC

  /* PODUPITI U FROM IZRAZU */

 /* Ispišite narudžbe i datume narudžbi svih zaposlenika iz Londona */
SELECT OrderId,
 Orderdate,
 FirstName,
 LastName
FROM (SELECT EmployeeId, FirstName, LastName
 FROM Employees
 WHERE city = 'London') e
JOIN Orders o
 ON o.EmployeeId = e.EmployeeId

   /* PODUPITI LISTA */

 -- Pronađite nazive tvrtki koja su ostvarile narudžbu 1997 g.
SELECT CustomerID, CompanyName
FROM Customers
WHERE CustomerID IN (SELECT CustomerID
 FROM Orders
 WHERE OrderDate BETWEEN '1997-01-01' AND '1997-12-31');
-- Pronađite nazive tvrtki koje nisu ostvarile narudžbu 1997 g.
SELECT CustomerID, CompanyName
FROM Customers
WHERE CustomerID NOT IN (SELECT CustomerID
 FROM Orders
 WHERE OrderDate BETWEEN '1997-01-01' AND '1997-12-31');

 /*KORELIRANI PODUPITI */

 /*
Ispišite listu narudžbi kod kojih kupac nije kupio više od 10% prosjeène
količine prodaje za odreðeni proizvod,
u svrhu odreðivanje razloga male naručene količine.
*/
SELECT DISTINCT OrderId
 FROM "Order Details" od
WHERE Quantity > (SELECT AVG(Quantity) * .1
 FROM "Order Details"
 WHERE od.ProductID = ProductID)
ORDER BY OrderId

/* Ispišite listu kupaca koji su naručili više do 20 komada proizvoda
ProductID = 23 u jednoj narudžbi. */
SELECT OrderID, CustomerID
FROM Orders o
WHERE 20 < (SELECT Quantity
 FROM [Order Details] od
 WHERE o.OrderID = od.OrderID AND od.ProductID = 23)

 /* Ovaj primjer koristi korelirani podupit s EXISTS ključnom riječi za
dohvaćanje liste zaposlenika koji su zaprimili narudžbe 9/2/97 */
SELECT LastName, EmployeeID
FROM Employees e
WHERE EXISTS (SELECT * FROM Orders
 WHERE e.EmployeeID = Orders.EmployeeID
 AND OrderDate = '9/5/97')

/*INSERT*/

-- Dodajte novog zaposlenika
INSERT INTO Employees
(LastName, FirstName, Title, TitleOfCourtesy,
BirthDate, HireDate, Address, City, Region,
PostalCode, Country, HomePhone, Extension)
VALUES ('Dunn','Nat','Sales Representative','Mr.','19-Feb-1970',
'15-Jan-2004','4933 Jamesville Rd.','Jamesville','NY',
'13078','USA','315-555-5555','130');

-- Dodajte novu regiju
INSERT Region (RegionID, RegionDescription) VALUES (5, 'NorthWestern')

--Dodajte novu narudžbu koja je kopija narudžbe ORDERID = 10248
INSERT INTO Orders
SELECT
CustomerID
 ,EmployeeID
 ,OrderDate
 ,RequiredDate
 ,ShippedDate
 ,ShipVia
 ,Freight
 ,ShipName
 ,ShipAddress
 ,ShipCity
 ,ShipRegion
 ,ShipPostalCode
 ,ShipCountry
FROM Orders
WHERE ORDERID = 10248

/*UPDATE*/

-- Ažurirajte zaposlenike čije je ime Nat na način da ime postane Nathaniel
UPDATE Employees
SET FirstName = 'Nathaniel'
WHERE FirstName = 'Nat';
/* Ažurirajte kupca s CustomerID = 'ALFKI':
promijenite ContactName u 'Ann Smith', ContactTitle u 'Marketing manager'
*/
UPDATE Customers
SET ContactName = 'Ann Smith',
ContactTitle = 'Marketing manager'
WHERE CustomerID = 'ALFKI'

/*DELETE*/

-- Izbrišite zaposlenike čije je ime 'Nathaniel'
DELETE FROM Employees
WHERE FirstName = 'Nathaniel';
-- Izbrišite sve narudžbe ostvarene 1995 godine
DELETE FROM [Order Details]
WHERE OrderID IN
(SELECT OrderID FROM [Orders]
WHERE YEAR(OrderDate) = 1995)

DELETE FROM [Orders]
WHERE YEAR(OrderDate) = 1995


/* FUNKCIJE*/

/* Kreirai korisničku funkciju koja odreðuje je li potrebno ponovno
naručiti proizvod. */

CREATE FUNCTION fnNeedToReorder (@nReorderLevel INT, @nUnitsInStock INT,
 @nUnitsOnOrder INT)
 RETURNS VARCHAR(3)
AS
BEGIN
 DECLARE @sReturnValue VARCHAR(3)
 IF ((@nUnitsInStock + @nUnitsOnOrder) - @nReorderLevel) < 0
SET @sReturnValue = 'Yes'
 ELSE
 SET @sReturnValue = 'No'
 RETURN @sReturnValue
END
GO
SELECT ProductID,
 ReorderLevel,
 UnitsInStock,
 UnitsOnOrder,
 dbo.fnNeedToReorder(ReorderLevel, UnitsInStock, UnitsOnOrder) AS
needToReorder
 FROM Products

/* Izraditi funkciju koja vraća sve zaposlenike iz određenog grada */

CREATE FUNCTION fnGetEmployeesByCity (@sCity VARCHAR(30))
 RETURNS TABLE
AS
RETURN
 (
 SELECT FirstName, LastName, Address
 FROM Employees
 WHERE City = @sCity
 )
GO
SELECT * FROM fnGetEmployeesByCity('seattle') 

/* Izraditi funkciju koja vraæa sve zaposlenike iz odreðenog grada.
Ukoliko za poslenici ne postoje, ispisati: Nije pronaðen niti jedan
zaposlenik u danom gradu.*/

CREATE FUNCTION fnGetEmployeesByCity3 (@sCity VARCHAR(30))
 RETURNS @tblMyEmployees TABLE
 (
 FirstName VARCHAR(20),
 LastName VARCHAR(40),
 Address VARCHAR(120)
 )
AS
BEGIN
 INSERT @tblMyEmployees
 SELECT FirstName, LastName, Address
 FROM Employees
 WHERE City = @sCity
 ORDER BY LastName
 IF NOT EXISTS (SELECT * FROM @tblMyEmployees)
 INSERT @tblMyEmployees (Address)
 VALUES ('Nije pronaðen niti jedan zaposlenik u danom gradu.')

 RETURN
END
SELECT * FROM fnGetEmployeesByCity3('Split') 


