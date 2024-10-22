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