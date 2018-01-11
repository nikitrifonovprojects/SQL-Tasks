CREATE DATABASE NikiImages
GO
USE NikiImages
GO
CREATE TABLE Users(
UserID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
Password nvarchar(10) NOT NULL,
CONSTRAINT uc_UserName UNIQUE(Name)
)
GO
TRUNCATE TABLE Users
GO
CREATE TABLE Images(
ImageID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Link nvarchar(100) NOT NULL,
Thumbnail varbinary(max) NOT NULL,
Name nvarchar(40) NOT NULL,
Width decimal NOT NULL,
Height decimal NOT NULL,
UploadDate datetimeoffset NOT NULL DEFAULT CURRENT_TIMESTAMP,
FavoriteCount int NOT NULL,
UserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID)
)
GO
TRUNCATE TABLE Images
GO

CREATE TABLE Users_Images_Favorite(
UserID int NOT NULL,
ImageID int NOT NULL,
PRIMARY KEY(UserID, ImageID),
FavoriteDate datetimeoffset NOT NULL DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(UserID) REFERENCES Users(UserID),
FOREIGN KEY(ImageID) REFERENCES Images(ImageID)
)

GO
TRUNCATE TABLE Users_Images_Favorite
GO

CREATE TABLE Tags(
TagID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
CONSTRAINT uc_TagName UNIQUE(Name)
)

GO
TRUNCATE TABLE Tags
GO

CREATE TABLE Images_Tags(
ImageID int NOT NULL,
TagID int NOT NULL,
PRIMARY KEY(ImageID, TagID),
FOREIGN KEY(ImageID) REFERENCES Images(ImageID),
FOREIGN KEY(TagID) REFERENCES Tags(TagID)
)

GO
TRUNCATE TABLE Images_Tags
GO

CREATE TABLE Galleries(
GalleryID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(30) NOT NULL,
DateCreated datetimeoffset NOT NULL DEFAULT CURRENT_TIMESTAMP,
LastUpdatedDate datetimeoffset NULL,
FavoriteCount int NOT NULL,
UserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID)
)

GO
TRUNCATE TABLE Galleries
GO

CREATE TABLE Users_Galleries_Favorite(
UserID int NOT NULL,
GalleryID int NOT NULL,
PRIMARY KEY(UserID, GalleryID),
FavoriteDate datetimeoffset NOT NULL DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(UserID) REFERENCES Users(UserID),
FOREIGN KEY(GalleryID) REFERENCES Galleries(GalleryID)
)

GO
TRUNCATE TABLE Users_Galleries_Favorite
GO

CREATE TABLE Galleries_Tags(
GalleryID int NOT NULL,
TagID int NOT NULL,
PRIMARY KEY(GalleryID, TagID),
FOREIGN KEY(GalleryID) REFERENCES Galleries(GalleryID),
FOREIGN KEY(TagID) REFERENCES Tags(TagID)
)

GO
TRUNCATE TABLE Galleries_Tags
GO

CREATE TABLE Comments_Galleries(
CommentID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Text nvarchar(500) NOT NULL,
DateCreated datetimeoffset NOT NULL DEFAULT CURRENT_TIMESTAMP,
DateEdited datetimeoffset NULL,
UserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID),
PrimaryCommentID int NULL FOREIGN KEY REFERENCES Comments_Galleries(CommentID),
GalleryID int NOT NULL FOREIGN KEY REFERENCES Galleries(GalleryID)
)

GO
TRUNCATE TABLE Comments_Galleries
GO

CREATE TABLE Comments_Images(
CommentID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Text nvarchar(500) NOT NULL,
DateCreated datetimeoffset NOT NULL DEFAULT CURRENT_TIMESTAMP,
DateEdited datetimeoffset NULL,
UserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID),
PrimaryCommentID int NULL FOREIGN KEY REFERENCES Comments_Images(CommentID),
ImageID int NOT NULL FOREIGN KEY REFERENCES Images(ImageID)
)

GO
TRUNCATE TABLE Comments_Images
GO

CREATE TABLE Galleries_Images(
GalleryID int NOT NULL,
ImageID int NOT NULL,
PRIMARY KEY(GalleryID, ImageID),
FOREIGN KEY(GalleryID) REFERENCES Galleries(GalleryID),
FOREIGN KEY(ImageID) REFERENCES Images(ImageID)
)

