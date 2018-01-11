CREATE DATABASE NikiEmail

USE NikiEmail

CREATE TABLE Users(
UserID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Email varchar(30) NOT NULL,
CONSTRAINT uc_UserEmail UNIQUE(Email)
)

CREATE TABLE Folders(
FolderID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name varchar(20) NOT NULL,
UserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID),
CONSTRAINT uc_UserID_Name UNIQUE(Name, UserID)
)

CREATE TABLE Emails(
EmailID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
FromEmail varchar(30) NULL,
ToEmail varchar(30) NULL,
EmailTitle varchar(50) NULL,
EmailText varchar(300) NOT NULL,
IsRead bit NOT NULL,
DateSent datetime NOT NULL,
FolderID int NULL FOREIGN KEY REFERENCES Folders(FolderID),
UserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID)
)

CREATE TABLE Attchments(
AttachmentID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name varchar(30) NOT NULL,
Attachment varbinary(max) NOT NULL,
EmailID int NOT NULL FOREIGN KEY REFERENCES Emails(EmailID)
)

CREATE TABLE Contacts(
ContactID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name varchar(30) NOT NULL,
Email varchar(30) NOT NULL
)

CREATE TABLE Users_Contacts(
UserID int NOT NULL,
ContactID int NOT NULL,
PRIMARY KEY(UserID, ContactID),
FOREIGN KEY(UserID) REFERENCES Users(UserID),
FOREIGN KEY (ContactID) REFERENCES Contacts(ContactID)
)

CREATE TABLE ContactGroups(
GroupID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name varchar(20) NOT NULL
)

CREATE TABLE ContactGroups_Users(
GroupID int NOT NULL,
UserID int NOT NULL,
PRIMARY KEY(GroupID, UserID),
FOREIGN KEY(GroupID) REFERENCES ContactGroups(GroupID),
FOREIGN KEY(UserID) REFERENCES Users(UserID)
)

CREATE TABLE ContactGroups_Contacts(
GroupID int NOT NULL,
ContactID int NOT NULL,
PRIMARY KEY(GroupID, ContactID),
FOREIGN KEY(GroupID) REFERENCES ContactGroups(GroupID),
FOREIGN KEY(ContactID) REFERENCES Contacts(ContactID)
)


--USERS
INSERT INTO Users(Email)
VALUES('aa@abv.bg')

INSERT INTO Users(Email)
VALUES('bb@abv.bg')

INSERT INTO Users(Email)
VALUES('cc@abv.bg')

INSERT INTO Users(Email)
VALUES('dd@abv.bg')

INSERT INTO Users(Email)
VALUES('ee@abv.bg')


--FOLDERS
INSERT INTO Folders(Name, UserID)
VALUES('Fun', 1)

INSERT INTO Folders(Name, UserID)
VALUES('Crap', 1)

INSERT INTO Folders(Name, UserID)
VALUES('Spam', 1)

INSERT INTO Folders(Name, UserID)
VALUES('Fun', 2)

INSERT INTO Folders(Name, UserID)
VALUES('Work', 2)

INSERT INTO Folders(Name, UserID)
VALUES('Work', 3)

INSERT INTO Folders(Name, UserID)
VALUES('Spam', 4)

INSERT INTO Folders(Name, UserID)
VALUES('Travel', 4)

INSERT INTO Folders(Name, UserID)
VALUES('Junk', 5)

INSERT INTO Folders(Name, UserID)
VALUES('Vacation', 5)


--EMAILS
INSERT INTO Emails(EmailTitle, EmailText, IsRead, DateSent, FolderID, UserID)
VALUES('Hi', 'I see you', 0, '2017/09/12', 1, 1)

INSERT INTO Emails(EmailTitle, EmailText, IsRead, DateSent, FolderID, UserID)
VALUES('Bye', 'I hate you', 0, '2017/08/11', 2, 1)

INSERT INTO Emails(EmailTitle, EmailText, IsRead, DateSent, UserID)
VALUES('Vacation', 'Look at my photos', 0, '2017/08/08', 2)

INSERT INTO Emails(EmailTitle, EmailText, IsRead, DateSent, FolderID, UserID)
VALUES('Work', 'Just do it', 0, '2017/08/02', 6, 3)

INSERT INTO Emails(EmailTitle, EmailText, IsRead, DateSent, FolderID, UserID)
VALUES('Cat', 'Fugly cat', 0, '2017/05/11', 7, 4)

