--1
/* Izradite izraze koji će:
- u tablicu Region dodati zapis u kojem će polje RegionDescription imati vrijednost “ISEA”
- u tablicu Territories dodati zapise koji za TeritoryDescription imaju vrijednosti “Grčka”,
“Slovenija”, “Italija” te trebaju pripadati regiji “ISEA” (5%) */

INSERT INTO Region
(RegionID, RegionDescription)
VALUES ('12','ISEA')

INSERT INTO Territories
(TerritoryID, TerritoryDescription, RegionID)
VALUES	('98105','Grčka','12'),
		('98106','Slovenija','12'),
		('98107','Italija','12')

--2
/* Napisati izraz koji će za sve zapise u tablici Teritories koji pripadaju regiji “ISEA” ažurirati na
postojeće ime s dodanim sufiksom “_ISEA” npr. “Grčka”->”Grčka_ISEA” (5%)*/

SELECT *
FROM dbo.Territories
ORDER BY TerritoryID

UPDATE dbo.Territories
SET TerritoryDescription = RTRIM(TerritoryDescription) + '_ISEA'
WHERE RegionID = 12

--3
/* . Napisati izraz koji će izbrisati podatke iz tablice Territories koji su u regiji “ISEA” (koristiti
podupit za pronalazak RegionID) (10%)*/

DELETE FROM Territories
WHERE RegionID = (SELECT RegionID FROM Region
		WHERE RegionDescription = 'ISEA')

--4
/* Izraditi proceduru sp_DodajPrijevoznika koja će dodati jedan novi zapis u tablicu Shippers.
Sve potrebne vrijednosti poslati kao ulazne parametre.
Napisati sql naredbu kojom se izvršava procedura. (10%)*/

CREATE PROCEDURE sp_DodajPrijevoznika	(@CompanyName nvarchar(40),
										@Phone nvarchar(24))
AS
BEGIN
 INSERT INTO Shippers (CompanyName, Phone)
 VALUES (@CompanyName, @Phone);
END;

EXEC sp_DodajPrijevoznika 'CIAK', '099 244 7845'

SELECT * FROM Shippers

--5
/* Izraditi proceduru sp_DodajNarudzbu koja dodaje jednu novu narudžbu u tablicu Orders
dodati redak sa istim vrijednostima kao i ORDERID = 11077 osim vrijednosti Shipper-a
(ShipVia) koji treba biti proslijeđen kao parametar u proceduru.
Napisati sql naredbu kojom se izvršava procedura. (10%)*/

CREATE PROCEDURE sp_DodajNarudzbu ( @ShipperID INT)
AS
BEGIN
 INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipRegion, ShipPostalCode, ShipCountry)
 SELECT CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, @ShipperID, Freight, ShipName, ShipAddress, ShipCity, ShipRegion, ShipPostalCode, ShipCountry
 FROM Orders
 WHERE OrderID = 11077
END;

EXEC sp_DodajNarudzbu 3;

--6
/* Izraditi proceduru sp_AzurirajProizvode koja će ažurirati sve zapise iz tablice Products na
način da se polje ReorderLevel ažurira za onoliko puta koliko definira parametar procedure.
Napisati sql naredbu kojom se izvršava procedura. (15%) */

CREATE PROCEDURE sp_AzurirajProizvode (@BrojPonavljanja INT)
AS
BEGIN
	UPDATE Products
	SET ReorderLevel = ReorderLevel * @BrojPonavljanja;
END;

EXEC sp_AzurirajProizvode @BrojPonavljanja = 2

--7
/* . Izraditi funciju fn_TimesSold koja će u obliku tablice (ProductId, ProductName,
BrojPutaProdan) ispisati podatke o onim proizvodima koji su do sada prodani više puta od
broja koji se proslijeđuje kao parametar funkcije.
Napisati naredbu kojom se izvršava funkcija. (15%) */

CREATE FUNCTION fn_TimesSold (@BrojPutaProdan int)
RETURNS TABLE
AS
RETURN
(
 SELECT p.ProductID, p.ProductName, COUNT(od.OrderID) AS BrojPutaProdan
 FROM Products p

 JOIN [Order Details] od 
 ON p.ProductID = od.ProductID

 GROUP BY p.ProductID, p.ProductName
 HAVING COUNT(od.OrderID) > @BrojPutaProdan
 )

SELECT * FROM fn_TimesSold(5)