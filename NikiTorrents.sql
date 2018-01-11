CREATE DATABASE NikiTorrents
GO
USE NikiTorrents
GO

Create TABLE ViewTypes(
ViewID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(10) NOT NULL,
CONSTRAINT uc_ViewName UNIQUE(Name)
)

CREATE TABLE Ranks(
RankID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(10),
CONSTRAINT uc_RankName UNIQUE(Name)
)

CREATE TABLE Users(
UserID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
Password nvarchar(15) NOT NULL,
Email nvarchar(15) NOT NULL,
DateCreated datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
Rating decimal(3,3) NOT NULL,
Uploaded decimal(2,2) NOT NULL,
Downloaded decimal(2,2) NOT NULL,
ViewID int NOT NULL FOREIGN KEY REFERENCES ViewTypes(ViewID),
RankID int NOT NULL FOREIGN KEY REFERENCES Ranks(RankID),
CONSTRAINT uc_UserName UNIQUE(Name),
CONSTRAINT uc_UserEmail UNIQUE(Email)
)

CREATE TABLE UserLogins(
UserLoginID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
UserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID),
LoginTimeStamp datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
)

CREATE TABLE Messages(
MessageID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Text text NOT NULL,
DateCreated smalldatetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
SenderID int NOT NULL FOREIGN KEY REFERENCES Users(UserID),
RecepientID int NOT NULL FOREIGN KEY REFERENCES Users(UserID)
)

CREATE TABLE Users_Messsages(
MessageID int NOT NULL,
UserID int NOT NULL,
DateSent smalldatetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY(MessageID, UserID),
FOREIGN KEY(MessageID) REFERENCES Messages(MessageID),
FOREIGN KEY(UserID) REFERENCES Users(UserID)
)

CREATE TABLE Catalogues(
CatalogID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
CONSTRAINT uc_CatalogName UNIQUE(Name)
)

CREATE TABLE Categories(
CategoryID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
CatalogID int NOT NULL FOREIGN KEY REFERENCES Catalogues(CatalogID),
CONSTRAINT uc_CategoryName UNIQUE(Name)
)

CREATE TABLE Genres(
GenreID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL
)

CREATE TABLE Torrents(
TorrentID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
TorrentFile varbinary(max) NOT NULL,
Name varchar(20) NOT NULL,
VideoLink nvarchar(40) NULL,
InfoFile varbinary(max) NULL,
Description text NOT NULL,
HasBgSubs bit NOT NULL,
HasBgAudio bit NOT NULL,
DateUploaded datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
UserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID),
Link nvarchar(30) NOT NULL,
Size decimal(2,2) NOT NULL,
TotalVotes int NOT NULL,
CurrentRating decimal(1,1) NOT NULL,
RatingCount int NOT NULL,
FileCount int NOT NULL,
Seeders int NOT NULL,
Leechers int NOT NULL,
LastActive smalldatetime NOT NULL,
TimesLikedDisliked int NOT NULL,
FavoritedCount int NOT NULL,
CommentsCount int NOT NULL,
TimesDownloaded int NOT NULL,
CategoryID int NOT NULL FOREIGN KEY REFERENCES Categories(CategoryID)
)

CREATE TABLE Ratings(
RatingID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(10) NOT NULL,
RatingValue int NOT NULL,
CONSTRAINT uc_RatingNameValue UNIQUE(Name, RatingValue)
)

CREATE TABLE Users_Torrents_Ratings(
UserID int NOT NULL,
TorrentID int NOT NULL,
RatingID int NOT NULL FOREIGN KEY REFERENCES Ratings(RatingID),
PRIMARY KEY(UserID, TorrentID),
FOREIGN KEY(UserID) REFERENCES Users(UserID),
FOREIGN KEY(TorrentID) REFERENCES Torrents(TorrentID)
)

CREATE TABLE Files(
FileID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Directory nvarchar(247) NOT NULL,
Size nvarchar(10) NOT NULL,
TorrentID int NOT NULL FOREIGN KEY REFERENCES Torrents(TorrentID)
)

CREATE TABLE TorrentComments(
CommentID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Text text NOT NULL,
DateCreated datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
DateEdited datetime NULL,
PrimaryCommentID int NULL FOREIGN KEY REFERENCES TorrentComments(CommentID),
UserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID),
TorrentID int NOT NULL FOREIGN KEY REFERENCES Torrents(TorrentID)
)

CREATE TABLE Categories_Genres(
CategoryID int NOT NULL,
GenreID int NOT NULL,
PRIMARY KEY(CategoryID, GenreID),
FOREIGN KEY(CategoryID) REFERENCES Categories(CategoryID),
FOREIGN KEY(GenreID) REFERENCES Genres(GenreID)
)

CREATE TABLE Torrents_Genres(
TorrentID int NOT NULL,
GenreID int NOT NULL,
PRIMARY KEY(TorrentID, GenreID),
FOREIGN KEY(TorrentID) REFERENCES Torrents(TorrentID),
FOREIGN KEY(GenreID) REFERENCES Genres(GenreID)
)

