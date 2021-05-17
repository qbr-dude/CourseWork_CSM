USE CinemaDB
GO

-- insert procedures
-- films
 CREATE PROCEDURE InsertFilm (@FilmName nvarchar(30), @ReleaseYear datetime, @Director nvarchar(50), @Duration smallint, @Genre nvarchar(20), @Rating tinyint, @image nvarchar(255))
    AS
 BEGIN
    IF EXISTS(SELECT FilmName, ReleaseYear, Director
                FROM Films
                    WHERE FilmName = @FilmName and ReleaseYear = @ReleaseYear and Director = @Director)
    BEGIN
        PRINT 'Such a film is already in the collection!';
        RETURN -1;
    END
    INSERT INTO Films 
        VALUES(@FilmName, @ReleaseYear, @Director, @Duration, @Genre, @Rating, @image);
    RETURN 0
 END
GO

--  seances
CREATE PROCEDURE InsertSeance (@FilmID tinyint, @HollID tinyint, @ShowTime datetime, @AgeRating tinyint, @SeanceType nvarchar(20), @TicketCost tinyint)
    AS
BEGIN
    IF NOT EXISTS (SELECT FilmID FROM Films WHERE FilmID = @FilmID)
    BEGIN
        PRINT 'No such film!'
        RETURN -2
    END
    IF NOT EXISTS (SELECT HollID FROM CinemaHolls WHERE HollID = @HollID)
    BEGIN
        PRINT 'No such holl!'
        RETURN -2
    END

    IF EXISTS (SELECT FilmID, HollID, ShowTime
                FROM Seances
                    WHERE FilmID = @FilmID AND HollID = @HollID AND ShowTime = @ShowTime)
    BEGIN
        PRINT 'Such seance is already rolling!';
        RETURN -1;
    END

    INSERT INTO Seances 
        VALUES(@FilmID, @HollID, @ShowTime, @AgeRating, @SeanceType, @TicketCost);
    RETURN 0
END
GO

--  employees
 CREATE PROCEDURE InsertEmployee (@Position nvarchar(20), @EmployeeName nvarchar(50), @Passport passportType, @Expirience tinyint, @Phone phoneType)
    AS
 BEGIN
    IF NOT EXISTS(SELECT PositionName FROM EmployeePosition WHERE PositionName = @Position)
    BEGIN
        PRINT 'No such position!'
        RETURN -2
    END
    IF EXISTS(SELECT Passport
                FROM Employees
                    WHERE Passport = @Passport)
    BEGIN
        PRINT 'The employee already exists in the database!';
        RETURN -1;
    END
    INSERT INTO Employees (Position, EmployeeName, Passport, Experience, Phone)
        VALUES(@Position, @EmployeeName, @Passport, @Expirience, @Phone);
    RETURN 0
 END
 GO
--  exec InsertEmployee 'Кассир', 'Martin', '1234567890', 0

--  advertisers
 CREATE PROCEDURE InsertAdvertiser (@AdvertiserName nvarchar(50), @CompanyName nvarchar(50), @Phone phoneType)
    AS
 BEGIN
    IF EXISTS(SELECT AdvertiserName, CompanyName, AdvertiserPhone
                FROM Advertisers
                    WHERE AdvertiserName = @AdvertiserName and CompanyName = @CompanyName and AdvertiserPhone = @Phone)
    BEGIN
        PRINT 'This advertiser is already buying services from us!';
        RETURN -1;
    END

    INSERT INTO Advertisers
        VALUES(@AdvertiserName, @CompanyName, @Phone);
    RETURN 0
 END
 GO
