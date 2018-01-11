CREATE DATABASE NikiCalendar

USE NikiCalendar

CREATE TABLE Years(
YearID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name varchar(30) NOT NULL,
Number int NOT NULL
)

CREATE TABLE Months(
MonthID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name varchar(30) NOT NULL,
Number int NOT NULL,
YearID int FOREIGN KEY REFERENCES Years(YearID),
CONSTRAINT chk_Month CHECK(Number <= 12)
)

CREATE TABLE Days(
DayID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name varchar(30) NOT NULL,
Number int NOT NULL,
MonthID int NOT NULL FOREIGN KEY REFERENCES Months(MonthID),
CONSTRAINT chk_Day CHECK(Number <= 31)
)

CREATE TABLE Hours(
HourID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name varchar(30) NOT NULL,
Number int NOT NULL,
DayID int NOT NULL FOREIGN KEY REFERENCES Days(DayID),
CONSTRAINT chk_Hour CHECK(Number <= 24)
)

CREATE TABLE Minutes(
MinuteID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name varchar(30) NOT NULL,
Number int NOT NULL,
HourID int NOT NULL FOREIGN KEY REFERENCES Hours(HourID),
CONSTRAINT chk_Minute CHECK(Number <= 60)
)

CREATE TABLE Seconds(
SecondID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
Name varchar(30) NOT NULL,
Number int NOT NULL,
MinuteID int NOT NULL FOREIGN KEY REFERENCES Minutes(MinuteID),
CONSTRAINT chk_Second CHECK(Number <= 60)
)

SELECT s.SecondID
FROM Seconds s
INNER JOIN Minutes m
ON s.MinuteID = m.MinuteID
INNER JOIN Hours h
ON m.HourID = h.HourID
INNER JOIN Days d
ON h.DayID = d.DayID
INNER JOIN Months mon
ON d.MonthID = mon.MonthID
INNER JOIN Years y
ON mon.YearID = y.YearID
WHERE y.Number = 2019 AND s.Number = 3 AND m.Number = 1 AND h.Number = 1 AND d.Number = 1 AND mon.Number = 1
