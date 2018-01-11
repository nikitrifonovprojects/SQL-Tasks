CREATE DATABASE NikiLibrary

USE NikiLibrary

CREATE TABLE Users(
UserID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
Name varchar(40) NOT NULL,
CONSTRAINT uc_Name UNIQUE(Name)
)
TRUNCATE TABLE Users

CREATE TABLE Genre(
GenreID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
Name varchar(40) NOT NULL,
CONSTRAINT uc_GenreName UNIQUE(Name)
)
TRUNCATE TABLE Genre

CREATE TABLE Language(
LanguageID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
Name varchar(40) NOT NULL,
ShortName varchar(10) NOT NULL,
CONSTRAINT uc_ShortName UNIQUE(ShortName)
)
TRUNCATE TABLE Language

CREATE TABLE Author(
AuthorID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
Name varchar(40) NOT NULL,
Age int NOT NULL,
CONSTRAINT uc_AuthorName UNIQUE(Name)
)
TRUNCATE TABLE Author

CREATE TABLE Book(
BookID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
Name varchar(40) NOT NULL,
ISBN varchar(60) NOT NULL,
IsRented bit NOT NULL,
AuthorID int NOT NULL FOREIGN KEY REFERENCES Author(AuthorID),
LanguageID int NOT NULL FOREIGN KEY REFERENCES Language(LanguageID),
TranslatedFromBookID int NULL FOREIGN KEY REFERENCES Book(BookID)
)
TRUNCATE TABLE Book

CREATE TABLE CoAuthor_Book(
CoAuthorID int NOT NULL,
BookID int NOT NULL,
PRIMARY KEY(CoAuthorID, BookID),
FOREIGN KEY(CoAuthorID) REFERENCES Author(AuthorID),
FOREIGN KEY(BookID) REFERENCES Book(BookID)
)
TRUNCATE TABLE CoAuthor_Book

CREATE TABLE RentedBooks(
RentedBookID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
BookID int NULL FOREIGN KEY REFERENCES Book(BookID),
UserID int NULL FOREIGN KEY REFERENCES Users(UserID),
RentDate datetime NOT NULL,
ReturnDate datetime NULL
)
TRUNCATE TABLE RentedBooks

CREATE TABLE Book_Genre(
GenreID int NOT NULL,
BookID int NOT NULL,
PRIMARY KEY(GenreID, BookID),
FOREIGN KEY(GenreID) REFERENCES Genre(GenreID),
FOREIGN KEY(BookID) REFERENCES Book(BookID)
)
TRUNCATE TABLE Book_Genre


--USERS
INSERT INTO Users(Name)
VALUES('Niki')

INSERT INTO Users(Name)
VALUES('Ilian')

INSERT INTO Users(Name)
VALUES('Adi')

INSERT INTO Users(Name)
VALUES('Eli')

--AUTORS
INSERT INTO Author(Name , Age)
VALUES('Arthur' , 34)

INSERT INTO Author(Name , Age)
VALUES('John' , 36)

INSERT INTO Author(Name , Age)
VALUES('Ben' , 30)

INSERT INTO Author(Name , Age)
VALUES('Karl' , 44)

INSERT INTO Author(Name , Age)
VALUES('Mark' , 50)

--Language
INSERT INTO Language(Name, ShortName)
VALUES('English' , 'EN')

INSERT INTO Language(Name, ShortName)
VALUES('German' , 'GR')

INSERT INTO Language(Name, ShortName)
VALUES('Bulgarian' , 'BG')

INSERT INTO Language(Name, ShortName)
VALUES('French' , 'FR')

INSERT INTO Language(Name, ShortName)
VALUES('Turkish' , 'TR')

--GENRE
INSERT INTO Genre(Name)
VALUES('Horror')

INSERT INTO Genre(Name)
VALUES('Comedy')

INSERT INTO Genre(Name)
VALUES('Action')

INSERT INTO Genre(Name)
VALUES('Fantasy')

INSERT INTO Genre(Name)
VALUES('Young Adult')

--BOOKS
INSERT INTO Book(Name, ISBN, LanguageID, AuthorID, IsRented)
VALUES('Gone Girl', 'AG-8787899977', 1, 1, 0)

