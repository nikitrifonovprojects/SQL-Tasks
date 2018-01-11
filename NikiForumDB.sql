--CREATE DATABASE NikiForum

USE NikiForum

--User - UserName (Unique), Email (Unique), Password, DateCreated
CREATE TABLE Users(
UserID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserName nvarchar(100) NOT NULL UNIQUE,
Email nvarchar(50) NOT NULL UNIQUE,
UserPassword nvarchar(100) NOT NULL,
DateCreated datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
INDEX idx_Email NONCLUSTERED(Email)
)

--Forum category - Category name (Unique)

CREATE TABLE ForumCategories(
ForumCategoryID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
CategoryName nvarchar(50) NOT NULL UNIQUE
)

--Forum subcategory - sub category name

CREATE TABLE SubCategories(
SubCategoryID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
ForumCategoryID int NOT NULL FOREIGN KEY REFERENCES ForumCategories(ForumCategoryID),
Name nvarchar(50) NOT NULL,
)

--Forum Post - Title(unique), Text (can be very large), User, DateCreated, DateModified, DateDeleted.
-- For a post to be displayed it has to be approved first. A post can be marked as deleted (it should not be deleted from the table)

CREATE TABLE ForumPosts(
ForumPostID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
ForumTitle nvarchar(50) NOT NULL UNIQUE,
ForumText text NOT NULL,
UserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID),
SubCategoryID int NOT NULL FOREIGN KEY REFERENCES SubCategories(SubCategoryID),
DateCreated datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
DateModified datetime NULL DEFAULT CURRENT_TIMESTAMP,
DateDeleted datetime NULL DEFAULT CURRENT_TIMESTAMP,
IsApproved bit NOT NULL,
IsDeleted bit NOT NULL
)

--Forum post log - DateModified, ModifyAction, ModifyUser

CREATE TABLE ForumPostLogs(
LogID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID),
ForumPostID int NOT NULL FOREIGN KEY REFERENCES ForumPosts(ForumPostID),
ModifyAction nvarchar(50) NOT NULL,
DateModified datetime DEFAULT CURRENT_TIMESTAMP
)

--Comment - User, Text, DateCreated

CREATE TABLE Comments(
CommentID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
UserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID),
ForumPostID int NOT NULL FOREIGN KEY REFERENCES ForumPosts(ForumPostID),
ParentCommentID int NULL REFERENCES Comments(CommentID),
CommentText varchar(500) NOT NULL,
DateCreated datetime DEFAULT CURRENT_TIMESTAMP
)

--Upvotes/downvotes - Each forum post can be upvoted or downvoted 1 time per user. Each Comment can also be upvoted or downvoted once per user
-- Rethink
CREATE TABLE CommentsVotes(
UsersID int NOT NULL FOREIGN KEY REFERENCES Users(UserID),
CommentID int FOREIGN KEY REFERENCES Comments(CommentID),
PRIMARY KEY(UsersID, CommentID),
IsVotedUp bit NOT NULL
)

CREATE TABLE ForumPostsVotes(
UsersID int NOT NULL FOREIGN KEY REFERENCES Users(UserID),
ForumPostID int FOREIGN KEY REFERENCES ForumPosts(ForumPostID),
PRIMARY KEY(UsersID, ForumPostID),
IsVotedUp bit NOT NULL
)


--Tags - Title

CREATE TABLE Tags(
TagID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Title nvarchar(50) NOT NULL UNIQUE,
INDEX idx_Tags NONCLUSTERED(Title)
)

CREATE TABLE Tags_ForumPosts(
ForumPostID int NOT NULL,
TagID int NOT NULL,
PRIMARY KEY(ForumPostID, TagID),
FOREIGN KEY(ForumPostID) REFERENCES ForumPosts(ForumPostID),
FOREIGN KEY(TagID) REFERENCES Tags(TagID)
)

--Notifications - DateCreated, Text

CREATE TABLE Notifications(
NotificationID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
UserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID),
DateCreated datetime DEFAULT CURRENT_TIMESTAMP,
NotificationsText varchar(150) NOT NULL
)

--USER
INSERT INTO Users(UserName, UserPassword, Email)
VALUES('Ilian', '235618', 'il@abv.bg')

INSERT INTO Users(UserName, UserPassword, Email)
VALUES('Niki', '235618', 'ni@abv.bg')

INSERT INTO Users(UserName, UserPassword, Email)
VALUES('Pepi', '235618', 'pi@abv.bg')

INSERT INTO Users(UserName, UserPassword, Email)
VALUES('Goro', '235618', 'go@abv.bg')

--Category
INSERT INTO ForumCategories(CategoryName)
VALUES('Technology')

INSERT INTO ForumCategories(CategoryName)
VALUES('Books')

INSERT INTO ForumCategories(CategoryName)
VALUES('IT')

INSERT INTO ForumCategories(CategoryName)
VALUES('Cars')

--SubCategory
INSERT INTO SubCategories(ForumCategoryID, Name)
VALUES(1,'Washing Mashines')

INSERT INTO SubCategories(ForumCategoryID, Name)
VALUES(2,'Horror')

INSERT INTO SubCategories(ForumCategoryID, Name)
VALUES(3,'Coding')

