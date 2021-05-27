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
SELECT Advertising.AdvertisingName as 'Название рекламы', Films.FilmName as 'Название фильма', Advertisers.AdvertiserName as 'Рекламодатель', Advertisers.CompanyName as 'Компания рекламодателя', Employees.EmployeeName as 'Имя ответственного сотрудника', AdvertisingDuration as 'Длительность (сек)', AdvertisingCost as 'Стоимость'
    FROM Advertising
		INNER JOIN AdvertisingSeance ON Advertising.AdID = AdvertisingSeance.AdID
        INNER JOIN Seances ON AdvertisingSeance.SeanceId = Seances.SeanceId
        INNER JOIN AdvertisingEmployee ON Advertising.AdID = AdvertisingEmployee.AdID
        INNER JOIN Films ON Seances.FilmID = Films.FilmID
        INNER JOIN Advertisers ON Advertising.Advertiser = AdvertiserID
        INNER JOIN Employees on AdvertisingEmployee.EmployeeID = Employees.EmployeeID
GO
--view about employees
CREATE VIEW EmployeeView
	AS
SELECT EmployeeName as 'ФИО', Position as 'Должность', Responsibilities as 'Обязанности', EmployeeRank as 'Ранг', Salary + (Experience * 1000) as 'Зарплата', Passport as 'Паспорт', Experience as 'Стаж'
	FROM Employees INNER JOIN EmployeePosition ON Employees.Position = EmployeePosition.PositionName
GO
