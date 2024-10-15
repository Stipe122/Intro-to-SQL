
--1

CREATE PROCEDURE sp_DeleteProduct ( @discontinued int)
AS
BEGIN
	DELETE FROM Products
	WHERE Discontinued = @discontinued
END

EXEC sp_DeleteProduct 1

--2

CREATE PROCEDURE sp_InsertEmp (	@LastName nvarchar(20),
								@FirstName nvarchar(10),
								@City nvarchar(15))
AS
BEGIN
 INSERT INTO [dbo].[Employees]
           ([LastName]
           ,[FirstName]
		   ,[City]
           )
     VALUES
           (@LastName
           ,@FirstName
		   ,@City
           )
END;

EXEC sp_InsertEmp 'Bubalo','Josip','Imotski'

--3


INSERT INTO Categories
(CategoryName)
VALUES ('Zacini')

UPDATE dbo.Categories
SET Categories.Description = 'Mirodije'
WHERE CategoryID = (SELECT CategoryID FROM Categories
					WHERE CategoryName = 'Zacini')

--4

INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock)
SELECT 
    'Papar', 
    1, 
    (SELECT CategoryID FROM Categories WHERE CategoryName = 'Zacini'), 
    '6 tegli', 
    8.00, 
    50
UNION
SELECT 
    'Sol', 
    1, 
    (SELECT CategoryID FROM Categories WHERE CategoryName = 'Zacini'), 
    '24 kila', 
    2.80, 
    10
UNION
SELECT 
    'Secer', 
    2, 
    (SELECT CategoryID FROM Categories WHERE CategoryName = 'Zacini'), 
    '10 kila', 
    4.99, 
    15;



--5

UPDATE dbo.Products
SET Categories.Description = RTRIM(Categories.Description) + '_Zacin'
WHERE ProductID = (SELECT CategoryID FROM Categories
					WHERE CategoryName = 'Zacini')

SELECT * FROM Products

--6

CREATE PROCEDURE sp_InsertProduct ( @SupplierID INT)
AS
BEGIN
 INSERT INTO Products (ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued)
 SELECT ProductID,ProductName,@SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued
 FROM Products
END;

EXEC sp_InsertProduct 7

--7

CREATE PROCEDURE sp_UpdateProducts
    @SupplierID int
AS
BEGIN
    UPDATE Products
    SET UnitPrice = UnitPrice * 1.2
    WHERE SupplierID = @SupplierID;
END

EXEC sp_UpdateProducts @SupplierID = 3

--8

CREATE FUNCTION fn_EmployeeOrdersCount (@OrdersNo int)
RETURNS TABLE
AS
RETURN
    SELECT 
        e.EmployeeID, 
        e.FirstName, 
        COUNT(o.OrderID) AS OrdersNo
    FROM 
        Employees e
        LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
    GROUP BY 
        e.EmployeeID, e.FirstName
    HAVING 
        COUNT(o.OrderID) <= @OrdersNo;

SELECT * FROM fn_EmployeeOrdersCount(10);