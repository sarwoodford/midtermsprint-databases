-- all queries are copy/pasted from pgadmin after being tested for functionality.

-- CREATE TABLES 

CREATE TABLE movies(
movie_id SERIAL PRIMARY KEY,
title VARCHAR(100) NOT NULL,
release_year INT NOT NULL,
genre VARCHAR(100) NOT NULL,
director_name VARCHAR(100) NOT NULL
);

CREATE TABLE customers(
customer_id SERIAL PRIMARY KEY,
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
email VARCHAR(150) UNIQUE NOT NULL,
phone_num VARCHAR(10) NOT NULL
);

CREATE TABLE rentals(
rental_id SERIAL PRIMARY KEY,
customer_id INT REFERENCES customers(customer_id),
movie_id INT REFERENCES movies(movie_id),
rental_date DATE NOT NULL,
return_date DATE
);

-- INSERT DATA INTO TABLES, ENSURING THERE ARE (at least) 5 MOVIES, 5
-- CUSTOMERS, AND 10 RENTALS 

INSERT INTO movies (title, release_year, genre, director_name) VALUES
('Forrest Gump', 1994, 'Comedy', 'Robert Zemeckis'),
('The Godfather', 1972, 'Crime', 'Francis Ford Coppola'),
('Whiplash', 2014, 'Drama', 'Damien Chazelle'),
('Shutter Island', 2010, 'Psychological Thriller', 'Martin Scorsese'),
('Jurrastic Park', 1993, 'Sci-Fi', 'Steven Spielberg');

INSERT INTO customers (first_name, last_name, email, phone_num) VALUES
('John', 'Doe', 'jdoe@example.com', '1234567890'),
('Jane', 'Smith', 'jsmith@example.com', '2345678901'),
('Anna', 'Brown', 'abrown@example.com', '3456789012'),
('Bob', 'Roberts', 'broberts@example.com', '4567890123'),
('Lisa', 'James', 'ljames@example.com', '5678901234');

INSERT INTO rentals (customer_id, movie_id, rental_date, return_date) VALUES
(1, 1, '2024-01-10', '2024-01-15'),
(2, 2, '2024-02-09', '2024-02-20'),
(3, 3, '2024-03-08', '2024-03-11'),
(4, 4, '2024-04-07', '2024-04-14'), 
(5, 5, '2024-05-06', '2024-05-08'), 
(1, 3, '2024-06-05', '2024-06-07'), 
(2, 1, '2024-07-04', '2024-07-08'),
(3, 4, '2024-08-03', '2024-08-11'), 
(4, 2, '2024-09-02', NULL), 
(5, 3, '2024-10-01', NULL); 

-- POSTGRESQL QUERIES
-- FIND ALL MOVIES RENTED BY A SPECIFIC CUSTOMER, GIVEN THEIR EMAIL

FROM rentals
JOIN customers ON rentals.customer_id = customers.customer_id
JOIN movies ON rentals.movie_id = movies.movie_id
WHERE customers.email = 'jdoe@example.com';

-- GIVEN A MOVIE TITLE, LIST ALL CUSTOMERS WHO HAVE RENTED THE MOVIE

SELECT customers.first_name, customers.last_name
FROM rentals
JOIN customers ON rentals.customer_id = customers.customer_id
JOIN movies ON rentals.movie_id = movies.movie_id
WHERE movies.title = 'Shutter Island';

-- GET THE RENTAL HISTORY FOR A SPECIFIC MOVIE TITLE

SELECT customers.first_name, customers.last_name, rentals.rental_date, rentals.return_date
FROM rentals
JOIN customers ON rentals.customer_id = customers.customer_id
JOIN movies ON rentals.movie_id = movies.movie_id
WHERE movies.title = 'Jurrastic Park';

-- FOR A SPECIFC MOVIE DIRECTOR, FIND THE NAME OF THE CUSTOMER, THE DATE THAT THE
-- MOVIE WAS RENTED AND THE MOVIE TITLE, EACH TIME A MOVIE BY THAT DIRECTOR WAS RENTED

SELECT customers.first_name, customers.last_name, rentals.rental_date, movies.title
FROM rentals
JOIN customers ON rentals.customer_id = customers.customer_id
JOIN movies ON rentals.movie_id = movies.movie_id
WHERE movies.director_name = 'Francis Ford Coppola'

-- LIST ALL CURRENTLY RENTED OUT MOVIES (MOVIES THAT HAVE NOT BEEN RETURNED)

SELECT movies.title
FROM rentals
JOIN movies ON rentals.movie_id = movies.movie_id
WHERE rentals.return_date IS NULL;