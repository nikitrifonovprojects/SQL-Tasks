CREATE DATABASE NikiCars
GO
USE NikiCars
GO

CREATE TABLE Counties(
CountyID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
CONSTRAINT uc_Name UNIQUE(Name)
)

CREATE TABLE City(
CityID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
CountyID int NOT NULL FOREIGN KEY REFERENCES Counties(CountyID),
CONSTRAINT uc_CityName UNIQUE(Name)
)

CREATE TABLE Users(
UserID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
Email nvarchar(20) NOT NULL,
LoginName nvarchar(15) NOT NULL,
Password nvarchar(64) NOT NULL,
MobilePhone nvarchar(20) NOT NULL,
CityID int NOT NULL FOREIGN KEY REFERENCES City(CityID),
Address nvarchar(30) NULL,
Type nvarchar(15) NULL,
Bulstat nvarchar(15) NULL,
Website nvarchar(30) NULL,
PageName nvarchar(10) NULL,
IsOrganisation bit NOT NULL,
IsOfficialImporter bit NOT NULL,
CONSTRAINT uc_UserName UNIQUE(Name),
CONSTRAINT uc_Email UNIQUE(Email),
CONSTRAINT uc_MobilePhone UNIQUE(MobilePhone)
)

CREATE TABLE CarMakes(
CarMakeID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
Country nvarchar(20) NOT NULL,
CONSTRAINT uc_CarMakeName UNIQUE(Name)
)

CREATE TABLE CarTypes(
CarTypeID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(15) NOT NULL,
CONSTRAINT uc_CarTypeName UNIQUE(Name)
)

CREATE TABLE CarModels(
CarModelID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
CarMakeID int NOT NULL FOREIGN KEY REFERENCES CarMakes(CarMakeID),
CarTypeID int NOT NULL FOREIGN KEY REFERENCES CarTypes(CarTypeID),
CONSTRAINT uc_CarModelName UNIQUE(Name)
)

CREATE TABLE CarCoupe(
CarCoupeID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(15) NOT NULL
CONSTRAINT uc_CarCoupeName UNIQUE(Name)
)

CREATE TABLE FuelTypes(
FuelTypeID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(10) NOT NULL,
CONSTRAINT uc_TuelTypeName UNIQUE(Name)
)

CREATE TABLE NumberOfDoors(
NumberOfDoorsID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
DoorCount nvarchar(5) NOT NULL
)

CREATE TABLE GearboxTypes(
GearboxTypeID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Type nvarchar(10) NOT NULL
)

CREATE TABLE CarModels_CarCoupe(
CarModelID int NOT NULL,
CarCoupeID int NOT NULL,
PRIMARY KEY(CarModelID, CarCoupeID),
FOREIGN KEY(CarModelID) REFERENCES CarModels(CarModelID),
FOREIGN KEY(CarCoupeID) REFERENCES CarCoupe(CarCoupeID)
)

CREATE TABLE CarExtras(
CarExtraID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(15) NOT NULL,
CONSTRAINT uc_CarExtrasName UNIQUE(Name)
)

CREATE TABLE Colours(
ColourID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(15) NOT NULL,
CONSTRAINT uc_ColoursName UNIQUE(Name)
)

CREATE TABLE Cars(
CarID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
CarModelID int NOT NULL FOREIGN KEY REFERENCES CarModels(CarModelID),
CarCoupeID int NOT NULL FOREIGN KEY REFERENCES CarCoupe(CarCoupeID),
NumberOfDoorsID int NOT NULL FOREIGN KEY REFERENCES NumberOfDoors(NumberOfDoorsID),
FuelTypeID int NOT NULL FOREIGN KEY REFERENCES FuelTypes(FuelTypeID),
ColourID int NOT NULL FOREIGN KEY REFERENCES Colours(ColourID),
GearboxTypeID int NOT NULL FOREIGN KEY REFERENCES GearboxTypes(GearboxTypeID),
HorsePower int NOT NULL,
FirstRegistrationDate smalldatetime NOT NULL,
EngineCapacity int NOT NULL,
Kilometers int NOT NULL,
Price money NOT NULL,
Discription text NOT NULL,
IsLeftSteering bit NOT NULL,
IsUsed bit NOT NULL,
IsForParts bit NOT NULL,
IsDamaged bit NOT NULL,
Title nvarchar(20) NULL,
DateCreated smalldatetime NOT NULL,
UserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID)
)

CREATE TABLE Pictures(
PictureID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
PictureFile varbinary(max) NOT NULL,
CarID int NOT NULL FOREIGN KEY REFERENCES Cars(CarID)
)

