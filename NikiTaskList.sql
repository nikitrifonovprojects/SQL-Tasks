--CREATE DATABASE NikiTaskList

USE NikiTaskList

CREATE TABLE Users(
UserID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserName nvarchar(50) NOT NULL,
ActiveUserOptionID int NULL,
CONSTRAINT uc_UserName UNIQUE(UserName)
)

CREATE TABLE Priorities(
PrioritiyID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
Name nvarchar(40) NOT NULL,
Rank int NOT NULL,
CONSTRAINT uc_Name UNIQUE(Name),
CONSTRAINT uc_Rank UNIQUE(Rank)
)

CREATE TABLE TaskLists(
TaskListID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
Name nvarchar(50) NOT NULL,
CONSTRAINT uc_TaskList UNIQUE(Name),
UserID int NOT NULL FOREIGN KEY REFERENCES Users(UserID)
)

CREATE TABLE Tasks(
TaskID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
Name nvarchar(30) NOT NULL,
DateCreated datetime DEFAULT CURRENT_TIMESTAMP,
DateDue datetime NULL,
Description nvarchar(400) NULL,
PrioritiyID int FOREIGN KEY REFERENCES Priorities(PrioritiyID),
TaskListID int NOT NULL FOREIGN KEY REFERENCES TaskLists(TaskListID),
IsFinished bit NOT NULL
)

CREATE TABLE DisplayTypes(
DisplayTypeID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
Name nvarchar(50) NOT NULL,
CONSTRAINT us_Name UNIQUE(Name)
)

CREATE TABLE UserOptions(
UserOptionID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
Name nvarchar(50) NOT NULL,
ItemsPerPage int NOT NULL,
TaskListDisplayTypeID int NOT NULL FOREIGN KEY REFERENCES DisplayTypes(DisplayTypeID),
DetailsDisplayTypeID int NOT NULL FOREIGN KEY REFERENCES DisplayTypes(DisplayTypeID),
TasksDisplayTypeID int NOT NULL FOREIGN KEY REFERENCES DisplayTypes(DisplayTypeID),
UserID int FOREIGN KEY REFERENCES Users(UserID)
)

ALTER TABLE Users
ADD FOREIGN KEY(ActiveUserOptionID) REFERENCES UserOptions(UserOptionID)



INSERT INTO Users(UserName)
VALUES('Niki')

INSERT INTO Users(UserName)
VALUES('Ilian')

INSERT INTO Users(UserName)
VALUES('Adi')

INSERT INTO Users(UserName)
VALUES('Eva')

INSERT INTO Users(UserName)
VALUES('Eli')

UPDATE Users
SET ActiveUserOptionID = 1
WHERE UserName = 'Niki'

UPDATE Users
SET ActiveUserOptionID = 2
WHERE UserName = 'Ilian'

INSERT INTO Priorities(Name, Rank)
VALUES('Very High' , 1)

INSERT INTO Priorities(Name, Rank)
VALUES('High' , 2)

INSERT INTO Priorities(Name, Rank)
VALUES('Medium' , 3)

INSERT INTO Priorities(Name, Rank)
VALUES('Low' , 4)

INSERT INTO Priorities(Name, Rank)
VALUES('Very Low' , 5)


INSERT INTO TaskLists(Name, UserID)
VALUES('Count birds' , 1)

INSERT INTO TaskLists(Name, UserID)
VALUES('Catch wolves' , 2)

INSERT INTO TaskLists(Name, UserID)
VALUES('Count sheep' , 3)

INSERT INTO TaskLists(Name, UserID)
VALUES('Do pushups' , 4)

INSERT INTO TaskLists(Name, UserID)
VALUES('Do backflips' , 2)


INSERT INTO Tasks(Name, PrioritiyID, DateDue, Description, TaskListID, IsFinished)
VALUES('Find Bird', 1, '2017/2/12' , 'Look for birds in the woods', 1, 0)

INSERT INTO Tasks(Name, PrioritiyID, DateDue, Description, TaskListID, IsFinished)
VALUES('Find wolf', 2, '2017/2/18' , 'Look for wolves in the woods', 2, 0)

INSERT INTO Tasks(Name, PrioritiyID, DateDue, Description, TaskListID, IsFinished)
VALUES('Find sheep', 3, '2017/2/12' , 'Look for sheep in the back yard', 3, 0)

INSERT INTO Tasks(Name, PrioritiyID, DateDue, Description, TaskListID, IsFinished)
VALUES('Catch Bird', 4, '2017/2/12' , 'Do it', 1, 0)

INSERT INTO Tasks(Name, PrioritiyID, DateDue, Description, TaskListID, IsFinished)
VALUES('Run', 1, '2017/2/12' , 'Run for it', 1, 0)

UPDATE Tasks 
SET IsFinished = 1
WHERE TaskID = 1

INSERT INTO DisplayTypes(Name)
VALUES('List')

INSERT INTO DisplayTypes(Name)
VALUES('Grid')


INSERT INTO UserOptions(Name, DetailsDisplayTypeID, TaskListDisplayTypeID, TasksDisplayTypeID, ItemsPerPage)
VALUES('New option' , 1, 1, 2, 100)

INSERT INTO UserOptions(Name, DetailsDisplayTypeID, TaskListDisplayTypeID, TasksDisplayTypeID, ItemsPerPage)
VALUES('Old option' , 2, 1, 1, 50)

