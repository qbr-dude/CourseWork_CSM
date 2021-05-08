# Кинотеатр

### Описание деятельсности

*Кинотеатр* - это общественное здание, производящее показ фильмов. В кинотеатре имеется пять кинозалов, что позволяет производить показ нескольких фильмов одновременно, буфет, служебные помещения, гардероб. 

<p>Кинотеатр проводит ежедневные сеансы с 8:00 до 23:00. Соответственно, в зависимости от возможной нагрузки залов, стоимость билета распределяется по определенным временным рамкам. </p>

В связи с эпидемической повесткой в кинотеатре проводится ряд беспрецедентных действий. Так, количество одновременных посетителей одного зала ограничено на 40%, то есть в обычном зале может быть только 110 - 120 человек, сидящих через одно кресло. Так же за 10 минут до запуска зрителей проводится санитарная обработка сидений, ручек, перил.  
Когда остается 15 минут до начала фильма, начинается запуск зрителей. Проверяется билет и наличие маски. Далее, по ходу сеанса, рабочий, "привязанный" к этому , залу, периодически заходит в него,чтобы проверить, что никто не нарушает условий просмотра фильма. 
В зависимости от популярности фильма, в день может проводиться от двух до десяти сеансов в различных кинозалах. При этом имеется увеличенный по размерам зал, специализированный под популярные фильмы. По сравнению с обычных залом, вмещающим до 150 человек, данных может принять одновременно 200.

За работу кинотеатра отвечает администратор. Он с менеджером составляет расписание кинотеатра и согласовывают прочие рабочие моменты. Администратор заполняет необходимые документы и журналы.

Киномеханик отвечает за работу кинопоказывающей аппаратуры, то есть за ее включение, настройку и  управление, заправку кинопленки, а также за саму пленку - если во время фильма произойдет ее обрыв, он должен немедленно устранить данную неполадку. Киномеханик также должен следить за состоянием кинопроекционной и звуковоспроизводящей аппаратурой, регулярно чистить и смазывать детали. При поступлении новой аппаратуры он проводит ее проверку и настройку. Также киномеханик отвечает за состояние зала - за исправность кресел, указательных огней.

Менеджер по прокату составляет расписание, составляет отчеты кинопрокатным компаниям, отвечает за доставку кинопленки.

Менеджер по рекламе и маркетингу проводит различные акции, занимается рекламной продажей площадей комплекса, участвует в разработке маркетинговой стратегии и плана продвижения фильмов.

Уборщики убирают кинозалы до и после показов фильмов, убирают площадь кинозала.

Кассиры и работники у залов работают за кассами, выдают и пробивают билеты, в условиях пандемии проверяют маски, могут помогать киномеханикам и уборщикам.

### Предоставляемые услуги

### Сущности

* Кинозалы
* Персонал
    * Администратор
    * Менеджер по прокату
    * Менеджер по маркетингу
    * Киномеханики
    * Уборщики
    * Кассиры и работники у залов
* Фильмы
* Кассы
* Мероприятия
    * Акции
* Рекламодатели
    * Реклама

### Связи

 -> Работники у залов - работают(*как пример действия при пожаре*) -> Кинозалы\
 -> Работники у залов - проверяют билеты -> Зрители\
 -> Администратор - платит, назначает премии -> Персонал\
 -> Менеджер по прокату - заказывает и работает с фильмами -> Фильмы\
 -> Кассиры - работают -> Кассы\
 -> Менеджер по маркетингу - проводит различные акции -> Мероприятия\
 -> Кассы - деньги -> Адмиинистратор\
 -> Киномеханики, уборщики - подготавливают -> Кинозалы\
 -> Киномеханики - настраивают фильмы -> Фильмы, Кинозалы\
 -> Зрители - покупают билеты -> Касса\
 -> Зрители - смотрят фильм -> Кинозалы, Фильмы (*как одна связь*)\
 -> Рекламодатели - заказывают рекламу -> Менеджер по маркетингу\
 -> Администратор - согласовывает что-либо (*можно разбить*) -> Менеджер по прокату, по маркетингу\


### Сущности с атрибутами (10 таблиц)

* Фильм
    - Название
    - Год выхода
    + Режиссер
    + Бюджет
    + Оценки
    + Возрастной рейтинг
    + Длительность
* Кинозал
    - Номер
    + Количество мест
    + Сотрудник
    + Дополнительные параметры(?)
* Касса
    - Номер
    + Время смены
* Билет
    - Номер
    + Имя кассира/NULL
    + Номер ряда
    + Номер места
    + Стоимость
    + Тип
* Заказ
    - Номер
    - Номер билета
* Рекламодатель
    - Имя
    - Название компании
* Реклама
    - Название
    * Стоимость
    * Время показа (утро, день, вечер)
    * Длительность
* Сеанс
    - Название фильма
    - Время показа
    - Зал
    + Тип
    + Возрастной рейтинг
* Тип сеанса
    - Тип
    + Описание
* Сотрудники
    - Имя
    - Паспорт
    + Должность
    + Зарплата
    + Стаж
* Должность
    - Название
    + Тип/ранг - кем командует
    + Обязанности