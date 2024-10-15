/*1 Upit koji ispisuje Id svake narudžbe (OrderID) na kojoj je prodan ProductID = 23, količinu po kojoj
je prodan taj proizvod na stavci, te maksimalnu količinu po kojoj je prodan bilo koji proizvod.
*/

SELECT OrderID, Quantity, 
(SELECT MAX(Quantity) FROM [Order Details] ) AS MaxQuantity
FROM [Order Details]
WHERE ProductID = 23


--2
/* Napravite upit koji ispisuje ProductId, ProductName i SupplierId za sve proizvode čiji su
dobavljaču (Supplier) tvrtke „Exotic Liquids“ ili „Tokyo Traders“.*/

SELECT ProductID, ProductName, SupplierID
FROM Products
WHERE SupplierID IN (
    SELECT SupplierID
    FROM Suppliers
    WHERE CompanyName IN ('Exotic Liquids', 'Tokyo Traders'))

--3
/* Ispišite ProductId i ProductName za sve one proizvode koji imaju jednaku cijenu kao i proizvod
pod nazivom „Longlife Tofu“*/

SELECT ProductID, ProductName 
FROM Products
WHERE UnitPrice = (SELECT UnitPrice FROM Products
	WHERE ProductName = 'Longlife Tofu')

--4
/*  Ispišite sve kupce koji imaju najnovije narudžbe (najkasniji datum narudžbe).*/

SELECT CustomerID, OrderID FROM Orders
WHERE OrderDate = (SELECT MAX(OrderDate) FROM Orders)

--5
/* Ispišite ProductId, ProductName onih proizvoda koji nisu nikada prodavani.
Napomena: takvi proizvodi ne moraju postojati.*/

SELECT ProductId, ProductName FROM Products
WHERE ProductId NOT IN 
(SELECT DISTINCT ProductId FROM [Order Details])

--6 
/* Ispišite listu kupaca i njihovih narudžbi (CustomerId, OrderId) kod kojih je ukupni iznos svih stavki
po narudžbi > 10000. */

SELECT CustomerID, OrderID 
FROM Orders o
WHERE 10000 < (SELECT SUM(UnitPrice*Quantity*(1-Discount)) 
	FROM [Order Details] od
WHERE o.OrderID = od.OrderID)

--7
/* Ispišite listu svih kupaca kojima je dostavljano u Francusku (Orders.ShipCountry = 'France' ).*/

SELECT CompanyName FROM Customers
WHERE  CustomerID in (SELECT CustomerID FROM Orders
	WHERE ShipCountry = 'France')

