GO
TRUNCATE TABLE Galleries_Images
GO

CREATE TABLE Groups(
GroupID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
CONSTRAINT uc_GroupName UNIQUE(Name)
)

GO
TRUNCATE TABLE Groups
GO

CREATE TABLE Groups_Users(
GroupID int NOT NULL,
UserID int NOT NULL,
PRIMARY KEY(GroupID, UserID),
FOREIGN KEY(GroupID) REFERENCES Groups(GroupID),
FOREIGN KEY(UserID) REFERENCES Users(UserID)
)

GO
TRUNCATE TABLE Groups_Users
GO

CREATE TABLE Groups_Images(
GroupID int NOT NULL,
ImageID int NOT NULL,
PRIMARY KEY(GroupID, ImageID),
FOREIGN KEY(GroupID) REFERENCES Groups(GroupID),
FOREIGN KEY(ImageID) REFERENCES Images(ImageID),
AddedByUserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID)
)

GO
TRUNCATE TABLE Groups_Images
GO

CREATE TABLE Groups_Galleries(
GroupID int NOT NULL,
GalleryID int NOT NULL,
PRIMARY KEY(GroupID, GalleryID),
FOREIGN KEY(GroupID) REFERENCES Groups(GroupID),
FOREIGN KEY(GalleryID) REFERENCES Galleries(GalleryID),
AddedByUserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID)
)

GO
TRUNCATE TABLE Groups_Galleries
GO

CREATE TABLE Comments_Groups(
CommentID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Text nvarchar(500) NOT NULL,
DateCreated datetimeoffset NOT NULL DEFAULT CURRENT_TIMESTAMP,
DateEdited datetimeoffset NULL,
UserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID),
PrimaryCommentID int NULL FOREIGN KEY REFERENCES Comments_Groups(CommentID),
GroupID int NOT NULL FOREIGN KEY REFERENCES Groups(GroupID)
)

GO
TRUNCATE TABLE Comments_Groups
GO


--DATA INPUT

--Users
INSERT INTO Users(Name, Password)
VALUES('Niki', '121212')

INSERT INTO Users(Name, Password)
VALUES('Ilian', '21212')

INSERT INTO Users(Name, Password)
VALUES('Adi', '65489')

INSERT INTO Users(Name, Password)
VALUES('Emo', '44789')

INSERT INTO Users(Name, Password)
VALUES('Pepi', '554451')

--Images

INSERT INTO Images(UserID, Name, Link, Thumbnail, Height, Width, FavoriteCount)
VALUES(1, 'Collage', 'hhhhhhhhhhhhhh', CONVERT(varbinary(max), 'Collage'), 12.2, 5, 0)

INSERT INTO Images(UserID, Name, Link, Thumbnail, Height, Width, FavoriteCount)
VALUES(2, 'Portrait', 'gggggggggggg', CONVERT(varbinary(max), 'Portrait'), 14.6, 6, 0)

INSERT INTO Images(UserID, Name, Link, Thumbnail, Height, Width, FavoriteCount)
VALUES(3, 'Picture', 'ffffffffffff', CONVERT(varbinary(max), 'Picture'), 9.2, 3, 0)

INSERT INTO Images(UserID, Name, Link, Thumbnail, Height, Width, FavoriteCount)
VALUES(4, 'Blob', 'jjjjjjjjjj', CONVERT(varbinary(max), 'Blob'), 2.7, 1.5, 0)

INSERT INTO Images(UserID, Name, Link, Thumbnail, Height, Width, FavoriteCount)
VALUES(5, 'Explosion', 'kkkkkkkkkkk', CONVERT(varbinary(max), 'Explosion'), 15.1, 12, 0)

INSERT INTO Images(UserID, Name, Link, Thumbnail, Height, Width, FavoriteCount)
VALUES(2, 'Tank', 'llllllllllll', CONVERT(varbinary(max), 'Tank'), 7, 3.5, 0)

INSERT INTO Images(UserID, Name, Link, Thumbnail, Height, Width, FavoriteCount)
VALUES(3, 'Car', 'aaaaaaaaaaaa', CONVERT(varbinary(max), 'Car'), 8, 4.5, 0)

