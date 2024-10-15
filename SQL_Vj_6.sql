
-- tables / 'ime tablice' / script table as / insert to

--1
/*Unesite novog zaposlenika u tablicu Employees. Koristite svoje osobne podatke*/

--INSERT INTO [dbo].[Employees]
--           ([LastName]
--           ,[FirstName]
--           ,[Title]
--           ,[TitleOfCourtesy]
--           ,[BirthDate]
--           ,[HireDate]
--           ,[Address]
--           ,[City]
--           ,[Region]
--           ,[PostalCode]
--           ,[Country]
--           ,[HomePhone]
--           ,[Extension]
--           )
--     VALUES
--           ('Punda',
--           'Stipe',
--           'Sales Representative',
--           'Mr.',
--           '2002-08-15',
--           getdate(),
--           'Solin 66',
--           'Solin',
--           'Solin',
--           '21210',
--           'Hrvatska',
--           '0993453321',
--           '6678'
--           )

--2
/* Unesite dvije nove narudžbe, te njihove stavke za novo kreiranog zaposlenika. */
--INSERT INTO [dbo].[Orders]
--           ([CustomerID]
--           ,[EmployeeID]
--           ,[OrderDate]
--           ,[RequiredDate]
--           ,[ShippedDate]
--           ,[ShipVia]
--           ,[Freight]
--           ,[ShipName]
--           ,[ShipAddress]
--           ,[ShipCity]
--           ,[ShipRegion]
--           ,[ShipPostalCode]
--           ,[ShipCountry])
--     VALUES
--           ('VINET'
--           ,'12'
--           ,'1996-07-04 00:00:00.000'
--           ,'1996-08-01 00:00:00.000'
--           ,'1996-07-16 00:00:00.000'
--           ,'3'
--           ,35.45
--           ,'Vins et alcools Chevalier'
--		   ,'59 rue de lAbbaye'
--		   ,'Reims'
--           ,Null
--           ,'51100'
--           ,'France'
--           ),
--		   ('VINET'
--           ,'12'
--           ,'1998-07-04 00:00:00.000'
--           ,'1998-08-01 00:00:00.000'
--           ,'1998-07-16 00:00:00.000'
--           ,'1'
--           ,39.45
--           ,'Vins et alcools Chevalier'
--		   ,'Starenweg 5'
--		   ,'Paris'
--           ,Null
--           ,'51200'
--           ,'France'
--           )

--3
/* Ažurirajte novo unesenog zaposlenika tako da dodate vrijednosti u sva ne unesena polja.*/
--UPDATE Employees
--SET City = 'Split',
--	PostalCode = '21000'
--WHERE EmployeeID = '12'

--5
/* Izbrišite novog zaposlenika i s njim povezane zapise u svim tablicama.
Ukoliko je moguće, koristite ugniježđene upite umjesto eksplicitnog navođenja atributa s ID-om
zapisa) . */
--DELETE FROM Orders
--	WHERE EmployeeID = 12
--DELETE FROM Employees
--	WHERE EmployeeID = 12
	












