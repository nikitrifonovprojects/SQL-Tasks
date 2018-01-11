CREATE DATABASE NikiShop
GO
USE NikiShop
GO

CREATE TABLE Currency(
CurrencyID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Code nvarchar(10) NOT NULL,
Name nvarchar(20) NOT NULL,
ExcangeRate decimal(19,9) NOT NULL
)

CREATE TABLE Continent(
ContinentID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
CONSTRAINT uc_ContinentName UNIQUE(Name)
)

CREATE TABLE Region(
RegionID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
ContinentID int NOT NULL FOREIGN KEY REFERENCES Continent(ContinentID),
CONSTRAINT uc_RegionName UNIQUE(Name)
)

CREATE TABLE Country(
CountryID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
ContinentID int NOT NULL FOREIGN KEY REFERENCES Continent(ContinentID),
RegionID int NOT NULL FOREIGN KEY REFERENCES Region(RegionID),
CONSTRAINT uc_CountryName UNIQUE(Name)
)

CREATE TABLE PostCode(
PostCodeID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Code nvarchar(10) NOT NULL,
CountryID int NOT NULL FOREIGN KEY REFERENCES Country(CountryID)
)

CREATE TABLE City(
CityID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
CountryID int NOT NULL FOREIGN KEY REFERENCES Country(CountryID)
)

CREATE TABLE Address(
AddressID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
CityID int NOT NULL FOREIGN KEY REFERENCES City(CityID),
AddressLine nvarchar(30) NOT NULL,
CountryID int NOT NULL FOREIGN KEY REFERENCES Country(CountryID),
PostCodeID int NOT NULL FOREIGN KEY REFERENCES PostCode(PostCodeID)
)

CREATE TABLE Users(
UserID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
FirstName nvarchar(20) NOT NULL,
LastName nvarchar(20) NOT NULL,
Email nvarchar(30) NOT NULL,
PreferredCurrencyID int NULL FOREIGN KEY REFERENCES Currency(CurrencyID),
CONSTRAINT uc_UserEmail UNIQUE(Email)
)

CREATE TABLE Users_Address(
UserID int NOT NULL,
AddressID int NOT NULL,
PRIMARY KEY(UserID, AddressID),
FOREIGN KEY(UserID) REFERENCES Users(UserID),
FOREIGN KEY(AddressID) REFERENCES Address(AddressID)
)

CREATE TABLE ShippingCompany(
ShippingCompanyID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(30) NOT NULL,
Phone nvarchar(20) NOT NULL,
AddressID int NOT NULL FOREIGN KEY REFERENCES Address(AddressID)
)

CREATE TABLE ShipingCompany_Region(
RegionID int NOT NULL,
ShippingCompanyID int NOT NULL,
PRIMARY KEY(RegionID, ShippingCompanyID),
FOREIGN KEY(RegionID) REFERENCES Region(RegionID),
FOREIGN KEY(ShippingCompanyID) REFERENCES ShippingCompany(ShippingCompanyID)
)

CREATE TABLE Store(
StoreID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(30) NOT NULL,
AddressID int NOT NULL FOREIGN KEY REFERENCES Address(AddressID),
CONSTRAINT uc_StoreName UNIQUE(Name)
)

CREATE TABLE Region_Store(
RegionID int NOT NULL,
StoreID int NOT NULL,
PRIMARY KEY(RegionID, StoreID),
FOREIGN KEY(RegionID) REFERENCES Region(RegionID),
FOREIGN KEY(StoreID) REFERENCES Store(StoreID)
)

CREATE TABLE Orders(
OrderID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
DateOrdered datetime NOT NULL,
DateSent datetime NULL,
DateDelivered datetime NULL,
ShippingAddressID int NOT NULL FOREIGN KEY REFERENCES Address(AddressID),
ShippingPrice decimal(19,9) NOT NULL,
CurrencyID int NOT NULL FOREIGN KEY REFERENCES Currency(CurrencyID),
ShippingCompanyID int NOT NULL FOREIGN KEY REFERENCES ShippingCompany(ShippingCompanyID),
UserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID)
)

CREATE TABLE ProductCategory(
ProductCategoryID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
CONSTRAINT uc_ProductCategoryName UNIQUE(Name)
)

CREATE TABLE Producer(
ProducerID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(30)
)

CREATE TABLE Tags(
TagID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20)
)

CREATE TABLE Product(
ProductID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(30) NOT NULL,
QuantityPerUnit nvarchar(20) NULL,
PricePerUnit money NULL,
UnitsInStock int NULL,
ProducerID int NOT NULL FOREIGN KEY REFERENCES Producer(ProducerID)
)

