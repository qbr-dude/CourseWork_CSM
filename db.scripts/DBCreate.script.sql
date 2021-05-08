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
GO
CREATE RULE passport_rule AS (len(@passport) = 10)
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
    FilmImage nvarchar(255) DEFAULT '../default.jpg'
)
GO

--employee's position
CREATE TABLE dbo.EmployeePosition (
    PositionName nvarchar(20) PRIMARY KEY,
    Responsibilities nvarchar(100) NOT NULL,
    EmployeeRank tinyint NOT NULL, -- 1 - service staff ,2 - common employee, 3 - managment
    Salary int NOT NULL
)
GO

--employees
CREATE TABLE dbo.Employees (
    EmployeeID tinyint PRIMARY KEY IDENTITY(1, 1),
    Position nvarchar(20) FOREIGN KEY REFERENCES EmployeePosition(PositionName),
    EmployeeName nvarchar(50) NOT NULL,
    Passport passportType UNIQUE NOT NULL, -- create user type
    Expirience tinyint DEFAULT 0
)
GO

--advertisers
CREATE TABLE dbo.Advertisers (
    AdvertiserID tinyint PRIMARY KEY IDENTITY(1, 1),
    AdvertiserName nvarchar(50) NOT NULL,
    CompanyName nvarchar(50) NOT NULL
)
GO

--cinemaholl
CREATE TABLE dbo.CinemaHolls (
    HollID tinyint PRIMARY KEY IDENTITY(1, 1),
    TdEnable bit DEFAULT 0,
    Seats tinyint NOT NULL --max(10x20) - avr(10x15)
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
    SeanceType nvarchar(20) FOREIGN KEY REFERENCES SeanceTypes(TypeName)
)
GO

--advertising
CREATE TABLE dbo.Advertising (
    AdID tinyint PRIMARY KEY IDENTITY(1, 1),
    SeanceId tinyint FOREIGN KEY REFERENCES Seances(SeanceId),
    Employee tinyint FOREIGN KEY REFERENCES Employees(EmployeeID),
    Advertiser tinyint FOREIGN KEY REFERENCES Advertisers(AdvertiserID),
    AdvertisingName nvarchar(20) NOT NULL,
    AdvertisingDuration tinyint CHECK (AdvertisingDuration >= 60) NOT NULL,
    AdvertisingCost smallint CHECK (AdvertisingCost >= 5000) NOT NULL
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
    TypeDescription nvarchar(100) NOT NULL,
    Discount tinyint DEFAULT 0
)
GO

--cashbox
CREATE TABLE dbo.Cashboxes (
    CashboxID tinyint PRIMARY KEY IDENTITY(0, 1),
    EmployeeID tinyint FOREIGN KEY REFERENCES Employees(EmployeeID), 
    StaffChangeTime tinyint DEFAULT 5,
    WorkTime tinyint DEFAULT 12
)
GO

--ticket
CREATE TABLE dbo.Tickets (
    TicketID smallint PRIMARY KEY IDENTITY(1, 1),
    TicketType nvarchar(20) FOREIGN KEY REFERENCES TicketTypes(TypeName),
    CashboxID tinyint FOREIGN KEY REFERENCES Cashboxes(CashboxID),
    SeanceId tinyint FOREIGN KEY REFERENCES Seances(SeanceId),
    RowNumber tinyint NOT NULL, --constraints!
    SeatNumber tinyint NOT NULL,
    Cost smallint NOT NULL
)
GO

--constraints


-- filling in start tables

--films
INSERT INTO Films VALUES
    ('Начало', '22.07.2010', 'К. Нолан', 162, 'Боевик', 8.8, 'inception.jpg'),
    ('Побег из Шоушенка', '14.10.1994', 'Ф. Доборант', 144, 'Драма', 9.3, 'shawshank.jpg'),
    ('Интерстеллар', '07.11.2014', 'К. Нолан', 169, 'Приключение', 8.6, 'interstellar.jpg'),
    ('Матрица', '31.03.1999', 'Братья Вачовски', 136, 'Боевик', 8.7, 'matrix.jpg'),
    ('Король лев', '24.06.1994', 'Р. Аллерс', 88, 'Анимационный', 8.5, 'lionking.jpg'), 
    ('Чужой', '22.06.1979', 'Р. Скотт', 117, 'Ужасы', 8.4, 'alien.jpg'),
    ('Валл-и', '27.06.2008', 'А. Стэнтон', 98, 'Анимационный', 8.4, 'walle.jpg'),
    ('Джокер', '04.10.2019', 'Т. Филлипс', 122, 'Драма', 8.4, 'joker.jpg'),
    ('Мстители: Война бесконечности', '27.04.2018', 'Братья Руссо', 8.4, 'Боевик', 13, 'avengers.jpg'),
    ('Бешеные псы', '02.09.1992', 'К. Тарантино', 99, 'Криминал', 8.3, 'reservoirdogs.jpg')
GO

--employeePositions
INSERT INTO EmployeePositions VALUES
    ('Администратор', 'Управляет кинотеатром. Нанимает персонал, ведет бухгалтерскую работу', 3, 120000),
    ('Менеджер по прокату', 'Управляет прокатом кинотеатра', 3, 80000),
    ('Менеджер по маркетингу', 'Управляет рекламой, продвижением кинотеатра. Работает с рекламодателями', 3, 90000),
    ('Киномеханик', 'Работает с кинолентами и аппаратурой', 2, 50000),
    ('Кассир', 'Работает на кассе или у зала', 1, 35000),
    ('Уборщик', 'Занимается уборкой', 1, 20000)
GO

--epmloyees
INSERT INTO Employees VALUES
    ('Администратор', 'Д. Кулаков', '1234456789', 20),
    ('Менеджер по прокату', 'В. Пупкин', '8888777722', 10),
    ('Менеджер по маркетингу', 'К. Пупкина', '1112223334', 12),
    ('Киномеханик', 'А. Антонов', '9865321245', 50),
    ('Кассир', 'А. Лопаткова', '6543216545', 5),
    ('Кассир', 'М. Носов', '9876543211', 1),
    ('Кассир', 'Е. Гуров', '9876555555', 3),
    ('Уборщик', 'А. Мешкарева', '6665556665', 10),
    ('Уборщик', 'А. Мешкарев', '6665556666', 7)
GO

--ticketTypes
INSERT INTO TicketTypes VALUES
    ('standart', 'билет без скидок'),
    ('child', 'детям до 6 включительно', 50),
    ('tuesday', 'акция на вечерние фильмы', 50)

--cashboxes
INSERT INTO Cashboxes VALUES
    (5, 0, 24),
    (5, 5, 12),
    (6, 5, 5)
GO

--seanceTypes
INSERT INTO SeanceTypes VALUES
    ('common', 'Обычный сеанс'),
    ('school', 'Групповой паказ для школьников'),
    ('limited', 'Показ старых или ограниченных в прокате фильмов')
GO

--cinemaHolls
INSERT INTO CinemaHolls VALUES
    (1, 200),
    (0, 150),
    (1, 150),
    (0, 150)
GO

--employeeHoll
INSERT INTO EmployeeHoll VALUES 
    (1, 7),
    (2, 7),
    (3, 7),
    (4, 7)
GO

--advertisings