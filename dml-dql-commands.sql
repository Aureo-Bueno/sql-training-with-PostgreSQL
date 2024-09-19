-- Create a new database named 'alura'
CREATE DATABASE alura;

-- Create 'student' table with student details
CREATE TABLE student (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    birth_date DATE NOT NULL
);

-- Create 'category' table for course categories
CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

-- Create 'course' table with a foreign key to 'category'
CREATE TABLE course (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category_id INTEGER NOT NULL REFERENCES category(id)
);

-- Create 'student_course' table to link students and courses (many-to-many)
CREATE TABLE student_course (
    student_id INTEGER NOT NULL REFERENCES student(id),
    course_id INTEGER NOT NULL REFERENCES course(id),
    PRIMARY KEY (student_id, course_id)
);

-- Drop the tables created above
DROP TABLE student, category, course, student_course;

-- Create a schema named 'academic'
CREATE SCHEMA academic;

-- Recreate the 'student' table within 'academic' schema
CREATE TABLE academic.student (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    birth_date DATE NOT NULL
);

-- Recreate the 'category' table within 'academic' schema
CREATE TABLE academic.category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

-- Recreate the 'course' table with a foreign key to 'academic.category'
CREATE TABLE academic.course (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category_id INTEGER NOT NULL REFERENCES academic.category(id)
);

-- Recreate the 'student_course' table within 'academic' schema (many-to-many)
CREATE TABLE academic.student_course (
    student_id INTEGER NOT NULL REFERENCES academic.student(id),
    course_id INTEGER NOT NULL REFERENCES academic.course(id),
    PRIMARY KEY (student_id, course_id)
);

-- Ensure 'academic.student' table exists before creation
CREATE TABLE IF NOT EXISTS academic.student (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    birth_date DATE NOT NULL
);

-- Create a temporary table 'a' with a NOT NULL check constraint
CREATE TEMPORARY TABLE a (
    column VARCHAR(255) NOT NULL CHECK (column <> '')
);

-- Insert data into the temporary table 'a'
INSERT INTO a VALUES ('Vinicius');

-- Drop the temporary table 'a'
DROP TABLE a;

-- Recreate the temporary table 'a' with a UNIQUE constraint
CREATE TEMPORARY TABLE a (
    column1 VARCHAR(255) NOT NULL CHECK (column1 <> ''),
    column2 VARCHAR(255) NOT NULL,
    UNIQUE (column1, column2)
);

-- Insert values into the new 'a' table
INSERT INTO a VALUES ('a', 'c');

-- Rename the table 'a' to 'test'
ALTER TABLE a RENAME TO test;
SELECT * FROM test;

-- Rename columns in 'test' table
ALTER TABLE test RENAME column1 TO first_column;
ALTER TABLE test RENAME column2 TO second_column;

-- Insert data into 'academic.student'
INSERT INTO academic.student (first_name, last_name, birth_date) VALUES
    ('Vinicius', 'Dias', '1997-10-15'),
    ('Patricia', 'Freitas', '1986-10-25'),
    ('Diogo', 'Oliveira', '1984-08-27'),
    ('Maria', 'Rosa', '1985-01-01');

-- Insert data into 'academic.category'
INSERT INTO academic.category (name) VALUES ('Front-end'), ('Programming'), ('Databases'), ('Data Science');

-- Insert courses into 'academic.course' with corresponding categories
INSERT INTO academic.course (name, category_id) VALUES
    ('HTML', 1),
    ('CSS', 1),
    ('JS', 1),
    ('PHP', 2),
    ('Java', 2),
    ('C++', 2),
    ('PostgreSQL', 3),
    ('MySQL', 3),
    ('Oracle', 3),
    ('SQL Server', 3),
    ('SQLite', 3),
    ('Pandas', 4),
    ('Machine Learning', 4),
    ('Power BI', 4);

-- Insert student-course enrollments
INSERT INTO academic.student_course VALUES (1, 4), (1, 11), (2, 1), (2, 2), (3, 4), (3, 3), (4, 4), (4, 6), (4, 5);

-- Select courses from category 2 (Programming)
SELECT *
  FROM academic.course
  JOIN academic.category ON academic.category.id = academic.course.category_id
 WHERE category_id = 2;

-- Create a temporary table 'programming_courses' for selected programming courses
CREATE TEMPORARY TABLE programming_courses (
    course_id INTEGER PRIMARY KEY,
    course_name VARCHAR(255) NOT NULL
);

