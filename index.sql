-- Create a table named 'student' with various columns for storing student information.
CREATE TABLE student (
	id SERIAL,
	name VARCHAR(255),
	cpf CHAR(11),
	observation TEXT,
	money NUMERIC(10,2),
	heigth REAL,
	active BOOLEAN,
	born_date DATE,
	class_hour TIME,
	registered_at TIMESTAMP
);

-- Insert multiple records into the 'student' table.
INSERT INTO student (name, cpf, observation, money, heigth, active, born_date, class_hour, registered_at)
VALUES
    ('João Silva', '12345678901', 'Aluno regular', 1000.50, 1.75, TRUE, '1995-03-15', '08:30:00', '2023-09-18 14:30:00'),
    ('Maria Souza', '98765432100', 'Observação especial', 2500.75, 1.68, TRUE, '2000-07-22', '10:45:00', '2023-09-17 10:00:00'),
    -- Additional records...

-- Delete a record with id=0 from the 'aluno' table.
DELETE FROM student
WHERE id=0;

-- Select names from the 'student' table and alias the column as "Name Teste".
SELECT name AS "Name Teste" FROM student;

-- Create a 'contact' table with a primary key for phone numbers.
CREATE TABLE contact (
    phone VARCHAR(15) PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Insert records into the 'contact' table.
INSERT INTO contact (phone, name) VALUES ('(21) 98765-4321', 'João');
-- Additional records...

-- Create 'departments' and 'colaborator' tables with a foreign key relationship.
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE colaborator (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    department_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments (id)
);

-- Select names from 'colaborator' and their corresponding department names.
SELECT colaborator.name, departments.name FROM colaborator
JOIN departments ON colaborator.department_id = departments.id;

-- Create 'person' and 'phone' tables with a foreign key relationship.
CREATE TABLE person (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE phone (
    id INTEGER PRIMARY KEY,
    person_id INTEGER,
    phone_number VARCHAR(15) NOT NULL,
    FOREIGN KEY (person_id) REFERENCES person (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- Insert records into 'person' and 'phone' tables.
INSERT INTO person (id, name) VALUES (1, 'Diogo');
INSERT INTO phone (id, person_id, phone_number) VALUES (1, 1, '(21) 98765-4321');

-- Create 'student', 'category', 'course', and 'student_course' tables with appropriate relationships.
CREATE TABLE student (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL
);

CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE course (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    category_id INTEGER REFERENCES category(id)
);

CREATE TABLE student_course (
    student_id INTEGER REFERENCES student(id),
    course_id INTEGER REFERENCES course(id),
    PRIMARY KEY (student_id, course_id)
);

-- Insert records into 'student', 'category', 'course', and 'student_course' tables.
INSERT INTO student (first_name, last_name, birth_date) VALUES
    ('Vinicius', 'Dias', '1997-10-15'),
    -- Additional records...

-- Retrieve the student with the highest number of courses.
SELECT student.first_name, student.last_name, COUNT(student_course.course_id) AS number_of_courses
FROM student
JOIN student_course ON student_course.student_id = student.id
GROUP BY student.first_name, student.last_name
ORDER BY number_of_courses DESC
LIMIT 1;

-- Retrieve the course with the highest number of students.
SELECT course.name, COUNT(student_course.student_id) AS number_of_students
FROM course
JOIN student_course ON student_course.course_id = course.id
GROUP BY course.name
ORDER BY number_of_students DESC
LIMIT 1;

-- Retrieve courses with more than 2 students.
SELECT course.name, COUNT(student_course.student_id) AS number_of_students
FROM course
JOIN student_course ON student_course.course_id = course.id
GROUP BY course.name
HAVING COUNT(student_course.student_id) > 2
ORDER BY number_of_students DESC;

-- Additional queries for string manipulation and formatting.
SELECT (first_name || ' ' || last_name) AS full_name FROM student;
SELECT UPPER(CONCAT('Vinicius', NULL, 'Dias') || ' ');
SELECT TRIM(UPPER(CONCAT('Vinicius', NULL, 'Dias') || ' '));
SELECT (first_name || last_name) AS full_name, birth_date FROM student;
SELECT (first_name || last_name) AS full_name, NOW()::DATE, birth_date FROM student;
SELECT (first_name || last_name) AS full_name, AGE(birth_date) AS age FROM student;
SELECT (first_name || last_name) AS full_name, EXTRACT(YEAR FROM AGE(birth_date)) AS age FROM student;

-- Various function and format examples.
SELECT pi();
SELECT @ -17581452174;
SELECT TO_CHAR(NOW(), 'DD, MONTH, YYYY');
SELECT TO_CHAR(128.3::REAL, '9999099');