--  exec InsertAdvertiser 'Р. Кирилин', 'ПоЛИтех'
--  advertising
 CREATE PROCEDURE InsertAdvertising (@Employee tinyint, @Advertiser tinyint, @AdvertisingName nvarchar(20), @AdvertisingDuration tinyint, @AdvertisingCost smallint)
    AS
 BEGIN
    IF NOT EXISTS(SELECT EmployeeID, EmployeeRank FROM Employees INNER JOIN EmployeePosition ON Employees.Position = EmployeePosition.PositionName WHERE EmployeeID = @Employee AND EmployeeRank = 3)
    BEGIN
        PRINT 'No such employee or his rank is not suitable!'
        RETURN -2
    END
    IF NOT EXISTS(SELECT AdvertiserID FROM Advertisers WHERE AdvertiserID = @Advertiser)
    BEGIN
        PRINT 'Unknown advertiser!'
        RETURN -2
    END
    IF EXISTS(SELECT Advertiser, AdvertisingName
                FROM Advertising
                    WHERE Advertiser = @Advertiser and AdvertisingName = @AdvertisingName)
    BEGIN
        PRINT 'Such advertising is already rolling!';
        RETURN -1;
    END

    INSERT INTO Advertising
        VALUES(@Employee, @Advertiser, @AdvertisingName, @AdvertisingDuration, @AdvertisingCost);
    RETURN 0
 END
 GO
--  exec InsertAdvertising 6, 3, 3, 'some', 200, 4000
--  ticket
CREATE PROCEDURE CreateTicket (@SeanceId tinyint, @TypeName nvarchar(20), @CashboxID tinyint, @RowNumber tinyint, @SeatNumber tinyint, @Cost smallint)
   AS
BEGIN
   IF NOT EXISTS(SELECT SeanceId FROM Seances WHERE SeanceId = @SeanceId)
   BEGIN
       PRINT 'No such seance!'
       RETURN -2
   END
   IF NOT EXISTS(SELECT TypeName FROM TicketTypes WHERE TypeName = @TypeName)
   BEGIN
       PRINT 'No such ticket type!'
       RETURN -2
   END
   IF NOT EXISTS(SELECT CashboxID FROM Cashboxes WHERE CashboxID = @CashboxID)
    BEGIN
       PRINT 'No such cashbox!'
       RETURN -2
   END

   IF EXISTS(SELECT SeanceId, RowNumber, SeatNumber
               FROM Tickets
                   WHERE SeanceId = @SeanceId and RowNumber = @RowNumber and SeatNumber = @SeatNumber)
   BEGIN
       PRINT 'This seat is already taken!';
       RETURN -1;
   END

   INSERT INTO Tickets
       VALUES(@TypeName, @CashboxID, @SeanceId, @RowNumber, @SeatNumber, @Cost);
   RETURN 0
END
GO
-- exec CreateTicket 1, 'standart', 0, 9, 15, 200
--  IF NOT EXISTS(SELECT  FROM  WHERE  = @)
--     BEGIN
--         PRINT '!'
--         RETURN -2
--     END

CREATE PROCEDURE GetAllFilms
   AS
BEGIN
   SELECT* FROM Films
END
GO

CREATE PROCEDURE GetTicketsForSeance (@seance tinyint)
   AS
BEGIN
   SELECT* FROM Tickets WHERE SeanceID = @seance
END
GO

CREATE PROCEDURE GetSeanceInfo (@seance tinyint)
    AS
 BEGIN
    SELECT* FROM Seances WHERE SeanceID = @seance
 END
GO

CREATE PROCEDURE GetFilmById (@film tinyint)
   AS
BEGIN
   SELECT* FROM Films WHERE FilmID = @film
END
GO
-- select* from Tickets
-- insert into Tickets values('standart', 0, 1, 5, 6, 200)

CREATE PROCEDURE GetHollInfoBySeance (@seance tinyint)
	AS
BEGIN
	SELECT CinemaHolls.HollID, TdEnable, RowNumber, SeatNumber
		FROM CinemaHolls INNER JOIN Seances ON CinemaHolls.HollID = Seances.HollID
			WHERE Seances.SeanceId = @seance
END
GO