-- Insert programming courses into 'programming_courses' table
INSERT INTO programming_courses VALUES (4, 'PHP'), (5, 'Java'), (6, 'C++');

-- Select course details for programming courses
SELECT academic.course.id,
       academic.course.name
  FROM academic.course
  JOIN academic.category ON academic.category.id = academic.course.category_id
 WHERE category_id = 2;

-- Drop the temporary table 'programming_courses'
DROP TABLE programming_courses;

-- Recreate 'programming_courses' and insert data from 'academic.course'
CREATE TEMPORARY TABLE programming_courses (
    course_id INTEGER PRIMARY KEY,
    course_name VARCHAR(255) NOT NULL
);

INSERT INTO programming_courses
SELECT academic.course.id,
       academic.course.name
  FROM academic.course
  JOIN academic.category ON academic.category.id = academic.course.category_id
 WHERE category_id = 2;

-- Select all data from 'programming_courses'
SELECT * FROM programming_courses;

-- Create a new schema named 'test'
CREATE SCHEMA test;

-- Create a permanent table in 'test' schema for programming courses
CREATE TABLE test.programming_courses (
    course_id INTEGER PRIMARY KEY,
    course_name VARCHAR(255) NOT NULL
);

-- Insert data into 'test.programming_courses' from 'academic.course'
INSERT INTO test.programming_courses
SELECT academic.course.id,
       academic.course.name
  FROM academic.course
 WHERE category_id = 2;

-- Select all data from 'test.programming_courses'
SELECT * FROM test.programming_courses;

-- Create a temporary table 'auto' with an auto-incrementing ID
CREATE TEMPORARY TABLE auto (
    id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

-- Insert values into 'auto' table
INSERT INTO auto (name) VALUES ('Vinicius Dias');
INSERT INTO auto (id, name) VALUES (2, 'Vinicius Dias');
INSERT INTO auto (id, name) VALUES ('Another name');

-- Select all data from 'auto'
SELECT * FROM auto;

-- Create a sequence 'i_created' for custom ID generation
CREATE SEQUENCE i_created;

-- Drop the 'auto' table
DROP TABLE auto;

-- Recreate 'auto' with a custom ID defaulting to the 'i_created' sequence
CREATE TEMPORARY TABLE auto (
    id INTEGER PRIMARY KEY DEFAULT i_created,
    name VARCHAR(30) NOT NULL
);

-- Retrieve the current value of the 'i_created' sequence
SELECT CURRVAL('i_created');
-- Increment and retrieve the next value of the 'i_created' sequence
SELECT NEXTVAL('i_created');

-- Drop the 'auto' table again
DROP TABLE auto;

-- Recreate 'auto' with auto-incrementing IDs using 'i_created' sequence
CREATE TEMPORARY TABLE auto (
    id INTEGER PRIMARY KEY DEFAULT NEXTVAL('i_created'),
    name VARCHAR(30) NOT NULL
);

-- Insert values into the 'auto' table
INSERT INTO auto (name) VALUES ('Vinicius Dias');
INSERT INTO auto (id, name) VALUES (2, 'Vinicius Dias');
INSERT INTO auto (id, name) VALUES ('Another name');

-- Select all data from 'auto'
SELECT * FROM auto;

-- Create a temporary table 'movie' with classification categories
CREATE TEMPORARY TABLE movie (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    classification VARCHAR(255) CHECK (classification IN ('GENERAL', '12_YEARS', '14_YEARS', '16_YEARS', '18_YEARS'))
);

-- Drop the 'movie' table
DROP TABLE movie;

-- Recreate the 'movie' table with an ENUM for classification
CREATE TEMPORARY TABLE movie (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    classification ENUM ('GENERAL', '12_YEARS', '14_YEARS', '16_YEARS', '18_YEARS')
);

-- Create an ENUM type for classification outside of the table
CREATE TYPE CLASSIFICATION AS ENUM ('GENERAL', '12_YEARS', '14_YEARS', '16_YEARS', '18_YEARS');

-- Drop the 'movie' table
DROP TABLE movie;

-- Recreate the 'movie' table using the 'CLASSIFICATION' type
CREATE TEMPORARY TABLE movie (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    classification CLASSIFICATION
);

-- Insert invalid data into 'movie' (will cause an error)
INSERT INTO movie (name, classification) VALUES ('A random movie', 'Test');

-- Insert valid data into 'movie'
INSERT INTO movie (name, classification) VALUES