INSERT INTO Images(UserID, Name, Link, Thumbnail, Height, Width, FavoriteCount)
VALUES(3, 'Bird', 'rrrrrrrrrrrrr', CONVERT(varbinary(max), 'Bird'), 4, 3, 0)

INSERT INTO Images(UserID, Name, Link, Thumbnail, Height, Width, FavoriteCount)
VALUES(2, 'Person', 'eeeeeeeeeeeeeeee', CONVERT(varbinary(max), 'Person'), 6, 3.5, 0)

INSERT INTO Images(UserID, Name, Link, Thumbnail, Height, Width, FavoriteCount)
VALUES(5, 'Avatar', 'ttttttttttttt', CONVERT(varbinary(max), 'Avatar'), 2, 1.2, 0)


--Tags

INSERT INTO Tags(Name)
VALUES('Cool')

INSERT INTO Tags(Name)
VALUES('Uncool')

INSERT INTO Tags(Name)
VALUES('Baby')

INSERT INTO Tags(Name)
VALUES('People')

INSERT INTO Tags(Name)
VALUES('Nature')

INSERT INTO Tags(Name)
VALUES('Automobiles')


--Images_Tags

INSERT INTO Images_Tags(ImageID, TagID)
VALUES(2,1)

INSERT INTO Images_Tags(ImageID, TagID)
VALUES(2,5)

INSERT INTO Images_Tags(ImageID, TagID)
VALUES(3,2)

INSERT INTO Images_Tags(ImageID, TagID)
VALUES(3,3)

INSERT INTO Images_Tags(ImageID, TagID)
VALUES(4,1)

INSERT INTO Images_Tags(ImageID, TagID)
VALUES(5,6)

INSERT INTO Images_Tags(ImageID, TagID)
VALUES(5,1)

INSERT INTO Images_Tags(ImageID, TagID)
VALUES(6,6)

INSERT INTO Images_Tags(ImageID, TagID)
VALUES(8,4)

INSERT INTO Images_Tags(ImageID, TagID)
VALUES(8,2)

INSERT INTO Images_Tags(ImageID, TagID)
VALUES(8,3)

INSERT INTO Images_Tags(ImageID, TagID)
VALUES(9,6)

INSERT INTO Images_Tags(ImageID, TagID)
VALUES(10,5)

INSERT INTO Images_Tags(ImageID, TagID)
VALUES(11,1)

INSERT INTO Images_Tags(ImageID, TagID)
VALUES(11,6)

--Galleries

INSERT INTO Galleries(UserID, Name, FavoriteCount)
VALUES(1, 'Louvre', 0)

INSERT INTO Galleries(UserID, Name, FavoriteCount)
VALUES(2, 'Methropolitan', 0)

INSERT INTO Galleries(UserID, Name, FavoriteCount)
VALUES(3, 'City Gallery', 0)

INSERT INTO Galleries(UserID, Name, FavoriteCount)
VALUES(4, 'Corner Gallery', 0)

--Galleries Tags

INSERT INTO Galleries_Tags(GalleryID, TagID)
VALUES(2,2)

INSERT INTO Galleries_Tags(GalleryID, TagID)
VALUES(3,3)

INSERT INTO Galleries_Tags(GalleryID, TagID)
VALUES(2,4)

INSERT INTO Galleries_Tags(GalleryID, TagID)
VALUES(4,4)

INSERT INTO Galleries_Tags(GalleryID, TagID)
VALUES(4,5)

INSERT INTO Galleries_Tags(GalleryID, TagID)
VALUES(5,2)

INSERT INTO Galleries_Tags(GalleryID, TagID)
VALUES(5,3)

INSERT INTO Galleries_Tags(GalleryID, TagID)
VALUES(3,2)

--Comments

INSERT INTO Comments_Images(UserID, Text, ImageID)
VALUES(2, 'Pretty', 2)

INSERT INTO Comments_Images(UserID, Text, ImageID)
VALUES(3, 'Bad', 3)

INSERT INTO Comments_Images(UserID, Text, ImageID)
VALUES(4, 'Exellent', 4)

INSERT INTO Comments_Galleries(UserID, Text, GalleryID)
VALUES(2, 'Pretty good', 2)

INSERT INTO Comments_Galleries(UserID, Text, GalleryID)
VALUES(3, 'Ugly', 3)

