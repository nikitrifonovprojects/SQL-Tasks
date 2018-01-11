
CREATE DATABASE NikiAcademy

USE NikiAcademy

CREATE TABLE Teacher(
TeacherID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
UserName varchar(50) NOT NULL UNIQUE,
Email nvarchar(50) NOT NULL UNIQUE,
Password nvarchar(40) NOT NULL,
DateCreated datetime DEFAULT CURRENT_TIMESTAMP
)


CREATE TABLE Student(
StudentID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
UserName varchar(50) NOT NULL UNIQUE,
Password nvarchar(40) NOT NULL, 
DateCreated datetime DEFAULT CURRENT_TIMESTAMP,
)


CREATE TABLE ExamType(
ExamTypeID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
ExamTypeName nvarchar(30) NOT NULL  -- Make unique
)


CREATE TABLE Course(
CourseID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
CourseName nvarchar(40) NOT NULL UNIQUE,
PassingGrade int NOT NULL,
TeacherID int NOT NULL FOREIGN KEY REFERENCES Teacher(TeacherID)
)


CREATE TABLE Exam(
ExamID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
ExamName nvarchar(40) NOT NULL,
ExamDate datetime NOT NULL,
TeacherID int FOREIGN KEY REFERENCES Teacher(TeacherID),
ExamTypeID int FOREIGN KEY REFERENCES ExamType(ExamTypeID),
CourseID int FOREIGN KEY REFERENCES Course(CourseID)
)

CREATE TABLE Student_Exam(
ExamID int NOT NULL,
StudentID int NOT NULL,
PRIMARY KEY(ExamID, StudentID),
Grade int NULL,
CONSTRAINT chk_Grade CHECK(Grade >= 2 AND Grade <= 6),
FOREIGN KEY(ExamID) REFERENCES Exam(ExamID),
FOREIGN KEY(StudentID) REFERENCES Student(StudentID)
)

CREATE TABLE Student_Course(
CourseID int NOT NULL,
StudentID int NOT NULL,
PRIMARY KEY(CourseID, StudentID),
FOREIGN KEY(CourseID) REFERENCES Course(CourseID),
FOREIGN KEY(StudentID) REFERENCES Student(StudentID)
)



INSERT INTO Teacher(UserName, Email, Password)
VALUES('Pesho', 'pe@abv.bg', '1121411')

INSERT INTO Teacher(UserName, Email, Password)
VALUES('Ivo', 'iv@abv.bg', '1121311')

INSERT INTO Teacher(UserName, Email, Password)
VALUES('Goro', 'go@abv.bg', '1121811')

INSERT INTO Teacher(UserName, Email, Password)
VALUES('Dom', 'do@abv.bg', '11219211')


INSERT INTO Student(UserName, Password)
VALUES('Nik', '111111')

INSERT INTO Student(UserName, Password)
VALUES('Dom', '112111')

INSERT INTO Student(UserName, Password)
VALUES('Eli', '13111')

INSERT INTO Student(UserName, Password)
VALUES('Eva', '11141')


INSERT INTO Course(CourseName, PassingGrade, TeacherID)
VALUES('IT', 5, 1)

INSERT INTO Course(CourseName, PassingGrade, TeacherID)
VALUES('Economics', 6, 2)

INSERT INTO Course(CourseName, PassingGrade, TeacherID)
VALUES('Math', 3 , 3)

INSERT INTO Course(CourseName, PassingGrade, TeacherID)
VALUES('P.E.', 4, 1)


INSERT INTO ExamType(ExamTypeName)
VALUES('Written')

INSERT INTO ExamType(ExamTypeName)
VALUES('Oral')

INSERT INTO ExamType(ExamTypeName)
VALUES('Practical')


INSERT INTO Exam(ExamName, ExamDate , CourseID , ExamTypeID, TeacherID)
VALUES('IT basics', '12-01-16 12:00' , 1, 1, 1)

INSERT INTO Exam(ExamName, ExamDate , CourseID , ExamTypeID, TeacherID)
VALUES('Economics basics', '12-01-18 12:00' , 2, 2, 2)

INSERT INTO Exam(ExamName, ExamDate , CourseID , ExamTypeID, TeacherID)
VALUES('Math basics', '12-01-20 12:00' , 3, 1, 3)