INSERT INTO Book(Name, ISBN, LanguageID, AuthorID, IsRented)
VALUES('Dragons', 'AG-855499977', 2, 2, 0)

INSERT INTO Book(Name, ISBN, LanguageID, AuthorID, IsRented)
VALUES('God is dead', 'AG-5464321', 1, 3, 0)

INSERT INTO Book(Name, ISBN, LanguageID, AuthorID, IsRented)
VALUES('Where is God', 'AG-87884233977', 4, 4, 0)

INSERT INTO Book(Name, ISBN, LanguageID, AuthorID, IsRented)
VALUES('The Dragon ate God?', 'AG-87833229977', 1, 4, 0)

INSERT INTO Book(Name, ISBN, LanguageID, AuthorID, IsRented)
VALUES('Gone Girl dates God', 'AG-87567899977', 1, 5, 0)

--TRANSLATION
INSERT INTO Book(Name, ISBN, LanguageID, AuthorID, IsRented, TranslatedFromBookID)
VALUES('Frau Gone', 'AG-8787899977', 2, 2, 0, 1)

INSERT INTO Book(Name, ISBN, LanguageID, AuthorID, IsRented, TranslatedFromBookID)
VALUES('Kuku Jena', 'AG-8787899977', 3, 3, 0, 1)

INSERT INTO Book(Name, ISBN, LanguageID, AuthorID, IsRented, TranslatedFromBookID)
VALUES('Dragon Efendi', 'AG-855499977', 5, 4, 0 , 2)

INSERT INTO Book(Name, ISBN, LanguageID, AuthorID, IsRented, TranslatedFromBookID)
VALUES('Vu le vu God', 'AG-87884233977', 4, 5, 0, 3)

--CoAuthor
INSERT INTO CoAuthor_Book(CoAuthorID, BookID)
VALUES(2, 1)

INSERT INTO CoAuthor_Book(CoAuthorID, BookID)
VALUES(3, 2)

INSERT INTO CoAuthor_Book(CoAuthorID, BookID)
VALUES(4, 3)

INSERT INTO CoAuthor_Book(CoAuthorID, BookID)
VALUES(5, 1)

INSERT INTO CoAuthor_Book(CoAuthorID, BookID)
VALUES(4, 1)

INSERT INTO CoAuthor_Book(CoAuthorID, BookID)
VALUES(1, 6)


--BOOK_GENRE
INSERT INTO Book_Genre(BookID, GenreID)
VALUES(1, 1)

INSERT INTO Book_Genre(BookID, GenreID)
VALUES(2, 4)

INSERT INTO Book_Genre(BookID, GenreID)
VALUES(3, 2)

INSERT INTO Book_Genre(BookID, GenreID)
VALUES(4, 5)

INSERT INTO Book_Genre(BookID, GenreID)
VALUES(5, 1)

INSERT INTO Book_Genre(BookID, GenreID)
VALUES(6, 5)

INSERT INTO Book_Genre(BookID, GenreID)
VALUES(7, 1)

INSERT INTO Book_Genre(BookID, GenreID)
VALUES(8, 1)

INSERT INTO Book_Genre(BookID, GenreID)
VALUES(9, 2)

INSERT INTO Book_Genre(BookID, GenreID)
VALUES(10, 5)

--RENTED BOOKS
INSERT INTO RentedBooks(BookID, RentDate, UserID)
VALUES(1, '2017/01/01', 1)

UPDATE Book
SET IsRented = 1
WHERE BookID = 1

INSERT INTO RentedBooks(BookID, RentDate, UserID)
VALUES(3, '2017/01/02', 2)

UPDATE Book
SET IsRented = 1
WHERE BookID = 3

INSERT INTO RentedBooks(BookID, RentDate, UserID)
VALUES(2, '2017/01/03', 3)

UPDATE Book
SET IsRented = 1
WHERE BookID = 2

UPDATE RentedBooks
SET ReturnDate = '2017/01/05'
WHERE BookID = 2

UPDATE Book
SET IsRented = 0
WHERE BookID = 2


---SELECTS

