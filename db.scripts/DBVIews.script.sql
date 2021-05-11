USE CinemaDB
GO

--view with seance info
CREATE VIEW SeanceView 
    AS
SELECT Films.FilmName as '�������� ������', HollID as '����� ����', ShowTime as '����� ������', AgeRating as '���������� �������', SeanceType as '��� ������', SeanceTypes.TypeDescription as '�������� ������'
    FROM Seances 
        INNER JOIN Films ON Seances.FilmID = Films.FilmID
        INNER JOIN SeanceTypes ON Seances.SeanceType = SeanceTypes.TypeName
GO

--view about advertising
CREATE VIEW AdvertisingView
    AS
SELECT Advertising.AdvertisingName as '�������� �������', Films.FilmName as '�������� ������', Advertisers.AdvertiserName as '�������������', Employees.EmployeeName as '��� �������������� ����������', AdvertisingDuration as '������������ (���)', AdvertisingCost as '���������'
    FROM Advertising
        INNER JOIN Seances ON Advertising.SeanceId = Seances.SeanceId
        INNER JOIN Films ON Seances.FilmID = Films.FilmID
        INNER JOIN Advertisers ON Advertising.Advertiser = AdvertiserID
        INNER JOIN Employees on Advertising.Employee = Employees.EmployeeID
GO

select* from AdvertisingView