INSERT INTO Emails(EmailTitle, EmailText, IsRead, DateSent, FolderID, UserID)
VALUES('Pic', 'big ass', 0, '2017/04/04', 9, 5)

INSERT INTO Emails(EmailTitle, EmailText, IsRead, DateSent, FolderID, UserID)
VALUES('Az', 'Selfie', 0, '2017/05/11', 8, 5)

INSERT INTO Emails(EmailTitle, EmailText, IsRead, DateSent, FolderID, UserID)
VALUES('Ti', 'spy', 0, '2017/01/11', 3, 1)

INSERT INTO Emails(EmailTitle, EmailText, IsRead, DateSent, FolderID, UserID)
VALUES('Pretty', 'boom an ugly dog', 0, '2017/02/10', 4, 2)

INSERT INTO Emails(EmailTitle, EmailText, IsRead, DateSent, FolderID, UserID)
VALUES('Pretty', 'boom an ugly dog', 1, '2017/02/10', 5, 2)


--ATTACHMENTS
INSERT INTO Attchments(Name, EmailID, Attachment)
VALUES('work', 2, CONVERT(varbinary(max), 'run'))

INSERT INTO Attchments(Name, EmailID, Attachment)
VALUES('home', 3, CONVERT(varbinary(max), 'get me'))

INSERT INTO Attchments(Name, EmailID, Attachment)
VALUES('cars', 7, CONVERT(varbinary(max), 'see me'))

INSERT INTO Attchments(Name, EmailID, Attachment)
VALUES('play', 6, CONVERT(varbinary(max), 'hide me'))


--CONTACTS

INSERT INTO Contacts(Name, Email)
VALUES('Niki' , 'nik@abv.bg')

INSERT INTO Contacts(Name, Email)
VALUES('Ilian' , 'ili@abv.bg')

INSERT INTO Contacts(Name, Email)
VALUES('Eli' , 'eli@abv.bg')

INSERT INTO Contacts(Name, Email)
VALUES('Adi' , 'adi@abv.bg')

INSERT INTO Contacts(Name, Email)
VALUES('Pepi' , 'pep@abv.bg')


--CONTACTGROPUS

INSERT INTO ContactGroups(Name)
VALUES('Dumbuldors army')

INSERT INTO ContactGroups(Name)
VALUES('smoking hot people')

INSERT INTO ContactGroups(Name)
VALUES('losers')

--ContactGroups_Users

INSERT INTO ContactGroups_Users(UserID, GroupID)
VALUES(1, 1)

INSERT INTO ContactGroups_Users(UserID, GroupID)
VALUES(1, 2)

INSERT INTO ContactGroups_Users(UserID, GroupID)
VALUES(2, 3)

INSERT INTO ContactGroups_Users(UserID, GroupID)
VALUES(3, 3)

INSERT INTO ContactGroups_Users(UserID, GroupID)
VALUES(4, 3)

INSERT INTO ContactGroups_Users(UserID, GroupID)
VALUES(5, 2)

--CONTACTGROUPS_CONTACTS

INSERT INTO ContactGroups_Contacts(ContactID, GroupID)
VALUES(1, 1)

INSERT INTO ContactGroups_Contacts(ContactID, GroupID)
VALUES(2, 1)

INSERT INTO ContactGroups_Contacts(ContactID, GroupID)
VALUES(3, 2)

INSERT INTO ContactGroups_Contacts(ContactID, GroupID)
VALUES(4, 2)

INSERT INTO ContactGroups_Contacts(ContactID, GroupID)
VALUES(5, 3)

INSERT INTO ContactGroups_Contacts(ContactID, GroupID)
VALUES(1, 2)

INSERT INTO ContactGroups_Contacts(ContactID, GroupID)
VALUES(5, 2)


--USERS_CONTACTS

INSERT INTO Users_Contacts(ContactID, UserID)
VALUES(1, 1)

INSERT INTO Users_Contacts(ContactID, UserID)
VALUES(1, 2)

INSERT INTO Users_Contacts(ContactID, UserID)
VALUES(2, 2)

INSERT INTO Users_Contacts(ContactID, UserID)
VALUES(1, 3)

INSERT INTO Users_Contacts(ContactID, UserID)
VALUES(3, 4)

INSERT INTO Users_Contacts(ContactID, UserID)
VALUES(5, 5)

INSERT INTO Users_Contacts(ContactID, UserID)
VALUES(4, 5)

INSERT INTO Users_Contacts(ContactID, UserID)
VALUES(2, 3)

