USE CinemaDB
GO

--view with seance info
CREATE VIEW SeanceView 
    AS
SELECT Films.FilmName, HollID, ShowTime, AgeRating, SeanceType, SeanceTypes.TypeDescription
    FROM Seances 
        INNER JOIN Films ON Seances.FilmID = Films.FilmID
        INNER JOIN SeanceTypes ON Seances.SeanceType = SeanceTypes.TypeName
GO

--view about advertising
CREATE VIEW AdvertisingView
    AS
SELECT Advertising.AdvertisingName, Films.FilmName, Advertisers.AdvertiserName, Employees.EmployeeName, Advertisings.AdvertisingDuration, Advertisings.AdvertisingCost
    FROM Advertising
        INNER JOIN Seances ON Advertising.SeanceId = Seances.SeanceId
        INNER JOIN Films ON Seances.FilmID = Films.FilmID
        INNER JOIN Advertisers ON Advertising.Advertiser = Advertiser.AdvertiserID
        INNER JOIN Employees on Advertising.Employee = Employees.EmployeeID