CREATE TABLE Torrents_Favorites(
TorrentID int NOT NULL,
UserID int NOT NULL,
DateFavorited smalldatetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY(TorrentID, UserID),
FOREIGN KEY(TorrentID) REFERENCES Torrents(TorrentID),
FOREIGN KEY(UserID) REFERENCES Users(UserID)
)

CREATE TABLE TorrentLikesDislikes(
TorrentID int NOT NULL,
UserID int NOT NULL,
IsLiked bit NOT NULL,
DateLiked smalldatetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY(TorrentID, UserID),
FOREIGN KEY(TorrentID) REFERENCES Torrents(TorrentID),
FOREIGN KEY(UserID) REFERENCES Users(UserID)
)

CREATE TABLE Tags(
TagID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
)

CREATE TABLE Torrents_Tags(
TagID int NOT NULL,
TorrentID int NOT NULL,
PRIMARY KEY(TagID, TorrentID),
FOREIGN KEY(TorrentID) REFERENCES Torrents(TorrentID),
FOREIGN KEY(TagID) REFERENCES Tags(TagID)
)


--SELECTS

--Show all torrents by genre name, order by dateuploaded desc
SELECT t.Name, t.Link, t.CommentsCount, t.CurrentRating, t.DateUploaded, t.Size, t.TimesDownloaded, t.Seeders, t.Leechers
FROM Torrents t
INNER JOIN Torrents_Genres tg
ON t.TorrentID = tg.TorrentID
INNER JOIN Genres g
ON tg.GenreID = g.GenreID
WHERE g.Name IN ('aaaa', 'sda')
ORDER BY t.DateUploaded DESC
OFFSET 20 ROWS
FETCH NEXT 20 ROWS ONLY;

CREATE INDEX idx_Name
ON Genres(Name)

CREATE INDEX idx_GenreID_TorrentID
ON Torrents_Genres(GenreID, TorrentID)

--Show torrents by multiple categories by name order by date uploaded
SELECT t.Name, t.Link, t.CommentsCount, t.CurrentRating, t.DateUploaded, t.Size, t.TimesDownloaded, t.Seeders, t.Leechers
FROM Torrents t
INNER JOIN Torrents_Genres tg
ON t.TorrentID = tg.TorrentID
INNER JOIN Genres g
ON tg.GenreID = g.GenreID
INNER JOIN Categories_Genres cg
ON g.GenreID = cg.GenreID
INNER JOIN Categories c
ON cg.CategoryID = c.CategoryID
WHERE c.Name IN ('aaaa', 'adas', 'adad', 'fff', 'dffff')
ORDER BY t.DateUploaded DESC
OFFSET 20 ROWS
FETCH NEXT 20 ROWS ONLY;

--Show torrents by Catalogue name , order by date uploaded
SELECT t.Name, t.Link, t.CommentsCount, t.CurrentRating, t.DateUploaded, t.Size, t.TimesDownloaded, t.Seeders, t.Leechers
FROM Torrents t
INNER JOIN Torrents_Genres tg
ON t.TorrentID = tg.TorrentID
INNER JOIN Genres g
ON tg.GenreID = g.GenreID
INNER JOIN Categories_Genres cg
ON g.GenreID = cg.GenreID
INNER JOIN Categories c
ON cg.CategoryID = c.CategoryID
INNER JOIN Catalogues cat
ON c.CatalogID = cat.CatalogID
WHERE cat.Name = 'Action'
ORDER BY t.DateUploaded DESC
OFFSET 20 ROWS
FETCH NEXT 20 ROWS ONLY;

CREATE INDEX idx_CatalogID_CategoryID
ON Categories(CatalogID, CategoryID)

--Show torrent details by torrent ID
SELECT t.TorrentFile,
	   t.Description,
	   t.InfoFile,
	    Genre = 
			STUFF((
				SELECT ',' + g.Name
				FROM Genres g
				INNER JOIN Torrents_Genres tg
				ON g.GenreID = tg.GenreID
				INNER JOIN Torrents t
				ON tg.TorrentID = t.TorrentID
				WHERE t.TorrentID = 1
				FOR XML PATH('')
            ), 1, 1, ''),
	   t.Size,
	   t.CurrentRating,
	   t.DateUploaded,
	   t.LastActive,
	   t.TimesDownloaded, 
	   t.FileCount,
	   t.Seeders,
	   t.Leechers
FROM Torrents t
WHERE t.TorrentID = 1

--Show Torrent comments by torentID , order by date latest
SELECT u.Name, r.Name, tc.DateCreated
FROM TorrentComments tc
INNER JOIN Torrents t
ON tc.TorrentID = t.TorrentID
INNER JOIN Users u
ON tc.UserID = u.UserID
INNER JOIN Ranks r
ON u.RankID = r.RankID
WHERE t.TorrentID = 1
ORDER BY tc.DateCreated DESC
OFFSET 20 ROWS
FETCH NEXT 20 ROWS ONLY;

CREATE INDEX idx_TorrentID_DateCreated_UserID
ON TorrentComments(TorrentID, DateCreated DESC, UserID)

--