INSERT INTO Comments_Galleries(UserID, Text, GalleryID)
VALUES(5, 'So so', 4)

INSERT INTO Comments_Galleries(UserID, Text, PrimaryCommentID, GalleryID)
VALUES(2, 'I disagree', 1, 3)

INSERT INTO Comments_Images(UserID, Text, PrimaryCommentID, ImageID)
VALUES(2, 'I agree', 4, 4)

INSERT INTO Comments_Groups(UserID, Text, GroupID)
VALUES(5, 'Hard to find', 2)

INSERT INTO Comments_Groups(UserID, Text, GroupID)
VALUES(5, 'Easy', 3)

INSERT INTO Comments_Groups(UserID, Text, DateEdited, GroupID)
VALUES(2, 'Hard', GETDATE(), 2)

--Gallery Images

INSERT INTO Galleries_Images(GalleryID, ImageID)
VALUES(2, 2)

INSERT INTO Galleries_Images(GalleryID, ImageID)
VALUES(2, 3)

INSERT INTO Galleries_Images(GalleryID, ImageID)
VALUES(2, 8)

INSERT INTO Galleries_Images(GalleryID, ImageID)
VALUES(3, 2)

INSERT INTO Galleries_Images(GalleryID, ImageID)
VALUES(3, 10)

INSERT INTO Galleries_Images(GalleryID, ImageID)
VALUES(3, 9)

INSERT INTO Galleries_Images(GalleryID, ImageID)
VALUES(3, 3)

INSERT INTO Galleries_Images(GalleryID, ImageID)
VALUES(4, 2)

INSERT INTO Galleries_Images(GalleryID, ImageID)
VALUES(4, 6)

INSERT INTO Galleries_Images(GalleryID, ImageID)
VALUES(4, 7)

INSERT INTO Galleries_Images(GalleryID, ImageID)
VALUES(5, 2)

INSERT INTO Galleries_Images(GalleryID, ImageID)
VALUES(5, 4)

INSERT INTO Galleries_Images(GalleryID, ImageID)
VALUES(5, 5)

INSERT INTO Galleries_Images(GalleryID, ImageID)
VALUES(5, 9)

--Groups

INSERT INTO Groups(Name)
VALUES('Pretentious')

INSERT INTO Groups(Name)
VALUES('Cool as fire')

INSERT INTO Groups(Name)
VALUES('Nerds')

INSERT INTO Groups(Name)
VALUES('Dumb people')


--Groups Users

INSERT INTO Groups_Users(UserID, GroupID)
VALUES(1, 3)

INSERT INTO Groups_Users(UserID, GroupID)
VALUES(2, 2)

INSERT INTO Groups_Users(UserID, GroupID)
VALUES(3, 4)

INSERT INTO Groups_Users(UserID, GroupID)
VALUES(4, 2)

INSERT INTO Groups_Users(UserID, GroupID)
VALUES(2, 4)

INSERT INTO Groups_Users(UserID, GroupID)
VALUES(1, 2)

INSERT INTO Groups_Users(UserID, GroupID)
VALUES(2, 4)

INSERT INTO Groups_Users(UserID, GroupID)
VALUES(1, 4)

INSERT INTO Groups_Users(UserID, GroupID)
VALUES(4, 4)

INSERT INTO Groups_Users(UserID, GroupID)
VALUES(4, 3)

--Users Images Favorite

INSERT INTO Users_Images_Favorite(UserID, ImageID)
VALUES(1, 2)

INSERT INTO Users_Images_Favorite(UserID, ImageID)
VALUES(1, 3)

INSERT INTO Users_Images_Favorite(UserID, ImageID)
VALUES(2, 2)

INSERT INTO Users_Images_Favorite(UserID, ImageID)
VALUES(3, 2)

INSERT INTO Users_Images_Favorite(UserID, ImageID)
VALUES(4, 2)

INSERT INTO Users_Images_Favorite(UserID, ImageID)
VALUES(4, 3)

INSERT INTO Users_Images_Favorite(UserID, ImageID)
VALUES(4, 9)

INSERT INTO Users_Images_Favorite(UserID, ImageID)
VALUES(2, 8)

INSERT INTO Users_Images_Favorite(UserID, ImageID)
VALUES(3, 9)

INSERT INTO Users_Images_Favorite(UserID, ImageID)
VALUES(4, 6)


