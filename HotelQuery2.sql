create table Room(
RoomId int primary key,
RoomCapacity int not null,
RoomComfort nchar(52) not null,
[Floor] int not null,
Price int not null)

create table Client(
Passport nchar(10) primary key not null,
[Name] nchar(52) not null,
Gender nchar(52) not null)

create table Booking(
BookingID int identity primary key not null,
DateIn date not null,
DateOut date not null,
Price int not null,
ClientPassport nchar(10) not null foreign key references Client(Passport));

create table RoomBooking(
BookingId int not null,
RoomId int not null,
foreign key (BookingId) references Booking(BookingID),
foreign key (RoomId) references Room(RoomId),
primary key (BookingId, RoomId))

insert into Client (Passport, [Name], Gender)
values
('1234567891', 'Litovkin Nikita', 'Male'),
('5464343634', 'Shestakov Vladislav', 'Male'),
('8734674644', 'Petuhov Ivan', 'Male'),
('6666666666', 'Yablokova Darya', 'Female'),
('5252525252', 'Zaharov Daniil', 'Male'),
('2556794673', 'Antonov Antonio', 'Male'),
('4867404768', 'Rayan Gosling', 'Sigma'),
('8759486798', 'Barhatov Nikita', 'Male'),
('6469209856', 'Smirnova Anastasya', 'Female'),
('5649038658', 'Patrick Bateman', 'Sigma'),
('6943720957', 'Smirnov Grigoriy', 'Male');


insert into Room (RoomId, RoomCapacity, RoomComfort, [Floor], Price)
values
(301, 2, 'Standart', 3, 3000),
(512, 3, 'Luxury', 5, 5000),
(10, 1, 'Economy', 1, 1000),
(521, 3, 'Luxury', 5, 5000),
(403, 2, 'Econom', 4, 1500),
(314, 4, 'Standart', 3, 3000),
(200, 2, 'Luxury', 2, 5000),
(13, 3, 'Economy', 1, 1000),
(402, 1, 'Luxury', 4, 5000),
(251, 3, 'Standart', 2, 2000);

insert into Booking (DateIn, DateOut, Price, ClientPassport)
values
('2024-09-01', '2024-09-05', 12000, '1234567891'),
('2024-09-03', '2024-09-06', 15000, '1234567891'),
('2024-09-02', '2024-09-04', 4000, '8734674644'),
('2024-09-05', '2024-09-08', 18000, '6666666666'),
('2024-09-01', '2024-09-07', 21000, '5252525252'),
('2024-08-12', '2024-08-25', 10000, '2556794673'),
('2024-08-24', '2024-08-26', 9000, '4867404768'),
('2024-08-16', '2025-08-18', 7000, '5649038658'),
('2024-08-17', '2025-08-20', 18000, '6469209856'),
('2024-08-13', '2025-08-29', 20000, '6943720957');

insert into RoomBooking(BookingId, RoomId)
values
(1, 301),
(2, 512),
(3, 10),
(4, 521),
(5, 403),
(6, 314),
(7, 200),
(8, 13),
(9, 402),
(10, 251);

select * from Room
select * from Client
select * from Booking
select * from RoomBooking

--drop table if exists RoomBooking
--drop table if exists Booking
--drop table if exists Room
--drop table if exists Client

SELECT RoomId, RoomCapacity, RoomComfort, [Floor], Price -- Сортировка по цене(убыв), вместимость(возр)
FROM Room
ORDER BY Price DESC, RoomCapacity ASC;

SELECT Passport, [Name], Gender -- Клиенты, пасспорт которых начинается на 52
FROM Client
WHERE Passport LIKE '52%';

SELECT RoomId, RoomCapacity, RoomComfort, [Floor], Price -- Комнаты на 5 этаже и с ценой больше 4000р
FROM Room
WHERE [Floor] = 5 AND Price > 4000;

SELECT BookingID, DateIn, DateOut, Price, ClientPassport -- Бронирования в сентябре
FROM Booking
WHERE DateOut BETWEEN '2024-09-01' AND '2024-09-30';

SELECT COUNT(*) AS TotalBookings -- Общее количество бронирований
FROM Booking;

SELECT MAX(Price) AS MaxBookingPrice -- Максимальная цена бронирования
FROM Booking;

SELECT SUM(Price) AS TotalIncome -- Доход за весь период
FROM Booking;

SELECT Gender, COUNT(*) AS NumberOfClients -- Подсчёт клиентов по полу и вывод количества 
FROM Client
GROUP BY Gender;

--SELECT Gender, YEAR(DateIn) AS BookingYear, COUNT(*) AS TotalBookings, SUM(Price) AS TotalIncome
--FROM Client c
--JOIN Booking b ON c.Passport = b.ClientPassport
--GROUP BY ROLLUP (Gender, YEAR(DateIn));

--SELECT Gender, YEAR(DateIn) AS BookingYear, COUNT(*) AS TotalBookings, SUM(Price) AS TotalIncome
--FROM Client c
--JOIN Booking b ON c.Passport = b.ClientPassport
--GROUP BY CUBE (Gender, YEAR(DateIn));

SELECT RoomId, RoomComfort -- Выбор всех комнат типа не Luxury
FROM Room
WHERE RoomComfort NOT LIKE '%Luxury%';

SELECT Passport, [Name] -- Клиенты без буквы "a" в имени
FROM Client
WHERE [Name] NOT LIKE '%a%';

-- ПУНКТ 2

SELECT b.BookingID, b.DateIn, b.DateOut, b.Price, c.[Name] -- Бронирование вместе с клиентами
FROM Booking b, Client c
WHERE b.ClientPassport = c.Passport;

SELECT rb.BookingId, rb.RoomId, r.RoomComfort, r.Price -- Бронирование вместе с описанием комнаты
FROM RoomBooking rb, Room r
WHERE rb.RoomId = r.RoomId;

SELECT c.[Name], c.Gender, b.DateIn, b.DateOut -- Информация о клиентах, бронировавших комнату "301"
FROM Client c, Booking b, RoomBooking rb
WHERE b.ClientPassport = c.Passport
  AND b.BookingID = rb.BookingId
  AND rb.RoomId = 301;

SELECT b.BookingID, b.DateIn, b.DateOut, b.Price, c.[Name] -- Бронирование вместе с именами клиентов
FROM Booking b
INNER JOIN Client c ON b.ClientPassport = c.Passport;

SELECT rb.BookingId, rb.RoomId, r.RoomComfort, r.Price -- Информация о бронировании вместе с информацией о комнатах
FROM RoomBooking rb
INNER JOIN Room r ON rb.RoomId = r.RoomId;

SELECT c.[Name], c.Gender, b.DateIn, b.DateOut -- Информация о клиентах, бронировавших комнату "301"
FROM Client c
INNER JOIN Booking b ON b.ClientPassport = c.Passport
INNER JOIN RoomBooking rb ON b.BookingID = rb.BookingId
WHERE rb.RoomId = 301;

SELECT b.BookingID, b.DateIn, b.DateOut, b.Price, c.[Name] -- Бронирование с информацией о клиентах, даже если клиентов не может быть
FROM Booking b
LEFT JOIN Client c ON b.ClientPassport = c.Passport;

SELECT r.RoomId, r.RoomComfort, r.Price, rb.BookingId -- Комнаты, даже если не забронированы
FROM Room r
LEFT JOIN RoomBooking rb ON r.RoomId = rb.RoomId;