CREATE TABLE Product_Tags(
ProductID int NOT NULL,
TagID int NOT NULL,
PRIMARY KEY(ProductID, TagID),
FOREIGN KEY(ProductID) REFERENCES Product(ProductID),
FOREIGN KEY(TagID) REFERENCES Tags(TagID)
)

CREATE TABLE OrderDetails(
OrderID int NOT NULL,
ProductID int NOT NULL,
PRIMARY KEY(OrderID, ProductID),
Amount int NOT NULL,
PricePerUnit money NOT NULL,
FOREIGN KEY(ProductID) REFERENCES Product(ProductID),
FOREIGN KEY(OrderID) REFERENCES Orders(OrderID)
)

CREATE TABLE Product_ProductCategory(
ProductID int NOT NULL,
ProductCategoryID int NOT NULL,
PRIMARY KEY(ProductID, ProductCategoryID),
FOREIGN KEY(ProductID) REFERENCES Product(ProductID),
FOREIGN KEY(ProductCategoryID) REFERENCES ProductCategory(ProductCategoryID)
)

CREATE TABLE Product_Store(
ProductID int NOT NULL,
StoreID int NOT NULL,
PRIMARY KEY(ProductID, StoreID),
ProductPrice decimal(19,9) NOT NULL,
FOREIGN KEY(ProductID) REFERENCES Product(ProductID),
FOREIGN KEY(StoreID) REFERENCES Store(StoreID),
CONSTRAINT uc_ProductStore UNIQUE(ProductID, StoreID)
)

CREATE TABLE Product_Reviews(
ReviewID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Rating decimal(2,1) NOT NULL,
Text text NOT NULL,
UserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID),
ProductID int NOT NULL FOREIGN KEY REFERENCES Product(ProductID),
CONSTRAINT chk_Rating CHECK (Rating >= 0 AND Rating <= 5),
CONSTRAINT uc_ProductReview UNIQUE(UserID, ProductID)
)

CREATE TABLE Store_Reviews(
ReviewID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Rating decimal(2,1) NOT NULL,
Text text NOT NULL,
UserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID),
StoreID int NOT NULL FOREIGN KEY REFERENCES Store(StoreID),
CONSTRAINT chk_StoreReviewRating CHECK (Rating >= 0 AND Rating <= 5),
CONSTRAINT uc_StoreReview UNIQUE(UserID, StoreID)
)

CREATE TABLE Orders_Reviews(
ReviewID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Rating decimal(2,1) NOT NULL,
Text text NOT NULL,
UserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID),
OrderID int NOT NULL FOREIGN KEY REFERENCES Orders(OrderID),
ShippingCompanyID int NOT NULL FOREIGN KEY REFERENCES ShippingCompany(ShippingCompanyID),
CONSTRAINT chk_OrderReviewRating CHECK (Rating >= 0 AND Rating <= 5),
CONSTRAINT uc_OrderReview UNIQUE(UserID, OrderID)
)

--SELECTS

-- All order details for user with name by dateordered DESC
SELECT o.OrderID, od.ProductID, od.Amount, od.PricePerUnit, o.DateOrdered
FROM Orders o
INNER JOIN OrderDetails od
ON o.OrderID = od.OrderID
INNER JOIN Users u
ON o.UserID = u.UserID
WHERE u.FirstName = 'aaa'
ORDER BY o.DateOrdered DESC

CREATE INDEX idx_UserFirstName
ON Users(FirstName)

CREATE INDEX idx_UserID_DateOrdered
ON Orders(UserID, DateOrdered DESC)

--- User Details by User Email(Profile screen)
SELECT u.UserID, u.FirstName, u.LastName, c.Name, u.Email
FROM Users u
INNER JOIN Currency c
ON u.PreferredCurrencyID = c.CurrencyID
WHERE u.UserID = 1

--All orders for a user by userID ordered by DateOrdered , DateSent, DateDelivered(All orders screen)
SELECT o.OrderID, o.DateOrdered, o.DateSent, o.DateDelivered
FROM Orders o
WHERE o.UserID = 1
ORDER BY o.DateOrdered DESC
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;

--Order details by orderID (Order details screen)
SELECT p.Name, od.Amount, od.PricePerUnit, o.ShippingCompanyID, o.ShippingPrice, c.Code , c.ExcangeRate
FROM OrderDetails od
INNER JOIN Product p
ON od.ProductID = p.ProductID
INNER JOIN Orders o
ON od.OrderID = o.OrderID
INNER JOIN Currency c
ON o.CurrencyID = c.CurrencyID
WHERE od.OrderID = 1

