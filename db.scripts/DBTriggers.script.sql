USE CinemaDB
GO

-- when delete seance, remove all fit tickets
CREATE TRIGGER dbo.RemoveTickets
    ON Seances
AFTER delete
    AS
BEGIN
    SET NOCOUNT NO;
    DECLARE @deletingSeance tinyint;
    SET @deletingSeance = (SELECT SeanceId FROM deleted)
    DELETE FROM Tickets WHERE SeanceId = @deletingSeance;
END

--