CREATE DATABASE NikiCars
GO
USE NikiCars
GO

CREATE TABLE Counties(
CountyID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
CONSTRAINT uc_Name UNIQUE(Name)
)

CREATE TABLE CityID(
CityID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
CountyID int NOT NULL FOREIGN KEY REFERENCES Counties(CountyID),
CONSTRAINT uc_Name UNIQUE(Name)
)

CREATE TABLE Users(
UserID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
Email nvarchar(20) NOT NULL,
LoginName nvarchar(15) NOT NULL,
Password nvarchar(20) NOT NULL,
MobilePhone nvarchar(20) NOT NULL,
CityID int NOT NULL FOREIGN KEY REFERENCES CityID(CityID),
Address nvarchar(30) NULL,
Type nvarchar(15) NULL,
Bulstat nvarchar(15) NULL,
Website nvarchar(30) NULL,
PageName nvarchar(10) NULL,
IsOrganisation bit NOT NULL,
IsOfficialImporter bit NOT NULL,
CONSTRAINT uc_Name UNIQUE(Name),
CONSTRAINT uc_Email UNIQUE(Email),
CONSTRAINT uc_MobilePhone UNIQUE(MobilePhone)
)

CREATE TABLE CarMakes(
CarMakeID int NOT NULL PRIMARY KEY,
Name nvarchar(20) NOT NULL,
Country nvarchar(20) NOT NULL,
CONSTRAINT uc_Name UNIQUE(Name)
)

CREATE TABLE CarTypes(
CarTypeID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(15) NOT NULL,
CONSTRAINT uc_Name UNIQUE(Name)
)

CREATE TABLE CarModels(
CarModelID int NOT NULL PRIMARY KEY,
Name nvarchar(20) NOT NULL,
ProductionStartDate smalldatetime NOT NULL,
ProductionEndDate smalldatetime NOT NULL,
CarMakeID int NOT NULL FOREIGN KEY REFERENCES CarMakes(CarMakeID),
CarTypeID int NOT NULL FOREIGN KEY REFERENCES CarTypes(CarTypeID),
CONSTRAINT uc_Name UNIQUE(Name)
)

CREATE TABLE CarCoupe(
CarCoupeID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(15) NOT NULL
CONSTRAINT uc_Name UNIQUE(Name)
)

CREATE TABLE FuelTypes(
FuelTypeID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(10) NOT NULL,
CONSTRAINT uc_Name UNIQUE(Name)
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
CONSTRAINT uc_Name UNIQUE(Name)
)

CREATE TABLE Colours(
ColourID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(15) NOT NULL,
CONSTRAINT uc_Name UNIQUE(Name)
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