--creating db
USE master
CREATE DATABASE CinemaDB
    ON  PRIMARY ( 
        NAME = N'Cinema', 
        FILENAME = N'D:\CinemaDB\Cinema.mdf' , 
        SIZE = 8192KB , 
        FILEGROWTH = 65536KB 
    )
    LOG ON ( 
        NAME = N'Cinema_log', 
        FILENAME = N'D:\CinemaDB\Cinema_log.ldf' ,
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
GO
CREATE RULE passport_rule AS (len(@passport) = 10);
GO
EXEC sp_bindrule 'passport_rule', 'passportType';
GO

CREATE TYPE phoneType
    FROM nvarchar(10) NOT NULL
GO
CREATE TYPE imagePath
    FROM nvarchar(255) NOT NULL
GO
--starting creating tables

----general table count - 12
----check count - 3
----default count - 6


--collection of films
CREATE TABLE dbo.Films (
    FilmID tinyint PRIMARY KEY IDENTITY(1, 1), -- max 50 films at one time
    FilmName nvarchar(30) NOT NULL,
    ReleaseYear datetime NOT NULL,
    Director nvarchar(50) NOT NULL,
    Duration smallint,
    Genre nvarchar(20),
    Rating float,
    FilmImage imagePath
)
GO

--employee's position
CREATE TABLE dbo.EmployeePosition (
    PositionName nvarchar(30) PRIMARY KEY,
    Responsibilities nvarchar(255) NOT NULL,
    EmployeeRank tinyint NOT NULL, -- 1 - service staff ,2 - common employee, 3 - managment
    Salary money NOT NULL
)
GO

--employees
CREATE TABLE dbo.Employees (
    EmployeeID tinyint PRIMARY KEY IDENTITY(1, 1),
    Position nvarchar(30) FOREIGN KEY REFERENCES EmployeePosition(PositionName),
    EmployeeName nvarchar(50) NOT NULL,
    Passport passportType UNIQUE NOT NULL, -- create user type
    Experience tinyint,
    Phone phoneType
)
GO

--advertisers
CREATE TABLE dbo.Advertisers (
    AdvertiserID tinyint PRIMARY KEY IDENTITY(1, 1),
    AdvertiserName nvarchar(50) NOT NULL,
    CompanyName nvarchar(50) NOT NULL,
    AdvertiserPhone phoneType
)
GO

--cinemaholl
CREATE TABLE dbo.CinemaHolls (
    HollID tinyint PRIMARY KEY IDENTITY(1, 1),
    TdEnable bit DEFAULT 0,
    RowNumber tinyint NOT NULL,
    SeatNumber tinyint NOT NULL--max(10x20) - avr(10x15)
)
GO

--seance types
CREATE TABLE dbo.SeanceTypes (
    TypeName nvarchar(20) PRIMARY KEY,
    TypeDescription nvarchar(100) NOT NULL
)
GO

--seance
CREATE TABLE dbo.Seances (
    SeanceId tinyint PRIMARY KEY IDENTITY(1, 1),
    FilmID tinyint FOREIGN KEY REFERENCES Films(FilmID),
    HollID tinyint FOREIGN KEY REFERENCES CinemaHolls(HollID),
    ShowTime datetime NOT NULL, -- starting
    AgeRating tinyint,
    SeanceType nvarchar(20) FOREIGN KEY REFERENCES SeanceTypes(TypeName), 
    TicketCost money NOT NULL
)
GO

--advertising
CREATE TABLE dbo.Advertising (
    AdID tinyint PRIMARY KEY IDENTITY(1, 1),
    Employee tinyint FOREIGN KEY REFERENCES Employees(EmployeeID),
    Advertiser tinyint FOREIGN KEY REFERENCES Advertisers(AdvertiserID),
    AdvertisingName nvarchar(20) NOT NULL,
    AdvertisingDuration tinyint CHECK (AdvertisingDuration <= 180) NOT NULL,
    AdvertisingCost money NOT NULL
)
GO

CREATE TABLE dbo.AdvertisingSeance (
    SeanceId tinyint FOREIGN KEY REFERENCES Seances(SeanceId),
    AdID tinyint FOREIGN KEY REFERENCES Advertising(AdID)
)
--EmployeeHoll
CREATE TABLE dbo.EmployeeHoll (
    HollID tinyint FOREIGN KEY REFERENCES CinemaHolls(HollID),
    EmployeeID tinyint FOREIGN KEY REFERENCES Employees(EmployeeID),
    StaffChangeTime tinyint
)
GO

--ticket type
CREATE TABLE dbo.TicketTypes (
    TypeName nvarchar(20) PRIMARY KEY,
    TypeDescription nvarchar(100) NOT NULL,
    Discount tinyint DEFAULT 0
)
GO

--cashbox
CREATE TABLE dbo.Cashboxes (
    CashboxID tinyint PRIMARY KEY IDENTITY(0, 1),
    StaffChangeTime tinyint,
    WorkTime tinyint DEFAULT 12
)
GO

CREATE TABLE dbo.EmployeeCashbox (
    EmployeeID tinyint FOREIGN KEY REFERENCES Employees(EmployeeID), 
    CashboxID tinyint FOREIGN KEY REFERENCES Cashboxes(CashboxID),
)

--ticket
CREATE TABLE dbo.Tickets (
    TicketID smallint PRIMARY KEY IDENTITY(1, 1),
    TicketType nvarchar(20) FOREIGN KEY REFERENCES TicketTypes(TypeName),
    CashboxID tinyint FOREIGN KEY REFERENCES Cashboxes(CashboxID),
    SeanceId tinyint FOREIGN KEY REFERENCES Seances(SeanceId),
    RowNumber tinyint NOT NULL, --constraints!
    SeatNumber tinyint CHECK(SeatNumber BETWEEN 0 AND 20) NOT NULL,
    Cost money NOT NULL
)
GO

--constraints
-- rules
CREATE RULE rating_check AS (@rating BETWEEN 0 AND 10);
GO
EXEC sp_bindrule 'rating_check', 'Films.Rating';
GO

CREATE RULE ad_cost_check AS (@cost >= 5000);
GO
EXEC sp_bindrule 'ad_cost_check', 'Advertising.AdvertisingCost';
GO

CREATE RULE row_check AS (@row BETWEEN 0 AND 10);
GO
EXEC sp_bindrule 'row_check', 'Tickets.RowNumber';
GO

-- default
CREATE DEFAULT experience_default AS 0;
GO
EXEC sp_bindefault 'experience_default', 'Employees.Experience';
GO

CREATE DEFAULT staff_time_default AS 5;
GO
EXEC sp_bindefault 'staff_time_default', 'EmployeeHoll.StaffChangeTime';
EXEC sp_bindefault 'staff_time_default', 'Cashboxes.StaffChangeTime';
GO

CREATE DEFAULT image_default AS 'default.jpg';
GO
EXEC sp_bindefault 'image_default', 'Films.FilmImage';
GO

