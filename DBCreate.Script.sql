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

--starting creating tables

----general table count - 12
----check count - 3
----default count - 5


--collection of films
CREATE TABLE dbo.Films (
    FilmID tinyint(50) PRIMARY KEY, -- max 50 films at one time
    FilmName nvarchar(30),
    ReleaseYear smallint,
    Director nvarchar(50),
    Duration smallint,
    Budget int,
    Rating tinyint(10) CHECK (Rating > 5)
)
GO

--employee's position
CREATE TABLE dbo.EmployeePosition (
    PositionName nvarchar(20) PRIMARY KEY,
    Responsibilities nvarchar(100),
    Rank tinyint(3), -- 1 - service staff ,2 - common employee, 3 - managment
    Salary int
)
GO

--employees
CREATE TABLE dbo.Employees (
    EmployeeID tinyint(255) PRIMARY KEY,
    Position nvarchar(20) FOREIGN KEY REFERENCES EmployeePosition(PositionName),
    EmployeeName nvarchar(50),
    Passport /**/ UNIQUE,
    Expirience tinyint(64) DEFAULT 0
)
GO

--advertising
CREATE TABLE dbo.Advertising (
    AdID tinyint(20) PRIMARY KEY,
    SeanceId tinyint(200) FOREIGN KEY REFERENCES Seances(SeanceId),
    Employee tinyint(255) FOREIGN KEY REFERENCES Employees(EmployeeID),
    Advertiser tinyint FOREIGN KEY REFERENCES Advertisers(AdvertiserID),
    AdvertisingName nvarchar(20),
    AdvertisingDuration tinyint(240) CHECK (AdvertisingDuration >= 60),
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
    HollID tinyint(10) PRIMARY KEY,
    3DEnable bit DEFAULT 0,
    Seats tinyint(250)
)
GO

--EmployeeHoll
CREATE TABLE dbo.EmployeeHoll (
    HollID tinyint(10) FOREIGN KEY REFERENCES CinemaHolls(HollID),
    EmployeeID tinyint(255) FOREIGN KEY REFERENCES Employees(EmployeeID),
    StaffChangeTime tinyint(24) DEFAULT 5
)
GO

--ticket type
CREATE TABLE dbo.TicketTypes (
    TypeName nvarchar(20) PRIMARY KEY,
    TypeDescription nvarchar(100),
    Discount tinyint(100)
)
GO

--ticket
CREATE TABLE dbo.Ticket (
    TicketID smallint PRIMARY KEY,
    TicketType nvarchar(20) FOREIGN KEY REFERENCES TicketTypes(TypeName),
    CashboxID tinyint(4) FOREIGN KEY REFERENCES Cashboxes(CashboxID),
    SeanceId tinyint(200) FOREIGN KEY REFERENCES Seances(SeanceId),
    RowNumber tinyint(10),
    SeatNumber tinyint(15),
    Cost smallint(1000)
)
GO

--cashbox
CREATE TABLE dbo.Cashboxes (
    CashboxID tinyint(4) PRIMARY KEY,
    EmployeeID tinyint(255) FOREIGN KEY REFERENCES Employees(EmployeeID), 
    StaffChangeTime tinyint(24) DEFAULT 5,
    WorkTime tinyint(24) DEFAULT 12
)
GO

--seance
CREATE TABLE dbo.Seances (
    SeanceId tinyint(200) PRIMARY KEY,
    FilmID tinyint(50) FOREIGN KEY REFERENCES Films(FilmID),
    HollID tinyint(10) FOREIGN KEY REFERENCES CinemaHolls(HollID),
    ShowTime datetime,
    AgeRating tinyint(18),
    SeanceType nvarchar(20) FOREIGN KEY REFERENCES SeanceTypes(TypeName)
)
GO

--seance types
CREATE TABLE dbo.SeanceTypes (
    TypeName nvarchar(20) PRIMARY KEY,
    TypeDescription nvarchar(100)
)
GO