INSERT INTO Exam(ExamName, ExamDate , CourseID , ExamTypeID, TeacherID)
VALUES('P.E. basics', '12-01-20 12:00' , 4, 3, 3)

INSERT INTO Exam(ExamName, ExamDate , CourseID , ExamTypeID, TeacherID)
VALUES('Math advanced', '12-01-20 12:00' , 3, 1, 3)

INSERT INTO Student_Exam(ExamID, StudentID, Grade)
VALUES(5, 1, 4)

INSERT INTO Student_Exam(ExamID, StudentID, Grade)
VALUES(6, 3, 5)

INSERT INTO Student_Exam(ExamID, StudentID, Grade)
VALUES(5, 2, 6)

INSERT INTO Student_Course(CourseID, StudentID)
VALUES(1, 1)

INSERT INTO Student_Course(CourseID, StudentID)
VALUES(2, 3)

INSERT INTO Student_Course(CourseID, StudentID)
VALUES(2, 1)


SELECT e.ExamID, e.ExamName
FROM Exam e
INNER JOIN ExamType et
ON e.ExamTypeID = et.ExamTypeID
WHERE et.ExamTypeName = 'Written'

CREATE INDEX idx_ExamTypeName
ON ExamType(ExamTypeName)

CREATE INDEX idx_ExamTypeID_ExamName
ON Exam(ExamTypeID, ExamName)


SELECT s.StudentID, s.UserName
FROM Student s
INNER JOIN Student_Exam sm
ON s.StudentID = sm.StudentID
INNER JOIN Exam e
ON e.ExamID = sm.ExamID
INNER JOIN Course c
ON c.CourseID = e.CourseID
WHERE e.ExamName = 'IT basics' AND sm.Grade >= c.PassingGrade   

CREATE INDEX idx_ExamName_ExamID_CourseID
ON Exam(ExamName, ExamID, CourseID)


SELECT e.ExamID , e.ExamName
FROM Exam e
WHERE e.ExamDate BETWEEN '2016/01/10' AND '2020/01/14'

CREATE INDEX idx_ExamDate_ExamName_ExamID
ON Exam(ExamDate, ExamName, ExamID)


SELECT c.CourseID, c.CourseName
FROM Course c
INNER JOIN Teacher t
ON t.TeacherID = c.TeacherID
WHERE t.UserName = 'Pesho'

CREATE INDEX idx_UserName
ON Teacher(UserName)

CREATE INDEX idx_TeacherID_CourseName_CourseID
ON Course(TeacherID, CourseID, CourseName)


SELECT t.TeacherID, t.UserName
FROM Teacher t
INNER JOIN Course c
ON t.TeacherID = c.TeacherID
WHERE c.CourseName = 'IT'

CREATE INDEX idx_CourseName_TeacherID
ON Course(CourseName,TeacherID)

SELECT e.ExamID, e.ExamName , st.Grade
FROM Exam e
INNER JOIN Student_Exam st
ON st.ExamID = e.ExamID
INNER JOIN Student s
ON st.StudentID = s.StudentID
WHERE e.ExamName = 'IT basics'


SELECT c.CourseID, c.CourseName
FROM Course c
INNER JOIN Student_Course sc
ON c.CourseID = sc.CourseID
INNER JOIN Student s
ON sc.StudentID = s.StudentID
WHERE s.UserName = 'Nik'

CREATE INDEX idx_UserName
ON Student(UserName)

CREATE INDEX idx_StudentID
ON Student_Course(StudentID)


SELECT s.StudentID , s.UserName
FROM Student s
INNER JOIN Student_Course sc
ON sc.StudentID = s.StudentID
INNER JOIN Course c
ON c.CourseID = sc.CourseID
WHERE c.CourseName = 'IT'

SELECT s.StudentID , s.UserName
FROM Student s
INNER JOIN Student_Exam sm
ON sm.StudentID = s.StudentID
INNER JOIN Exam e
ON e.ExamID = sm.ExamID
INNER JOIN Course c
ON c.CourseID = e.CourseID
WHERE sm.Grade >= c.PassingGrade AND e.ExamName = 'IT basics'

SELECT AVG(se.Grade) AS [Average Grade]
FROM Student_Exam se
INNER JOIN Exam e
ON e.ExamID = se.ExamID
WHERE e.ExamName = 'IT basics'
 