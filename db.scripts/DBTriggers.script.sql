USE CinemaDB
GO

-- when delete seance, remove all fit tickets
CREATE TRIGGER dbo.RemoveTickets ON Seances
    AFTER delete
    AS
BEGIN
    SET NOCOUNT NO;
    DECLARE @deletingSeance tinyint;
    SET @deletingSeance = (SELECT SeanceId FROM deleted)
    DELETE FROM Tickets WHERE SeanceId = @deletingSeance;
END
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
CREATE TRIGGER dbo.ChecingDurationForSession ON Advertising
	INSTEAD OF insert
AS
	DECLARE @id tinyint, @SeanceId tinyint, @Duration tinyint;
	DECLARE advertising_cursor CURSOR SCROLL
		FOR SELECT AdID, SeanceId, AdvertisingDuration FROM inserted;
	OPEN advertising_cursor;
	FETCH FIRST FROM advertising_cursor
		INTO @id, @SeanceId, @Duration;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @Duration + (SELECT SUM(AdvertisingDuration) FROM Advertising WHERE SeanceId = @SeanceId) < 20
			INSERT INTO Advertising SELECT SeanceId, Employee, Advertiser, AdvertisingName, AdvertisingDuration, AdvertisingCost FROM inserted WHERE AdID = @id;
		ELSE
			PRINT 'ERROR!!';
		FETCH NEXT FROM advertising_cursor
			INTO @id, @SeanceId, @Duration;
	END
	CLOSE advertising_cursor;
	DEALLOCATE advertising_cursor;
GO