--SELECTS

--All folders by user email (primary key, name)
SELECT f.FolderID, f.Name
FROM Folders f
INNER JOIN Users u
ON f.UserID = u.UserID
WHERE u.Email = 'aa@abv.bg'

CREATE INDEX idx_UserEmail
ON Users(Email)

CREATE INDEX idx_UserID_Name
ON Folders(UserID, Name)

--All emails in a folder for a user, by folder name (primary key, title, from, IsRead).
-- Sorted by (DateSent, latest first) OR (IsRead with unread first, then by DateSent)
SELECT e.EmailID , e.EmailTitle, e.FromEmail , e.IsRead
FROM Emails e
INNER JOIN Folders f
ON e.FolderID = f.FolderID
WHERE f.Name = 'Spam' AND f.UserID = 4
ORDER BY e.DateSent DESC

SELECT e.EmailID , e.EmailTitle, e.FromEmail , e.IsRead
FROM Emails e
INNER JOIN Folders f
ON e.FolderID = f.FolderID
WHERE f.Name = 'Spam' AND f.UserID = 4
ORDER BY e.IsRead, e.DateSent DESC

CREATE INDEX idx_FolderID_DateSent
ON Emails(FolderID, DateSent DESC)

CREATE INDEX idx_FolderID_IsRead_DateSent
ON Emails(FolderID, IsRead, DateSent DESC)

--All unread emails for a user, by username (primary key, title, from, IsRead). Sorted by (DateSent, latest first)

SELECT e.EmailID, e.EmailTitle, e.FromEmail, e.IsRead
FROM Emails e
INNER JOIN Users u
ON e.UserID = u.UserID
WHERE u.Email = 'aa@abv.bg' AND e.IsRead = 0
ORDER BY e.DateSent DESC

CREATE INDEX idx_UserID_IsRead_DateSent
ON Emails(UserID, IsRead, DateSent DESC)

--All attachments for an email, by email name and DateSent
SELECT a.AttachmentID, a.Name
FROM Attchments a
INNER JOIN Emails e
ON a.EmailID = e.EmailID
WHERE e.EmailTitle = 'Bye' AND e.DateSent = '2017/08/11'

CREATE INDEX idx_EmailID_Name
ON Attchments(EmailID, Name)

CREATE INDEX idx_EmailTitle_DateSent
ON Emails(EmailTitle, DateSent)

--All contact groups by user email (primary key, name) 
SELECT cg.GroupID, cg.Name
FROM ContactGroups_Users cgu
INNER JOIN Users u
ON cgu.UserID= u.UserID
INNER JOIN ContactGroups cg
ON cgu.GroupID = cg.GroupID
WHERE u.Email = 'aa@abv.bg'

CREATE INDEX idx_UserID_GroupID
ON ContactGroups_Users(UserID, GroupID)

--Contact group by contact group name and user email (primary key, name)
SELECT cg.GroupID, cg.Name
FROM ContactGroups cg
INNER JOIN ContactGroups_Users cgu
ON cg.GroupID = cgu.GroupID
INNER JOIN Users u
ON cgu.UserID = u.UserID
WHERE cg.Name = 'smoking hot people' AND u.Email = 'aa@abv.bg'

--All contacts in a contact group by contact group name (primary key, name, email)
SELECT c.ContactID, c.Name, c.Email
FROM Contacts c
INNER JOIN ContactGroups_Contacts cgc
ON c.ContactID = cgc.ContactID
INNER JOIN ContactGroups cg
ON cgc.GroupID = cg.GroupID
WHERE cg.Name = 'smoking hot people'

CREATE INDEX idx_Name
ON ContactGroups(Name)

--Contact by User Email, and Contact Name (primary key, name, email)
SELECT c.ContactID , c.Name, c.Email
FROM Contacts c
INNER JOIN Users_Contacts uc
ON c.ContactID = uc.ContactID
INNER JOIN Users u
ON uc.UserID = u.UserID
WHERE u.Email = 'cc@abv.bg' AND c.Name = 'Niki'

--Contact by User Email, and Contact Email (primary key, name, email)
SELECT c.ContactID, c.Name, c.Email
FROM Contacts c
INNER JOIN Users_Contacts uc
ON c.ContactID = uc.ContactID
INNER JOIN Users u
ON uc.UserID = u.UserID
WHERE u.Email = 'dd@abv.bg' AND c.Email = 'eli@abv.bg'