USE CinemaDB
GO

--view with seance info
CREATE VIEW SeanceView 
    AS
SELECT Films.FilmName as 'Название фильма', HollID as 'Номер зала', ShowTime as 'Время показа', AgeRating as 'Возрастной рейтинг', SeanceType as 'Тип сеанса', SeanceTypes.TypeDescription as 'Описание сеанса'
    FROM Seances 
        INNER JOIN Films ON Seances.FilmID = Films.FilmID
        INNER JOIN SeanceTypes ON Seances.SeanceType = SeanceTypes.TypeName
GO

--view about advertising
CREATE VIEW AdvertisingView
    AS
SELECT Advertising.AdvertisingName as 'Название рекламы', Films.FilmName as 'Название фильма', Advertisers.AdvertiserName as 'Рекламодатель', Employees.EmployeeName as 'Имя ответственного сотрудника', AdvertisingDuration as 'Длительность (сек)', AdvertisingCost as 'Стоимость'
    FROM Advertising
        INNER JOIN Seances ON Advertising.SeanceId = Seances.SeanceId
        INNER JOIN Films ON Seances.FilmID = Films.FilmID
        INNER JOIN Advertisers ON Advertising.Advertiser = AdvertiserID
        INNER JOIN Employees on Advertising.Employee = Employees.EmployeeID
GO

select* from AdvertisingView