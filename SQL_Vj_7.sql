
--1
/* Funkciju fnIznosStavke koja računa iznos stavke narudžbe.
Ispišite sve stavke narudžbi te ukupan iznos svake od njih korištenjem prethodno definirane
funkcije. */

CREATE FUNCTION fnIznosStavke (@UnitPrice DECIMAL,@Quantity int,@Discount DECIMAL)
RETURNS DECIMAL
AS
BEGIN
	RETURN (@Quantity*@UnitPrice)-(@Quantity*@UnitPrice*@Discount)
END
GO

SELECT *, dbo.fnIznosStavke(UnitPrice,Quantity,Discount) AS UkupanIznos
FROM [Order Details]

--2
/* Funkciju koja vraća one stavke narudžbi čiji je ukupan iznos veći od vrijednosti proslijeđene
kao argument funkcije. Napravite SELECT izraz koji poziva tako definiranu funkciju.*/

CREATE FUNCTION fnIznos (@UkupanIznos DEC)
RETURNS TABLE
AS
	RETURN
		SELECT *, UnitPrice * Quantity * (1-Discount) as Ukupno
		FROM [Order Details]
		WHERE UnitPrice*Quantity*(1-Discount) > @UkupanIznos

GO

SELECT * from dbo.fnIznos(200)

--3
/* Napišite SQL izraze koji brišu prethodno kreirane objekte.*/
DROP fnIznosStavke
DROP fnIznos

--PROCEDURE

--1
/* Proceduru spSelectAllProducts koja ispisuje sadržaj tablice Products.*/

CREATE PROCEDURE spSelectAllProducts
AS
SELECT *
FROM Products

EXEC spSelectAllProducts

--2
/* Proceduru spSelectProduct koja ispisuje podatke o artiklu, za točno određeni artikl. Id artikla
treba proslijediti kao parametar procedure. */

ALTER PROCEDURE spSelectProduct (@ProductID INT)
AS
SELECT *
FROM Products
WHERE ProductID = @ProductID

EXEC spSelectProduct 4

--3
/* Proceduru UpdateProductPrice koja određenom artiklu mijenja cijene u novu vrijednosti. */

CREATE PROCEDURE UpdateProductPrice (@NewPrice INT, @ProductID INT)
AS
UPDATE dbo.Products
SET UnitPrice = @NewPrice
WHERE ProductID = @ProductID

EXEC UpdateProductPrice 50, 2

--4
/* Proceduru spSalesReport koja daje ime, prezime broj narudžbi i ukupan iznos narudžbi
određenog zaposlenika unutar određenog vremenskog perioda.*/

CREATE PROCEDURE spSalesReport (@startOrderDate DATE, 
								@endOrderDate DATE, 
								@firstName NVARCHAR(10), 
								@lastName NVARCHAR(20))
AS
SELECT e.EmployeeID, FirstName, LastName, COUNT(*) AS BrNarudzbi
FROM Orders o INNER JOIN Employees e
	ON o.EmployeeID = e.EmployeeID
		WHERE	FirstName = @firstName AND LastName = @lastName
				AND OrderDate BETWEEN @startOrderDate AND @endOrderDate
GROUP BY e.EmployeeID, FirstName, LastName

EXEC spSalesReport '1998/1/1', '1998/7/1', 'Nancy', 'Davolio' 

--5
/* Napišite SQL izraze koji brišu prethodno kreirane pohranjene procedure.*/

DROP spSelectAllProducts
DROP spSelectProduct
DROP UpdateProductPrice
DROP spSalesReport