CREATE TABLE Cars_CarExtras(
CarID int NOT NULL,
CarExtraID int NOT NULL,
PRIMARY KEY(CarID, CarExtraID),
FOREIGN KEY(CarID) REFERENCES Cars(CarID),
FOREIGN KEY(CarExtraID) REFERENCES CarExtras(CarExtraID)
)

CREATE TABLE UserRoles(
RoleID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
RoleName nvarchar(15) NOT NULL,
RoleDescription nvarchar(20) NOT NULL,
CONSTRAINT uc_RoleName UNIQUE(RoleName)
)

CREATE TABLE Users_UserRoles(
UserID int NOT NULL,
RoleID int NOT NULL,
PRIMARY KEY(UserID, RoleID),
FOREIGN KEY(UserID) REFERENCES Users(UserID),
FOREIGN KEY(RoleID) REFERENCES UserRoles(RoleID)
)

--Queries

--Show all cars after 2008 by make name ordered by price asc
SELECT cm.Name, carm.Name, ft.Name, c.Kilometers, c.FirstRegistrationDate, c.Price, u.Name, ci.Name
FROM Cars c
INNER JOIN Users u
ON c.UserID = u.UserID
INNER JOIN City ci
ON u.CityID = ci.CityID
INNER JOIN FuelTypes ft
ON c.FuelTypeID = ft.FuelTypeID
INNER JOIN CarModels cm
ON c.CarModelID = cm.CarModelID
INNER JOIN CarMakes carm
ON cm.CarMakeID= carm.CarMakeID
WHERE carm.Name = 'Honda' AND c.FirstRegistrationDate > '2007/12/31' AND c.IsUsed = 1
ORDER BY c.Price ASC

CREATE INDEX idx_FirstRegistrationDate_Price
ON Cars(Price ASC, FirstRegistrationDate)
INCLUDE(IsUsed, Kilometers, UserID, FuelTypeID, CarModelID)

--Sow all cars by make name , with specific extras after 2009 order by price
SELECT DISTINCT c.Title, crm.Name, cmds.Name, ft.Name, c.Kilometers, c.FirstRegistrationDate, c.Price, u.Name, ci.Name
FROM Cars c
INNER JOIN Users u
ON c.UserID = u.UserID
INNER JOIN City ci
ON u.CityID = ci.CityID
INNER JOIN CarModels cmds
ON c.CarModelID = cmds.CarModelID
INNER JOIN CarMakes crm
ON cmds.CarMakeID = crm.CarMakeID
INNER JOIN Cars_CarExtras cextr
ON c.CarID = cextr.CarID
INNER JOIN CarExtras ext
ON cextr.CarExtraID= ext.CarExtraID
INNER JOIN FuelTypes ft
ON c.FuelTypeID = ft.FuelTypeID
WHERE crm.Name = 'Kia' AND c.FirstRegistrationDate > '2008/12/31' AND c.IsUsed = 1 AND c.CarID IN (SELECT c.CarID 
																											FROM CarExtras ext 
																											INNER JOIN Cars_CarExtras ce 
																											ON ext.CarExtraID = ce.CarExtraID
																											INNER JOIN Cars c
																											ON ce.CarID = c.CarID
																											WHERE ext.Name = 'Airbag'
																									INTERSECT
																									SELECT c.CarID
																											FROM CarExtras ext 
																											INNER JOIN Cars_CarExtras ce 
																											ON ext.CarExtraID = ce.CarExtraID
																											INNER JOIN Cars c
																											ON ce.CarID = c.CarID
																											WHERE ext.Name = 'ABS'
																									INTERSECT
																									SELECT c.CarID
																											FROM CarExtras ext 
																											INNER JOIN Cars_CarExtras ce 
																											ON ext.CarExtraID = ce.CarExtraID
																											INNER JOIN Cars c
																											ON ce.CarID = c.CarID
																											WHERE ext.Name = 'ASR')
ORDER BY c.Price ASC


--Show all cars in a city by name , up to a specific price ordered by date added desc
SELECT c.Title, crm.Name, cmds.Name, ft.Name, c.Kilometers, c.FirstRegistrationDate, c.Price, u.Name, ci.Name
FROM Cars c
INNER JOIN Users u
ON c.UserID = u.UserID
INNER JOIN City ci
ON u.CityID = ci.CityID
INNER JOIN CarModels cmds
ON c.CarModelID = cmds.CarModelID
INNER JOIN CarMakes crm
ON cmds.CarMakeID = crm.CarMakeID
INNER JOIN FuelTypes ft
ON c.FuelTypeID = ft.FuelTypeID
WHERE ci.Name = 'Sofia' AND c.Price < 210000
ORDER BY c.DateCreated DESC

DROP INDEX idx_Price
ON Cars(Price ASC, DateCreated DESC)
INCLUDE(FirstRegistrationDate, IsUsed, Kilometers, UserID, FuelTypeID, CarModelID, Title)