INSERT INTO UserOptions(Name, DetailsDisplayTypeID, TaskListDisplayTypeID, TasksDisplayTypeID, ItemsPerPage)
VALUES('Crap option' , 1, 2, 2, 1)

UPDATE UserOptions
SET UserID = 1
WHERE UserOptionID = 2

UPDATE UserOptions
SET UserID = 2
WHERE UserOptionID = 3

UPDATE UserOptions
SET UserID = 3
WHERE UserOptionID = 1

UPDATE UserOptions
SET UserID = 2
WHERE UserOptionID = 1


--Users by username (get the primary key)
SELECT u.UserID
FROM Users u
WHERE u.UserName = 'Niki'

--All task lists for a single user, by username. Sorted by Name, ascending. (primary key, Name)
SELECT tl.TaskListID , tl.Name
FROM TaskLists tl
INNER JOIN Users u
ON tl.UserID = u.UserID
WHERE u.UserName = 'Ilian'
ORDER BY tl.Name ASC

CREATE INDEX idx_UserID_Name
ON TaskLists(UserID, Name ASC)

--All tasks that are not finished, for a single user, in a task list, by username, and task list name.
-- Sorted by (Name ascending) OR (DateCreated, latest first) OR (DateDue, earliest first) OR (Priority, highest rank first). (Task Name, DateDue, Priority)
SELECT t.TaskID, t.Name , t.DateDue, p.Name
FROM Tasks t
INNER JOIN TaskLists tl
ON tl.TaskListID = t.TaskListID
INNER JOIN Users u
ON u.UserID = tl.UserID
INNER JOIN Priorities p
ON p.PrioritiyID = t.PrioritiyID
WHERE t.IsFinished = 0 AND u.UserName = 'Niki' AND tl.Name = 'Count birds'
ORDER BY t.Name ASC 

SELECT t.TaskID, t.Name , t.DateDue, p.Name
FROM Tasks t
INNER JOIN TaskLists tl
ON tl.TaskListID = t.TaskListID
INNER JOIN Users u
ON u.UserID = tl.UserID
INNER JOIN Priorities p
ON p.PrioritiyID = t.PrioritiyID
WHERE t.IsFinished = 0 AND u.UserName = 'Niki' AND tl.Name = 'Count birds'
ORDER BY t.DateCreated DESC 

SELECT t.TaskID, t.Name , t.DateDue, p.Name
FROM Tasks t
INNER JOIN TaskLists tl
ON tl.TaskListID = t.TaskListID
INNER JOIN Users u
ON u.UserID = tl.UserID
INNER JOIN Priorities p
ON p.PrioritiyID = t.PrioritiyID
WHERE t.IsFinished = 0 AND u.UserName = 'Niki' AND tl.Name = 'Count birds'
ORDER BY t.DateDue ASC 

SELECT t.TaskID, t.Name , t.DateDue, p.Name
FROM Tasks t
INNER JOIN TaskLists tl
ON tl.TaskListID = t.TaskListID
INNER JOIN Users u
ON u.UserID = tl.UserID
INNER JOIN Priorities p
ON p.PrioritiyID = t.PrioritiyID
WHERE t.IsFinished = 0 AND u.UserName = 'Niki' AND tl.Name = 'Count birds'
ORDER BY p.Rank DESC 

CREATE INDEX idx_TaskListID_IsFinished_Name
ON Tasks(TaskListID, IsFinished, Name ASC)

CREATE INDEX idx_TaskListID_IsFinished_DateCreated
ON Tasks(TaskListID, IsFinished, DateCreated DESC)

CREATE INDEX idx_TaskListID_IsFinished_DateDue
ON Tasks(TaskListID, IsFinished, DateDue ASC)

--Currently active UserOption for a user, by username (all fiels in UserOptions)
SELECT  dt.Name, dt1.Name , dt2.Name, uo.Name , uo.ItemsPerPage
FROM Users u
INNER JOIN UserOptions uo
ON uo.UserOptionID = u.ActiveUserOptionID
INNER JOIN DisplayTypes dt
ON uo.DetailsDisplayTypeID = dt.DisplayTypeID
INNER JOIN DisplayTypes dt1
ON uo.TaskListDisplayTypeID = dt1.DisplayTypeID
INNER JOIN DisplayTypes dt2
ON uo.TasksDisplayTypeID = dt2.DisplayTypeID
WHERE u.UserName = 'Ilian'

--All user options for a user (primary key, name)

SELECT uo.UserOptionID , uo.Name
FROM UserOptions uo
INNER JOIN Users u
ON u.UserID = uo.UserID
WHERE u.UserName = 'Ilian'

CREATE INDEX idx_UserID_Name_UserOptionID
ON UserOptions(UserID, Name, UserOptionID)

--The 10 tasks that are not finished, with highest priority for a user, by username.
-- Sort them by DateDue, earliest first, and then by Name, ascending. (Task Name, DateDue, Priority)

SELECT TOP 10 t.Name, t.DateDue, p.Name
FROM Tasks t
INNER JOIN TaskLists tl
ON tl.TaskListID = t.TaskListID
INNER JOIN Users u
ON u.UserID = tl.TaskListID
INNER JOIN Priorities p
ON p.PrioritiyID = t.PrioritiyID
WHERE t.IsFinished = 0 AND u.UserName = 'Niki'
ORDER BY p.Rank , t.DateDue, t.Name ASC

CREATE INDEX idx_TaskListID_IsFinished_PrioritiyID_DateDue_Name
ON Tasks(TaskListID, IsFinished, PrioritiyID , DateDue, Name ASC)
