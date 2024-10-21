CREATE DATABASE cinema;
USE cinema;


CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,  
    customer_first_name VARCHAR(100) NOT NULL,
    customer_last_name VARCHAR(100) NOT NULL,   
    phone_number VARCHAR(15) UNIQUE,            
    email VARCHAR(100)  UNIQUE);
    

CREATE TABLE cinema_seats (
    seat_id VARCHAR(3) NOT NULL,                   
    customer_id INT,                                  
    movie_date DATE NOT NULL,                      
    PRIMARY KEY (seat_id, movie_date),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id));              




#this procedure cretaes a table with seats in the cinema
DELIMITER //
CREATE PROCEDURE CreateCinemaTable(dateStart DATE, dateEnd DATE)
BEGIN
	WHILE dateStart <= dateEnd DO
		INSERT INTO cinema_seats (seat_id, movie_date) VALUES
		('A1', dateStart), ('A2', dateStart), ('A3', dateStart), ('A4', dateStart),
		('A5', dateStart), ('A6', dateStart), ('A7', dateStart), ('A8', dateStart),
		('B1', dateStart), ('B2', dateStart), ('B3', dateStart), ('B4', dateStart),
		('B5', dateStart), ('B6', dateStart), ('B7', dateStart), ('B8', dateStart),
		('C1', dateStart), ('C2', dateStart), ('C3', dateStart), ('C4', dateStart),
		('C5', dateStart), ('C6', dateStart), ('C7', dateStart), ('C8', dateStart),
		('D1', dateStart), ('D2', dateStart), ('D3', dateStart), ('D4', dateStart),
		('D5', dateStart), ('D6', dateStart), ('D7', dateStart), ('D8', dateStart),
		('E1', dateStart), ('E2', dateStart), ('E3', dateStart), ('E4', dateStart),
		('E5', dateStart), ('E6', dateStart), ('E7', dateStart), ('E8', dateStart);
		SET dateStart = date_add(dateStart, INTERVAL 1 DAY);
	END WHILE;
END //
DELIMITER ;


CALL CreateCinemaTable("2024-10-21", "2024-10-24");

#now I fill some seats
INSERT INTO customers (customer_first_name, customer_last_name, phone_number, email) VALUES
('Peter', 'Collins', '120539289', 'petercollins@customer.com'),
('Amanda', 'Smith', '987552721', 'amandasmith@customer.com'),
('Lila', 'Stafford', '349994412', 'lilastafford@customer.com'),
('Ben', 'Collen', '728389123', 'bencollen@customer.com'),
('Noah', 'White', '566682234', 'noahwhite@customer.com'),
('Martha', 'White', '678900175', 'marthawhite@customer.com'),
('Alastor', 'Lee', '789228456', 'alastorlee@customer.com'),
('Harry', 'Potter', '899928567', 'harrypotter@customer.com'),
('Amelia', 'Clark', '551245678', 'ameliaclark@customer.com'),
('Tim', 'Burton', '129934780', 'timburton@customer.com'),
('Robert', 'Turner', '234500991', 'robertturner@customer.com');

UPDATE cinema_seats
SET customer_id = 1  
WHERE seat_id IN ('D3', 'D4', 'D5') AND movie_date = '2024-10-21';

UPDATE cinema_seats
SET customer_id = 2  
WHERE seat_id IN ('E1', 'E2', 'E3', 'E4', 'E5') AND movie_date = '2024-10-21';

UPDATE cinema_seats
SET customer_id = 3  
WHERE seat_id IN ('D5', 'D6') AND movie_date = '2024-10-22';

UPDATE cinema_seats
SET customer_id = 4  
WHERE seat_id IN ('E1', 'E2', 'E3', 'E4') AND movie_date = '2024-10-22';

UPDATE cinema_seats
SET customer_id = 5  
WHERE seat_id IN ('E8') AND movie_date = '2024-10-22';

UPDATE cinema_seats
SET customer_id = 3  
WHERE seat_id IN ('D1', 'D2') AND movie_date = '2024-10-23';

UPDATE cinema_seats
SET customer_id = 6  
WHERE seat_id IN ('E4', 'E5', 'E6', 'E7', 'E8') AND movie_date = '2024-10-23';

UPDATE cinema_seats
SET customer_id = 7  
WHERE seat_id IN ('E1') AND movie_date = '2024-10-23';

UPDATE cinema_seats
SET customer_id = 8  
WHERE seat_id IN ('D4', 'D5') AND movie_date = '2024-10-23';

UPDATE cinema_seats
SET customer_id = 9 
WHERE seat_id IN ('D6', 'D7') AND movie_date = '2024-10-24';

UPDATE cinema_seats
SET customer_id = 10  
WHERE seat_id IN ('D1', 'D2', 'D3') AND movie_date = '2024-10-24';

UPDATE cinema_seats
SET customer_id = 11 
WHERE seat_id IN ('E1', 'E2', 'E3', 'E4') AND movie_date = '2024-10-24';