INSERT INTO SubCategories(ForumCategoryID, Name)
VALUES(1,'Coupe')

INSERT INTO SubCategories(ForumCategoryID, Name)
VALUES(1,'SUV')

--ForumPosts
INSERT INTO ForumPosts(UserID, SubCategoryID, ForumTitle, ForumText, IsApproved , IsDeleted)
VALUES(1, 1, 'LG washing mashine' , 'It sucks', 0, 0)

INSERT INTO ForumPosts(UserID, SubCategoryID, ForumTitle, ForumText, IsApproved, IsDeleted)
VALUES(2, 2, 'Texas massacre' , 'It rocks', 0, 0)

INSERT INTO ForumPosts(UserID, SubCategoryID, ForumTitle, ForumText, IsApproved, IsDeleted)
VALUES(3, 3, 'SQL' , 'aaaaaa', 0, 0)

INSERT INTO ForumPosts(UserID, SubCategoryID, ForumTitle, ForumText, IsApproved, IsDeleted)
VALUES(4, 4, 'Mazda coupe' , 'Yey', 0, 0)

INSERT INTO ForumPosts(UserID, SubCategoryID, ForumTitle, ForumText, IsApproved, IsDeleted)
VALUES(1, 4, 'Honda coupe' , 'Yey', 0, 0)

--Comments
INSERT INTO Comments(ForumPostID, UserID, CommentText)
VALUES(9, 3 , 'I Like it')

INSERT INTO Comments(ForumPostID, UserID, CommentText)
VALUES(9, 3 , 'I Like alot')

INSERT INTO Comments(ForumPostID, UserID, CommentText, ParentCommentID)
VALUES(9, 3 , 'I Like alot', 3)

--Logs
INSERT INTO ForumPostLogs(ForumPostID , ModifyAction, UserID)
VALUES(10, 'laugh' , 3)

INSERT INTO ForumPostLogs(ForumPostID , ModifyAction, UserID)
VALUES(11, 'cry' , 2)

--Tags

INSERT INTO Tags(Title)
VALUES('brum')

INSERT INTO Tags(Title)
VALUES('brum 2')

ALTER TABLE Tags   
ADD CONSTRAINT AK_Title UNIQUE (Title)

INSERT INTO Tags_ForumPosts(ForumPostID, TagID)
VALUES(9,1)

INSERT INTO Tags_ForumPosts(ForumPostID, TagID)
VALUES(9,2)

INSERT INTO Tags_ForumPosts(ForumPostID, TagID)
VALUES(10,2)

--Votes

INSERT INTO CommentsVotes(IsVotedUp, UsersID, CommentID)
VALUES(0, 3, 3)

INSERT INTO ForumPostsVotes(IsVotedUp, ForumPostID, UsersID)
VALUES(1, 10, 4)

-- Notifications

INSERT INTO Notifications (UserID, NotificationsText)
VALUES (3, 'you suck')

select fp.ForumTitle
from ForumPosts fp
INNER JOIN SubCategories sub
ON sub.SubCategoryID = fp.SubCategoryID
INNER JOIN ForumCategories fc
ON fc.ForumCategoryID = sub.ForumCategoryID
where fc.CategoryName = 'IT'

CREATE INDEX idx_FK_ForumCategoryID
ON SubCategories(ForumCategoryID)

CREATE INDEX idx_FK_SubCategoryID
ON ForumPosts(SubCategoryID)

SELECT fp.ForumPostID , fp.ForumTitle
FROM ForumPosts fp
INNER JOIN SubCategories sc
ON sc.SubCategoryID = fp.SubCategoryID
WHERE sc.Name = 'Washing Mashines'

CREATE INDEX idx_FK_SubCategoryID_ForumTitle
ON ForumPosts(SubCategoryID, ForumTitle)

SELECT fp.ForumTitle, fp.ForumPostID
FROM ForumPosts fp
INNER JOIN Tags_ForumPosts t
ON t.ForumPostID = fp.ForumPostID
INNER JOIN Tags tag
ON tag.TagID = t.TagID
WHERE tag.Title = 'brum'

CREATE INDEX idx_TagID_ForumPostID
ON Tags_ForumPosts(TagID,ForumPostID)

SELECT Tags.Title, Tags.TagID
FROM Tags
WHERE Title = 'brum'

SELECT c.CommentText, c.CommentID
FROM Comments c
INNER JOIN Users u
ON c.UserID = u.UserID
WHERE u.UserName = 'Pepi'

CREATE INDEX idx_UserID
ON Comments(UserID , CommentText)


SELECT c.CommentText , c.CommentID
FROM Comments c
INNER JOIN ForumPosts fp
ON fp.ForumPostID = c.ForumPostID
WHERE fp.ForumTitle = 'LG washing mashine'

CREATE INDEX idx_ForumPostID
ON Comments(ForumPostID, CommentText)

SELECT fp.ForumPostID , fp.ForumTitle
FROM ForumPosts fp
INNER JOIN Users u
ON fp.UserID = u.UserID
WHERE u.UserName = 'Pepi'

CREATE INDEX idx_UserID
ON ForumPosts(UserID, ForumTitle)

SELECT u.UserID, u.UserName
FROM Users u
WHERE u.Email = 'ni@abv.bg'