--Groups_Images

INSERT INTO Groups_Images(GroupID, ImageID, AddedByUserID)
VALUES(1, 2, 1)

INSERT INTO Groups_Images(GroupID, ImageID, AddedByUserID)
VALUES(1, 4, 2)

INSERT INTO Groups_Images(GroupID, ImageID, AddedByUserID)
VALUES(2, 7, 4)

INSERT INTO Groups_Images(GroupID, ImageID, AddedByUserID)
VALUES(3, 10, 3)

INSERT INTO Groups_Images(GroupID, ImageID, AddedByUserID)
VALUES(4, 7, 3)

INSERT INTO Groups_Images(GroupID, ImageID, AddedByUserID)
VALUES(4, 6, 1)


--Galleries_Groups

INSERT INTO Groups_Galleries(GroupID, GalleryID, AddedByUserID)
VALUES(3, 2, 4)

INSERT INTO Groups_Galleries(GroupID, GalleryID, AddedByUserID)
VALUES(2, 3, 2)

INSERT INTO Groups_Galleries(GroupID, GalleryID, AddedByUserID)
VALUES(1, 4, 3)

INSERT INTO Groups_Galleries(GroupID, GalleryID, AddedByUserID)
VALUES(4, 5, 1)

--Groups Comments--

INSERT INTO Comments_Groups(GroupID, UserID , Text)
VALUES(2, 1, 'asdaaaa')

INSERT INTO Comments_Groups(GroupID, UserID, Text)
VALUES(3, 2, 'afafadf')

INSERT INTO Comments_Groups(GroupID, UserID, Text)
VALUES(4, 3, 'hgfhfgs')

INSERT INTO Comments_Groups(GroupID, UserID, Text)
VALUES(1, 4, 'rtrere')

--Comments Images

INSERT INTO Comments_Images(ImageID, UserID, Text)
VALUES(3, 1, 'kdgkld')

INSERT INTO Comments_Images(ImageID, UserID, Text)
VALUES(2, 2, 'yaudyadt')

INSERT INTO Comments_Images(ImageID, UserID, Text)
VALUES(4, 3, 'kakjladklad')

INSERT INTO Comments_Images(ImageID, UserID, Text)
VALUES(5, 4, 'uioaduioadiuo')

--Comments Galleries

INSERT INTO Comments_Galleries(UserID, GalleryID, Text)
VALUES(1, 2, 'hhdhddk')

INSERT INTO Comments_Galleries(UserID, GalleryID, Text)
VALUES(2, 2, 'llkkdjdy')

INSERT INTO Comments_Galleries(UserID, GalleryID, Text)
VALUES(3, 3, 'susaysts')

INSERT INTO Comments_Galleries(UserID, GalleryID, Text)
VALUES(4, 4, 'zuatsanf')

----Users Galleries Favorite

INSERT INTO Users_Galleries_Favorite(UserID, GalleryID)
VALUES(1, 2)

INSERT INTO Users_Galleries_Favorite(UserID, GalleryID)
VALUES(2, 2)

INSERT INTO Users_Galleries_Favorite(UserID, GalleryID)
VALUES(3, 4)

INSERT INTO Users_Galleries_Favorite(UserID, GalleryID)
VALUES(4, 3)

--SELECTS

--All images created by a user, by username. Sorted by UploadDate, latest first (primary key, name, link, thumbnail, upload date, times favorited)
SELECT i.ImageID, i.Name, i.Link, i.Thumbnail, i.UploadDate, i.FavoriteCount
FROM Images i
INNER JOIN Users u
ON i.UserID = u.UserID
WHERE u.Name = 'Ilian'
ORDER BY i.UploadDate DESC

CREATE INDEX idx_UserID_UploadDate
ON Images(UserID, UploadDate DESC)

--All images by tag name. Sorted by times favorited, then by UploadDate, latest first (primary key, name, link, thumbnail, upload date, times favorited)
SELECT i.ImageID, i.Name, i.Link, i.Thumbnail, i.UploadDate, i.FavoriteCount
FROM Images i
INNER JOIN Images_Tags it
ON i.ImageID = it.ImageID
INNER JOIN Tags t
ON it.TagID = t.TagID
WHERE t.Name = 'Uncool'
ORDER BY i.FavoriteCount , i.UploadDate DESC

