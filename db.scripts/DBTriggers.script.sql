USE CinemaDB
GO

-- when delete seance, remove all fit tickets ADD CURSOR (cancellation of the session)
CREATE TRIGGER dbo.RemoveTickets ON Seances
   AFTER delete
AS
	DECLARE @deletingSeance tinyint;
	DECLARE seances_cursor CURSOR SCROLL
		FOR SELECT SeanceId FROM deleted;
	OPEN seances_cursor;
	FETCH FIRST FROM seances_cursor
		INTO @deletingSeance;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DELETE FROM Tickets WHERE SeanceId = @deletingSeance;
		FETCH NEXT FROM seances_cursor
			INTO @deletingSeance;
	END
	CLOSE seances_cursor;
	DEALLOCATE seances_cursor;
GO

-- checking the seating in the hall
-- how it works: reading all holls (getting id, rows and seat). then read all tickets for this holl and read the same. check values.
CREATE TRIGGER dbo.CheckingCorrectSeatsInTicket ON Tickets
    INSTEAD OF insert
AS
	DECLARE @SeanceID tinyint, @HollID tinyint, @row tinyint, @seat tinyint;
	DECLARE holls_cursor CURSOR SCROLL
		FOR SELECT HollID, RowNumber, SeatNumber FROM CinemaHolls;
	OPEN holls_cursor;
	FETCH FIRST FROM holls_cursor
		INTO @HollID, @row, @seat;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @ticket tinyint, @ticket_row tinyint, @ticket_seat tinyint;
		DECLARE tickets_cursor CURSOR SCROLL
			FOR SELECT TicketID, RowNumber, SeatNumber FROM Seances INNER JOIN inserted ON Seances.SeanceId = inserted.SeanceId WHERE Seances.HollID = @HollID;
		OPEN tickets_cursor;
		FETCH FIRST FROM tickets_cursor
			INTO @ticket, @ticket_row, @ticket_seat;
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @ticket_row < @row AND @ticket_seat < @seat
				INSERT INTO Tickets SELECT TicketType, CashboxID, SeanceId, RowNumber, SeatNumber, Cost FROM inserted WHERE TicketID = @ticket;
			ELSE
				PRINT 'ERROR!!!';
			FETCH NEXT FROM tickets_cursor
				INTO @ticket, @ticket_row, @ticket_seat;
		END
		CLOSE tickets_cursor;
		DEALLOCATE tickets_cursor;	
		FETCH NEXT FROM holls_cursor
			INTO @HollID, @row, @seat; 
	END
	CLOSE holls_cursor;
	DEALLOCATE holls_cursor;
GO
-- advesting check
--how it works: if general count of inserting and existing ad for seance more 20, it is skipping
 CREATE TRIGGER dbo.ChecingDurationForSeance ON AdvertisingSeance
 	INSTEAD OF insert
 AS
 	DECLARE @id tinyint, @SeanceId tinyint, @Duration tinyint;
 	DECLARE advertising_cursor CURSOR SCROLL
 		FOR SELECT AdID, SeanceId FROM inserted;
 	OPEN advertising_cursor;
 	FETCH FIRST FROM advertising_cursor
 		INTO @id, @SeanceId;
 	WHILE @@FETCH_STATUS = 0
 	BEGIN
 		SELECT @Duration = AdvertisingDuration FROM Advertising WHERE AdID = @id;
 		DECLARE @checkingDuration smallint;
		IF NOT EXISTS(SELECT* FROM AdvertisingSeance)
			SET @checkingDuration = 0;
		ELSE
 			SELECT @checkingDuration = SUM(AdvertisingDuration) FROM Advertising INNER JOIN AdvertisingSeance on Advertising.AdID = AdvertisingSeance.AdID GROUP BY SeanceId HAVING SeanceId = 1;
		IF @Duration + @checkingDuration < 600
			INSERT INTO AdvertisingSeance VALUES (@id, @SeanceId);
		ELSE
			PRINT 'error with duration. too long!';
 		FETCH NEXT FROM advertising_cursor
 			INTO @id, @SeanceId;
 	END
 	CLOSE advertising_cursor;
 	DEALLOCATE advertising_cursor;
 GO

--checking seance show time (comparing show time and film duration)
--how is works: get last time in holl and check inserting and its time
CREATE TRIGGER dbo.CheckingSeanceShowTime ON Seances
	AFTER insert
AS
	DECLARE @seanceID tinyint, @HollID tinyint, @FilmID tinyint, @insert_time datetime, @closest_time datetime;
	DECLARE showtime_cursor CURSOR SCROLL
		FOR SELECT SeanceId, HollID, FilmID, ShowTime FROM inserted;
	OPEN showtime_cursor;
	FETCH FIRST FROM showtime_cursor
		INTO @seanceID, @HollID, @FilmID, @insert_time;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @film_duration smallint;
		SET @closest_time = (SELECT TOP(1) ShowTime FROM Seances WHERE HollID = @HollID ORDER BY ShowTime DESC);
		SELECT @film_duration = Duration FROM Films WHERE FilmID = @FilmID;
		IF CONVERT(date, @closest_time) < CONVERT(date, @insert_time) OR (CONVERT(date, @closest_time) = CONVERT(date, @insert_time) AND DATEDIFF(MINUTE, DATEADD(DAY, DATEDIFF(DAY, 0, @closest_time), 0), @closest_time) < DATEDIFF(MINUTE, DATEADD(DAY, DATEDIFF(DAY, 0, @insert_time), 0), @insert_time)) 
		BEGIN
			delete from Seances WHERE SeanceId = @seanceID;
			PRINT 'ERROR';
		END
		FETCH NEXT FROM showtime_cursor
			INTO @seanceID, @HollID, @FilmID, @insert_time;
	END
	CLOSE showtime_cursor;
	DEALLOCATE showtime_cursor;
GO

-- DECLARE @dt datetime 
-- SET @dt = '01-01-2001 07:10:20'
-- SELECT DATEDIFF(MINUTE, DATEADD(DAY, DATEDIFF(DAY, 0, @dt), 0), @dt)