--Shipping Company by  region(Shipping Company Details)
SELECT sc.Name, cou.Name, c.Name, a.AddressLine, post.Code, sc.Phone
FROM ShippingCompany sc
INNER JOIN ShipingCompany_Region scr
ON sc.ShippingCompanyID = scr.ShippingCompanyID
INNER JOIN Region r
ON scr.RegionID = r.RegionID
INNER JOIN Address a
ON sc.AddressID = a.AddressID
INNER JOIN City c
ON a.CityID = c.CityID
INNER JOIN Country cou
ON c.CountryID = cou.CountryID
INNER JOIN PostCode post
ON a.PostCodeID = post.PostCodeID
WHERE r.Name = 'aaaa'

--Show products in stock by name, ordered by name (Search Products without constraints)
SELECT p.Name, p.PricePerUnit, p.QuantityPerUnit, p.UnitsInStock, pro.Name
FROM Product p
INNER JOIN Producer pro
ON p.ProducerID = pro.ProducerID
WHERE p.UnitsInStock > 0 AND p.Name = 'asad'
ORDER BY p.Name
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;

CREATE INDEX idx_Name_UnitsInStock_PricePerUnit_QuantityPerUnit_ProducerID
ON Product(Name, UnitsInStock, PricePerUnit, QuantityPerUnit, ProducerID)

--Show all products in a certain region by region name, order by product name (Search Products by region)
SELECT p.Name, ps.ProductPrice, s.Name, c.Name, a.AddressLine, a.PostCodeID
FROM Product p
INNER JOIN Product_Store ps
ON p.ProductID = ps.ProductID
INNER JOIN Store s
ON ps.StoreID = s.StoreID
INNER JOIN Address a
ON s.AddressID = a.AddressID
INNER JOIN City c
ON a.CityID = c.CityID
INNER JOIN Region_Store rs
ON ps.StoreID= rs.StoreID
INNER JOIN Region r
ON rs.RegionID = r.RegionID
WHERE r.Name = 'asaa'
ORDER BY p.Name
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;

CREATE INDEX idx_RegionName
ON Region(Name)

CREATE INDEX idx_StoreID_ProductID_ProductPrice
ON Product_Store(StoreID, ProductID, ProductPrice)

CREATE INDEX idx_StoreID_RegionID
ON Region_Store(StoreID, RegionID)

CREATE INDEX idx_CityName
ON City(Name)


--Show all sc reviews for a user by ID, order by rating
SELECT ordr.Text, ordr.Rating, sc.Name
FROM Orders_Reviews ordr
INNER JOIN ShippingCompany sc
ON sc.ShippingCompanyID = ordr.ShippingCompanyID
INNER JOIN Users u
ON ordr.UserID = u.UserID
WHERE u.UserID = 1
ORDER BY ordr.Rating

CREATE INDEX idx_UserID_Rating
ON Orders_Reviews(UserID, Rating)

--Show all store reviews for a user by ID, order by rating
SELECT s.Name, sr.Rating, sr.Text
FROM Store_Reviews sr
INNER JOIN Users u
ON sr.UserID = u.UserID
INNER JOIN Store s
ON sr.StoreID = s.StoreID
WHERE u.UserID = 1
ORDER BY sr.Rating

CREATE INDEX idx_UserID_Rating
ON Store_Reviews(UserID, Rating)

--Show all product reviws for a user by ID, order by rating
SELECT p.Name, pr.Rating, pr.Text
FROM Product_Reviews pr
INNER JOIN Product p
ON pr.ProductID= p.ProductID
INNER JOIN Users u
ON pr.UserID = u.UserID
WHERE u.UserID = 1
ORDER BY pr.Rating

CREATE INDEX idx_UserID_Rating
ON Product_Reviews(UserID, Rating)

--Show all products by tag name 
SELECT p.Name, t.Name
FROM Product p
INNER JOIN Product_Tags pt
ON p.ProductID = pt.ProductID
INNER JOIN Tags t
ON pt.TagID = t.TagID
WHERE t.Name = 'asaaa'

CREATE INDEX idx_Name
ON Tags(Name)

CREATE INDEX idx_TagID
ON Product_Tags(TagID, ProductID)

--Show all products in category
SELECT pc.Name, p.Name
FROM Product p
INNER JOIN Product_ProductCategory ppc
ON p.ProductID = ppc.ProductID
INNER JOIN ProductCategory pc
ON ppc.ProductCategoryID = pc.ProductCategoryID
WHERE pc.Name = 'asa'
ORDER BY p.Name

CREATE INDEX idx_ProductCategoryID
ON Product_ProductCategory(ProductCategoryID)

