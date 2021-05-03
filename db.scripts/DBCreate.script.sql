--creating db
USE master
CREATE DATABASE CinemaDB
    ON  PRIMARY ( 
        NAME = N'Cinema', 
        FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\Cinema.mdf' , 
        SIZE = 8192KB , 
        FILEGROWTH = 65536KB 
    )
    LOG ON ( 
        NAME = N'Cinema_log', 
        FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\Cinema_log.ldf' ,
        SIZE = 8192KB , 
        FILEGROWTH = 65536KB 
    )
GO

--switch to CinemaDB
USE CinemaDB
GO

--user-defined data types
CREATE TYPE passportType
    FROM nvarchar(10) NOT NULL

--starting creating tables

----general table count - 12
----check count - 3
----default count - 5


--collection of films
CREATE TABLE dbo.Films (
    FilmID tinyint PRIMARY KEY, -- max 50 films at one time
    FilmName nvarchar(30),
    ReleaseYear smallint,
    Director nvarchar(50),
    Duration smallint,
    Budget int,
    Rating tinyint CHECK (Rating > 5)
)
GO

--employee's position
CREATE TABLE dbo.EmployeePosition (
    PositionName nvarchar(20) PRIMARY KEY,
    Responsibilities nvarchar(100),
    EmployeeRank tinyint, -- 1 - service staff ,2 - common employee, 3 - managment
    Salary int
)
GO

--employees
CREATE TABLE dbo.Employees (
    EmployeeID tinyint PRIMARY KEY,
    Position nvarchar(20) FOREIGN KEY REFERENCES EmployeePosition(PositionName),
    EmployeeName nvarchar(50),
    Passport passportType UNIQUE, -- create user type
    Expirience tinyint DEFAULT 0
)
GO

--advertising
CREATE TABLE dbo.Advertising (
    AdID tinyint PRIMARY KEY,
    SeanceId tinyint FOREIGN KEY REFERENCES Seances(SeanceId),
    Employee tinyint FOREIGN KEY REFERENCES Employees(EmployeeID),
    Advertiser tinyint FOREIGN KEY REFERENCES Advertisers(AdvertiserID),
    AdvertisingName nvarchar(20),
    AdvertisingDuration tinyint CHECK (AdvertisingDuration >= 60),
    AdvertisingCost smallint CHECK (AdvertisingCost >= 5000)
)
GO

--advertisers
CREATE TABLE dbo.Advertisers (
    AdvertiserID tinyint PRIMARY KEY,
    AdvertiserName nvarchar(50),
    CompanyName nvarchar(50)
)
GO

--cinemaholl
CREATE TABLE dbo.CinemaHolls (
    HollID tinyint PRIMARY KEY,
    TdEnable bit DEFAULT 0,
    Seats tinyint
)
GO

--EmployeeHoll
CREATE TABLE dbo.EmployeeHoll (
    HollID tinyint FOREIGN KEY REFERENCES CinemaHolls(HollID),
    EmployeeID tinyint FOREIGN KEY REFERENCES Employees(EmployeeID),
    StaffChangeTime tinyint DEFAULT 5
)
GO

--ticket type
CREATE TABLE dbo.TicketTypes (
    TypeName nvarchar(20) PRIMARY KEY,
    TypeDescription nvarchar(100),
    Discount tinyint
)
GO

--ticket
CREATE TABLE dbo.Ticket (
    TicketID smallint PRIMARY KEY,
    TicketType nvarchar(20) FOREIGN KEY REFERENCES TicketTypes(TypeName),
    CashboxID tinyint FOREIGN KEY REFERENCES Cashboxes(CashboxID),
    SeanceId tinyint FOREIGN KEY REFERENCES Seances(SeanceId),
    RowNumber tinyint,
    SeatNumber tinyint,
    Cost smallint
)
GO

--cashbox
CREATE TABLE dbo.Cashboxes (
    CashboxID tinyint PRIMARY KEY,
    EmployeeID tinyint FOREIGN KEY REFERENCES Employees(EmployeeID), 
    StaffChangeTime tinyint DEFAULT 5,
    WorkTime tinyint DEFAULT 12
)
GO

--seance
CREATE TABLE dbo.Seances (
    SeanceId tinyint PRIMARY KEY,
    FilmID tinyint FOREIGN KEY REFERENCES Films(FilmID),
    HollID tinyint FOREIGN KEY REFERENCES CinemaHolls(HollID),
    ShowTime datetime,
    AgeRating tinyint,
    SeanceType nvarchar(20) FOREIGN KEY REFERENCES SeanceTypes(TypeName)
)
GO

--seance types
CREATE TABLE dbo.SeanceTypes (
    TypeName nvarchar(20) PRIMARY KEY,
    TypeDescription nvarchar(100)
)
GO