--All books by genre name (primary key, book name, book language name, primary author name, ISBN, Currently Rented?)
SELECT b.BookID, b.Name, l.Name, a.Name, b.ISBN, b.IsRented
FROM Book b
INNER JOIN Language l
ON l.LanguageID = b.LanguageID
INNER JOIN Author a
ON a.AuthorID = b.AuthorID
INNER JOIN Book_Genre bg
ON bg.BookID = b.BookID
INNER JOIN Genre g
ON g.GenreID = bg.GenreID
WHERE g.Name = 'Horror'

--All genres assigned to a book (primary key, name)
SELECT g.GenreID, g.Name
FROM Genre g
INNER JOIN Book_Genre bg
ON g.GenreID = bg.GenreID
INNER JOIN Book b
ON bg.BookID = b.BookID
WHERE b.Name = 'The Dragon ate God?'

CREATE INDEX idx_BookID_GenreID
ON Book_Genre(BookID, GenreID)

CREATE INDEX idx_Name
ON Book(Name)


--All languages a book is in, by ISBN (primary key, book name, book language name, primary author name, Currently Rented?)
SELECT b.BookID, b.Name, l.Name , a.Name, b.IsRented
FROM Language l
INNER JOIN Book b
ON l.LanguageID = b.LanguageID
INNER JOIN Author a
ON a.AuthorID = b.AuthorID
WHERE b.ISBN = 'AG-8787899977'

CREATE INDEX idx_ISBN_Name_AuthorID_LanguageID_IsRented
ON Book(ISBN, Name, AuthorID, LanguageID, IsRented)


--All books in a certain language, by language name. (primary key, book name, book name in the original language, primary author name, ISBN, Currently Rented?)
SELECT b.BookID , b.Name, COALESCE(bo.Name, b.Name), a.Name, b.ISBN, b.IsRented
FROM Book b
INNER JOIN Language l
ON b.LanguageID = l.LanguageID
INNER JOIN Author a
ON b.AuthorID = a.AuthorID
LEFT OUTER JOIN Book bo
ON b.TranslatedFromBookID = bo.BookID
WHERE l.Name = 'German'

CREATE INDEX idx_LanguageName
ON Language(Name)

CREATE INDEX idx_LanguageID_Name_AuthorID_ISBN_IsRented_TranslatedFromBookID
ON Book(LanguageID, Name, AuthorID, ISBN, IsRented ,TranslatedFromBookID)


--All authors by ISBN (primary key, author name)
-- FIX co author
SELECT a.AuthorID, a.Name, b.ISBN
FROM Book b 
INNER JOIN Author a 
ON b.AuthorID = a.AuthorID
WHERE b.ISBN = 'AG-8787899977'
UNION
SELECT a.AuthorID, a.Name, b.ISBN
FROM Book b
INNER JOIN CoAuthor_Book cb
ON b.BookID = cb.BookID
INNER JOIN Author a
ON cb.CoAuthorID = a.AuthorID
WHERE ISBN = 'AG-8787899977'

CREATE INDEX idx_CoAuthorID_BookID
ON CoAuthor_Book(BookID, CoAuthorID)

--All books by author name. Show only the one in the original language (primary key, book name, book name in the original language,
-- primary author name, ISBN, Currently Rented?)
-- FIX co author
SELECT b.BookID , COALESCE(bo.Name, b.Name), a.Name, b.ISBN, b.IsRented
FROM Book b
INNER JOIN Language l
ON b.LanguageID = l.LanguageID
INNER JOIN Author a
ON b.AuthorID = a.AuthorID
LEFT OUTER JOIN Book bo
ON b.TranslatedFromBookID = bo.BookID
WHERE a.Name = 'Ben'
UNION
SELECT b.BookID , COALESCE(bo.Name, b.Name), a.Name, b.ISBN, b.IsRented
FROM Book b
INNER JOIN Language l
ON l.LanguageID = b.LanguageID
INNER JOIN CoAuthor_Book cb
ON b.BookID = cb.BookID
INNER JOIN Author a
ON a.AuthorID = cb.CoAuthorID
LEFT OUTER JOIN Book bo
ON b.TranslatedFromBookID = bo.BookID
WHERE a.Name = 'Ben'


CREATE INDEX idx_AuthorName
ON Author(Name)

CREATE INDEX idx_AuthorID_Name_ISBN_IsRented_TranslatedFromBookID
ON Book(AuthorID, Name, ISBN, IsRented, TranslatedFromBookID)