CREATE INDEX idx_TagName
ON Tags(Name)

CREATE INDEX idx_TagID_ImageID
ON Images_Tags(TagID, ImageID)

--All images created by a user, by username and by tag name. Sorted by UploadDate, latest first (primary key, name, link, thumbnail, upload date, times favorited)
SELECT i.ImageID, i.Name, i.Link, i.Thumbnail, i.UploadDate, i.FavoriteCount
FROM Images i
INNER JOIN Users u
ON i.UserID = u.UserID
INNER JOIN Images_Tags it
ON i.ImageID = it.ImageID
INNER JOIN Tags t
ON it.TagID = t.TagID
WHERE u.Name = 'Adi' AND t.Name = 'Cool'
ORDER BY i.UploadDate DESC

--All images in a Gallery. Sorted by UploadDate, latest first (primary key, name, link, thumbnail, upload date)
SELECT i.ImageID, i.Name, i.Link, i.Thumbnail, i.UploadDate
FROM Images i
INNER JOIN Galleries_Images gi
ON i.ImageID = gi.ImageID
INNER JOIN Galleries g
ON gi.GalleryID = g.GalleryID
WHERE g.Name = 'Louvre'
ORDER BY i.UploadDate DESC

CREATE INDEX idx_GalleryName
ON Galleries(Name)

--All images favorited by a user, by username. Sorted by when the user has favorited them, most recent first
-- (primary key, name, link, thumbnail, upload date, times favorited)
SELECT i.ImageID, i.Name, i.Link, i.Thumbnail, i.UploadDate, i.FavoriteCount
FROM Images i
INNER JOIN Users_Images_Favorite uif
ON i.ImageID = uif.ImageID
INNER JOIN Users u
ON uif.UserID = u.UserID
WHERE u.Name = 'Adi'
ORDER BY uif.FavoriteDate DESC

CREATE INDEX idx_UIFUserID_FavoriteDate
ON Users_Images_Favorite(UserID, FavoriteDate DESC)

--All images in a Gallery. Sorted by UploadDate, latest first (primary key, name, link, thumbnail, upload date)
SELECT i.ImageID, i.Name, i.Link, i.Thumbnail, i.UploadDate
FROM Images i
INNER JOIN Galleries_Images gi
ON i.ImageID = gi.ImageID
INNER JOIN Galleries g
ON gi.GalleryID = g.GalleryID
WHERE g.Name = 'Methropolitan'
ORDER BY i.UploadDate DESC

--All images favorited by a user, by username. Sorted by when the user has favorited them, most recent first
-- (primary key, name, link, thumbnail, upload date, times favorited)
SELECT i.ImageID, i.Name, i.Link, i.Thumbnail, i.UploadDate, i.FavoriteCount
FROM Images i
INNER JOIN Users_Images_Favorite uif
ON i.ImageID = uif.ImageID
INNER JOIN Users u
ON uif.UserID = u.UserID
WHERE u.Name = 'Ilian'
ORDER BY uif.FavoriteDate DESC

--All comments for a user, by username. Sorted by DateCreated, latest first (primary key, text, date created, date edited)
SELECT CommentID, Text, DateCreated, DateEdited
FROM Users u
INNER JOIN Comments_Galleries cg
ON u.UserID = cg.UserID
WHERE u.Name = 'Adi'
UNION
SELECT CommentID, Text, DateCreated, DateEdited
FROM Users u
INNER JOIN Comments_Groups cgr
ON u.UserID = cgr.UserID
WHERE u.Name = 'Adi'
UNION
SELECT CommentID, Text, DateCreated, DateEdited
FROM Users u
INNER JOIN Comments_Images ci
ON u.UserID = ci.UserID
WHERE u.Name = 'Adi'
ORDER BY DateCreated DESC

CREATE INDEX idx_Comments_Galleries_UserID_Text_DateCreated_DateEdited
ON Comments_Galleries(UserID, Text, DateCreated DESC, DateEdited)

CREATE INDEX idx_Comments_Groups_UserID_Text_DateCreated_DateEdited
ON Comments_Groups(UserID, Text, DateCreated DESC, DateEdited)

CREATE INDEX idx_Comments_Images_UserID_Text_DateCreated_DateEdited
ON Comments_Images(UserID, Text, DateCreated DESC, DateEdited)

