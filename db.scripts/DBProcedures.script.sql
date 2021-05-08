USE CinemaDB
GO

--insert procedures
-- films
-- CREATE PROCEDURE InsertFilm (@FilmName nvarchar(30), @ReleaseYear datetime, @Director nvarchar(50), @Duration smallint, @Genre nvarchar(20), @Rating tinyint, @image nvarchar(255))
--     AS
-- BEGIN
--     IF EXISTS(SELECT FilmName, ReleaseYear, Director
--                 FROM Films
--                     WHERE FilmName = @FilmName and ReleaseYear = @ReleaseYear and Director = @Director)
--     BEGIN
--         PRINT 'Such a film is already in the collection!';
--         RETURN -1;
--     END
--     INSERT INTO Films 
--         VALUES(@FilmName, @ReleaseYear, @Director, @Duration, @Genre, @Rating, @image);
--     RETURN 0
-- END

-- employees
-- CREATE PROCEDURE InsertEmployee (@Position nvarchar(20), @EmployeeName nvarchar(50), @Passport passportType, @Expirience tinyint)
--     AS
-- BEGIN
--     IF NOT EXISTS(SELECT PositionName FROM EmployeePosition WHERE PositionName = @Position)
--     BEGIN
--         PRINT 'No such position!'
--         RETURN -2
--     END
--     IF EXISTS(SELECT Passport
--                 FROM Employees
--                     WHERE Passport = @Passport)
--     BEGIN
--         PRINT 'The employee already exists in the database!';
--         RETURN -1;
--     END
--     INSERT INTO Employees (Position, EmployeeName, Passport, Expirience)
--         VALUES(@Position, @EmployeeName, @Passport, @Expirience);
--     RETURN 0
-- END
-- exec InsertEmployee 'Кассир', 'Martin', '1234567890', 0

-- advertisers
-- CREATE PROCEDURE InsertAdvertiser (@AdvertiserName nvarchar(50), @CompanyName nvarchar(50))
--     AS
-- BEGIN
--     IF EXISTS(SELECT AdvertiserName, CompanyName
--                 FROM Advertisers
--                     WHERE AdvertiserName = @AdvertiserName and CompanyName = @CompanyName)
--     BEGIN
--         PRINT 'This advertiser is already buying services from us!';
--         RETURN -1;
--     END

--     INSERT INTO Advertisers
--         VALUES(@AdvertiserName, @CompanyName);
--     RETURN 0
-- END
-- exec InsertAdvertiser 'Р. Кирилин', 'ПоЛИтех'
-- advertising
-- CREATE PROCEDURE InsertAdvertising (@SeanceId tinyint, @Employee tinyint, @Advertiser tinyint, @AdvertisingName nvarchar(20), @AdvertisingDuration tinyint, @AdvertisingCost smallint)
--     AS
-- BEGIN
--     IF NOT EXISTS(SELECT SeanceId FROM Seances WHERE SeanceId = @SeanceId)
--     BEGIN
--         PRINT 'No such seance!'
--         RETURN -2
--     END
--     IF NOT EXISTS(SELECT EmployeeID, EmployeeRank FROM Employees INNER JOIN EmployeePosition ON Employees.Position = EmployeePosition.PositionName WHERE EmployeeID = @Employee AND EmployeeRank = 3)
--     BEGIN
--         PRINT 'No such employee or his rank is not suitable!'
--         RETURN -2
--     END
--     IF NOT EXISTS(SELECT AdvertiserID FROM Advertisers WHERE AdvertiserID = @Advertiser)
--     BEGIN
--         PRINT 'Unknown advertiser!'
--         RETURN -2
--     END
--     IF EXISTS(SELECT SeanceId, Advertiser, AdvertisingName
--                 FROM Advertising
--                     WHERE SeanceId = @SeanceId and Advertiser = @Advertiser and AdvertisingName = @AdvertisingName)
--     BEGIN
--         PRINT 'Such advertising is already rolling!';
--         RETURN -1;
--     END

--     INSERT INTO Advertising
--         VALUES(@SeanceId, @Employee, @Advertiser, @AdvertisingName, @AdvertisingDuration, @AdvertisingCost);
--     RETURN 0
-- END
-- exec InsertAdvertising 6, 3, 3, 'some', 200, 4000
-- ticket
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
exec CreateTicket 1, 'standart', 0, 9, 15, 200
-- IF NOT EXISTS(SELECT  FROM  WHERE  = @)
--     BEGIN
--         PRINT '!'
--         RETURN -2
--     END