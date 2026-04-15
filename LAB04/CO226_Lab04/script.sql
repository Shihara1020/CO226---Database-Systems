-- Create the database
CREATE DATABASE movieDB;
USE movieDB;

-- Create MOVIE table
CREATE TABLE MOVIE (
    movie_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    director VARCHAR(50)
);

-- Create REVIEWER table
CREATE TABLE REVIEWER (
    reviewer_id INT PRIMARY KEY,
    reviewer_name VARCHAR(50) NOT NULL
);

-- Create RATING table
CREATE TABLE RATING (
    reviewer_id INT,
    movie_id INT,
    stars INT CHECK (stars >= 1 AND stars <= 5),
    rating_date DATE,
    PRIMARY KEY (reviewer_id, movie_id),
    FOREIGN KEY (reviewer_id) REFERENCES REVIEWER(reviewer_id) 
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
    FOREIGN KEY (movie_id) REFERENCES MOVIE(movie_id) 
        ON UPDATE CASCADE 
        ON DELETE CASCADE
);

-- Insert data into MOVIE table
INSERT INTO MOVIE (movie_id, title, year, director) VALUES
(101, 'Gone with the Wind', 1939, 'Victor Fleming'),
(102, 'Star Wars', 1977, 'George Lucas'),
(103, 'The Sound of Music', 1965, 'Robert Wise'),
(104, 'E.T.', 1982, 'Steven Spielberg'),
(105, 'Titanic', 1997, 'James Cameron'),
(106, 'Snow White', 1937, NULL),
(107, 'Avatar', 2009, 'James Cameron'),
(108, 'Raiders of the Lost Ark', 1981, 'Steven Spielberg');

-- Insert data into REVIEWER table
INSERT INTO REVIEWER (reviewer_id, reviewer_name) VALUES
(201, 'Sarah Martinez'),
(202, 'Daniel Lewis'),
(203, 'Brittany Harris'),
(204, 'Mike Anderson'),
(205, 'Chris Jackson'),
(206, 'Elizabeth Thomas'),
(207, 'James Cameron'),
(208, 'Ashley White');

-- Insert data into RATING table
INSERT INTO RATING (reviewer_id, movie_id, stars, rating_date) VALUES
(201, 101, 2, '2011-01-22'),
(202, 106, 4, NULL),
(203, 103, 2, '2011-01-20'),
(203, 108, 4, '2011-01-12'),
(204, 101, 3, '2011-01-09'),
(205, 103, 3, '2011-01-27'),
(205, 104, 2, '2011-01-22'),
(205, 108, 4, NULL),
(206, 107, 3, '2011-01-15'),
(206, 106, 5, '2011-01-19'),
(207, 107, 5, '2011-01-20'),
(208, 104, 3, '2011-01-02');

-- Display the created tables and their data
SELECT 'MOVIE TABLE:' as '';
SELECT * FROM MOVIE ORDER BY movie_id;

SELECT 'REVIEWER TABLE:' as '';
SELECT * FROM REVIEWER ORDER BY reviewer_id;

SELECT 'RATING TABLE:' as '';
SELECT * FROM RATING ORDER BY reviewer_id, movie_id, rating_date;