--All comments for an image. Sorted by DateCreated, latest first (primary key, text, date created, date edited)
SELECT ci.CommentID, ci.Text, ci.DateCreated, ci.DateEdited
FROM Comments_Images ci
INNER JOIN Images i
ON ci.ImageID= i.ImageID
WHERE i.Name = 'Picture'
ORDER BY ci.DateCreated DESC

CREATE INDEX idx_ImageName
ON Images(Name)

CREATE INDEX idx_Comments_Images_ImageID_DateCreated_Text_DateEdited
ON Comments_Images(ImageID, DateCreated DESC, Text, DateEdited)

--All comment replies for a comment, by comment primary key. Sorted by DateCreated, latest first (primary key, text, date created, date edited)
SELECT cg.CommentID , cg.Text, cg.DateCreated, cg.DateEdited
FROM Comments_Galleries cg
WHERE cg.PrimaryCommentID = 1
ORDER BY cg.DateCreated DESC

CREATE INDEX idx_Comments_Galleries_PrimaryCommentID_DateCreated_DateEdited_Text
ON Comments_Galleries(PrimaryCommentID, DateCreated DESC, DateEdited, Text)

--All galleries for a user, by username. Ordered by gallery name (primary key, name, times favorited)
SELECT g.GalleryID, g.Name, g.FavoriteCount
FROM Galleries g
INNER JOIN Users u
ON g.UserID = u.UserID
WHERE u.Name = 'Niki'
ORDER BY g.Name

CREATE INDEX idx_UserID_Name
ON Galleries(UserID, Name, FavoriteCount)

--All galleries by tag name. Ordered by gallery name (primary key, name, times favorited)
SELECT g.GalleryID, g.Name, g.FavoriteCount
FROM Tags t
INNER JOIN Galleries_Tags gt
ON t.TagID = gt.TagID
INNER JOIN Galleries g
ON gt.GalleryID = g.GalleryID
WHERE t.Name = 'Uncool'
ORDER BY g.Name

CREATE INDEX idx_TagID_GalleryID
ON Galleries_Tags(TagID, GalleryID)

--All comments for a gallery, by gallery primary key. Sorted by DateCreated, latest first (primary key, text, date created, date edited)
SELECT cg.CommentID, cg.Text, cg.DateCreated, cg.DateEdited
FROM Comments_Galleries cg
INNER JOIN Galleries g
ON cg.GalleryID = g.GalleryID
WHERE g.GalleryID = 2
ORDER BY cg.DateCreated DESC

CREATE INDEX idx_Comments_Galleries_GalleryID_DateCreated_DateEdited_Text
ON Comments_Galleries(GalleryID, DateCreated DESC, DateEdited,  Text)

--All groups that a user is part of. Sorted by group name (primary key, name)
SELECT g.GroupID, g.Name
FROM Users u
INNER JOIN Groups_Users gu
ON u.UserID = gu.UserID
INNER JOIN Groups g
ON gu.GroupID = g.GroupID
WHERE u.Name = 'Ilian'
ORDER BY g.Name

CREATE INDEX idx_UserID_GroupID
ON Groups_Users(UserID, GroupID)

CREATE INDEX idx_GroupID_Name
ON Groups(GroupID, Name)

--All favorited galleries, by user name. Sorted by when the user has favorited them, newest first (primary key, name, times favorited)
SELECT g.GalleryID, g.Name, g.FavoriteCount
FROM Users u
INNER JOIN Users_Galleries_Favorite ugf
ON u.UserID = ugf.UserID
INNER JOIN Galleries g
ON ugf.GalleryID = g.GalleryID
WHERE u.Name = 'Adi'
ORDER BY ugf.FavoriteDate DESC

CREATE INDEX idx_UserID_FavoriteDate
ON Users_Galleries_Favorite(USerID, FavoriteDate DESC)


----
SELECT Tags = 
			STUFF((
				SELECT ',' + t.Name
				FROM Tags t
				INNER JOIN Images_Tags it
				ON t.TagID = it.TagID
				INNER JOIN Images i
				ON it.ImageID = i.ImageID
				WHERE i.ImageID = 2
				FOR XML PATH('')
            ), 1, 1, ''),
			i.Name,
			i.Thumbnail
FROM Images i
WHERE i.ImageID = 2

