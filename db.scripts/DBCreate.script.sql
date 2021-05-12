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
    FilmImage nvarchar(255)
)
GO

--employee's position
CREATE TABLE dbo.EmployeePosition (
    PositionName nvarchar(30) PRIMARY KEY,
    Responsibilities nvarchar(255) NOT NULL,
    EmployeeRank tinyint NOT NULL, -- 1 - service staff ,2 - common employee, 3 - managment
    Salary int NOT NULL
)
GO

--employees
CREATE TABLE dbo.Employees (
    EmployeeID tinyint PRIMARY KEY IDENTITY(1, 1),
    Position nvarchar(30) FOREIGN KEY REFERENCES EmployeePosition(PositionName),
    EmployeeName nvarchar(50) NOT NULL,
    Passport passportType UNIQUE NOT NULL, -- create user type
    Expirience tinyint
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
    TicketCost tinyint NOT NULL
)
GO

--advertising
CREATE TABLE dbo.Advertising (
    AdID tinyint PRIMARY KEY IDENTITY(1, 1),
    SeanceId tinyint FOREIGN KEY REFERENCES Seances(SeanceId),
    Employee tinyint FOREIGN KEY REFERENCES Employees(EmployeeID),
    Advertiser tinyint FOREIGN KEY REFERENCES Advertisers(AdvertiserID),
    AdvertisingName nvarchar(20) NOT NULL,
    AdvertisingDuration tinyint CHECK (AdvertisingDuration <= 180) NOT NULL,
    AdvertisingCost smallint NOT NULL
)
GO

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
    EmployeeID tinyint FOREIGN KEY REFERENCES Employees(EmployeeID), 
    StaffChangeTime tinyint,
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
    SeatNumber tinyint CHECK(SeatNumber BETWEEN 0 AND 20) NOT NULL,
    Cost smallint NOT NULL
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
CREATE DEFAULT expirience_default AS 0;
GO
EXEC sp_bindefault 'expirience_default', 'Employees.Expirience';
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
    ('Мстители: Война бесконечности', '27.04.2018', 'Братья Руссо', 160, 'Боевик', 8.4, 'avengers.jpg'),
    ('Бешеные псы', '02.09.1992', 'К. Тарантино', 99, 'Криминал', 8.3, 'reservoirdogs.jpg')
GO

--employeePositions
INSERT INTO EmployeePosition VALUES
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
    ('standart', 'билет без скидок', 0),
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
    (1, 10, 20),
    (0, 10, 15),
    (1, 10, 15),
    (0, 10, 15)
GO

--employeeHoll
INSERT INTO EmployeeHoll VALUES 
    (1, 7, 5),
    (2, 7, 5),
    (3, 7, 5),
    (4, 7, 5)
GO

--seances
INSERT INTO Seances VALUES
    (1, 1, '15.05.2021 12:30', 16, 'common', 200),
    (1, 2, '15.05.2021 13:30', 16, 'common', 200),
    (1, 3, '15.05.2021 14:30', 16, 'common', 200),
    (1, 4, '15.05.2021 15:30', 16, 'common', 200),
    (5, 1, '16.05.2021 10:45', 6, 'common', 200),
    (5, 2, '16.05.2021 12:45', 6, 'common', 200),
    (5, 3, '16.05.2021 15:45', 6, 'common', 200),
    (5, 4, '16.05.2021 16:45', 6, 'common', 200),
    (6, 1, '15.05.2021 18:30', 18, 'limited', 200),
    (6, 2, '15.05.2021 18:30', 18, 'limited', 200),
    (6, 2, '15.05.2021 22:30', 18, 'limited', 200),
    (6, 4, '15.05.2021 21:30', 18, 'limited', 200),
    (7, 1, '17.05.2021 11:15', 6, 'school', 200),
    (7, 2, '17.05.2021 11:15', 6, 'school', 200),
    (7, 3, '17.05.2021 11:15', 6, 'school', 200),
    (7, 4, '17.05.2021 11:15', 6, 'school', 200),
    (10, 1, '17.05.2021 20:30', 18, 'common', 200),
    (10, 2, '17.05.2021 21:45', 18, 'common', 200),
    (10, 3, '17.05.2021 22:30', 18, 'common', 200),
    (10, 4, '17.05.2021 18:15', 18, 'common', 200),
    (2, 1, '16.05.2021 21:30', 16, 'limited', 200),
    (9, 4, '16.05.2021 21:30', 16, 'common', 200)
GO

--advertisers
INSERT INTO Advertisers VALUES
    ('С. Есенин', 'РГУ'),
    ('А. Попов', 'РГРТУ') --resurrected
GO

--advertisings
INSERT INTO Advertising VALUES
    (1, 3, 2, 'radio', 100, 10000),
    (5, 3, 2, 'radio', 100, 10000),
    (10, 3, 1, 'tourism', 120, 15000),
    (2, 3, 1, 'tourism', 120, 15000)
GO