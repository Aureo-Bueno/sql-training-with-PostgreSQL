-- Deletes rows from the 'emp' table where the salary is less than 0.
CREATE FUNCTION clean_emp() RETURNS void AS '
    DELETE FROM emp
        WHERE salary < 0;
' LANGUAGE SQL;

-- Simple function that calculates (5 - 3) * 2 and returns the result.
CREATE FUNCTION first_function() RETURNS INTEGER AS '
    SELECT (5 - 3) * 2
' LANGUAGE SQL;

-- Executes the function 'first_function' and returns the result.
SELECT first_function();

-- Executes 'first_function' and renames the result as 'number'.
SELECT first_function() AS number;

-- Creates a table 'a' with a 'name' column of type VARCHAR.
CREATE TABLE a ( name VARCHAR(255) NOT NULL);

-- Function to insert a 'name' value into table 'a'. This version doesn't return the inserted name.
CREATE FUNCTION create_a(name VARCHAR) RETURNS VARCHAR AS'
    INSERT INTO a(name) VALUES(create_a.name)
' LANGUAGE SQL;

-- Modified version of 'create_a' that inserts 'name' into table 'a' and returns the inserted name.
CREATE FUNCTION create_a(name VARCHAR) RETURNS VARCHAR AS'
    INSERT INTO a(name) VALUES(create_a.name);

    SELECT name;
' LANGUAGE SQL;

-- Replaces the previous 'create_a' function. Inserts 'name' and returns the name.
CREATE OR REPLACE FUNCTION create_a(name VARCHAR) RETURNS VARCHAR AS'
    INSERT INTO a(name) VALUES(create_a.name);

    SELECT name;
' LANGUAGE SQL;

-- Inserts 'Vinicius Dias' into the table and returns it.
SELECT create_a('Vinicius Dias');

-- Replaces the previous 'create_a' function. This version does not return anything (void).
CREATE OR REPLACE FUNCTION create_a(name VARCHAR) RETURNS void AS'
    INSERT INTO a(name) VALUES(create_a.name)
' LANGUAGE SQL;

-- Drops the 'create_a' function if it exists and replaces it with the same version.
DROP FUNCTION create_a;
CREATE OR REPLACE FUNCTION create_a(name VARCHAR) RETURNS void AS'
    INSERT INTO a(name) VALUES(create_a.name)
' LANGUAGE SQL;

-- Inserts 'Vinicius Dias' into the table using the 'create_a' function.
SELECT create_a('Vinicius Dias');

-- Replaces 'create_a' function to insert a fixed value ('Patricia') into the table.
DROP FUNCTION create_a;
CREATE OR REPLACE FUNCTION create_a(name VARCHAR) RETURNS void AS $$
    INSERT INTO a(name) VALUES('Patricia')
$$ LANGUAGE SQL;

-- Even though 'Vinicius Dias' is passed, 'Patricia' is inserted due to the function logic.
SELECT create_a('Vinicius Dias');

-- Function intended to sum two numbers, but has a missing parameter (results in error).
CREATE FUNCTION sum_two_numbers() RETURNS INTEGER AS'
   SELECT number_1 + number2
' LANGUAGE SQL;

-- Tries to sum two numbers but will fail due to function name typo and missing parameters.
SELECT sum_two_numbers(2, 2);

-- Corrected version of 'sum_two_numbers' to accept two integer parameters and return their sum.
CREATE FUNCTION sum_two_numbers(number_1 INTEGER, number_2 INTEGER) RETURNS INTEGER AS'
   SELECT number_1 + number2
' LANGUAGE SQL;

-- Calls the corrected 'sum_two_numbers' function with parameters 2 and 2.
SELECT sum_two_numbers(2, 2);

-- Calls 'sum_two_numbers' with 3 and 17.
SELECT sum_two_numbers(3, 17);

-- Incorrect function, tries to use variables not defined within the function scope.
CREATE FUNCTION sum_two_numbers(any INTEGER, thing INTEGER) RETURNS INTEGER AS'
   SELECT number_1 + number2
' LANGUAGE SQL;

-- Drops the 'sum_two_numbers' function if it exists and replaces it.
DROP FUNCTION sum_two_numbers;

-- Corrects the function by using positional arguments ($1, $2) to sum the inputs.
CREATE FUNCTION sum_two_numbers(INTEGER, INTEGER) RETURNS INTEGER AS'
   SELECT $1 + $2
' LANGUAGE SQL;

-- Calls the corrected 'sum_two_numbers' function with 3 and 17.
SELECT sum_two_numbers(3, 17);

-- Creates a table 'instructor' with columns for id, name, and salary.
CREATE TABLE instructor (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    salary DECIMAL(10, 2)
);

-- Inserts a record into the 'instructor' table.
INSERT INTO instructor (name, salary) VALUES ('Vinicius Dias', 100);

-- Function that doubles the salary of an instructor.
CREATE FUNCTION double_salary(instructor_row instructor) RETURNS DECIMAL AS $$
    SELECT instructor_row.salary * 2 AS double;
$$ LANGUAGE SQL;

-- Calls the 'double_salary' function on each instructor.
SELECT name, double_salary(instructor) FROM instructor;

-- Function that returns a fake instructor record.
CREATE FUNCTION create_fake_instructor() RETURNS TABLE (id INTEGER, name VARCHAR, salary DECIMAL) AS $$
    SELECT 22 AS id, 'Fake Name' AS name, 200::DECIMAL AS salary;
$$ LANGUAGE SQL;

-- Calls the 'create_fake_instructor' function.
SELECT * FROM create_fake_instructor();

-- Inserts multiple records into the 'instructor' table.
INSERT INTO instructor (name, salary) VALUES 
    ('Diogo Mascarenha', 200),
    ('Nico Steppat', 300),
    ('Juliana', 400),
    ('Priscila', 500);

-- Function that returns instructors with a salary greater than a given threshold.
CREATE FUNCTION well_paid_instructors(salary_threshold DECIMAL) RETURNS TABLE (id INTEGER, name VARCHAR, salary DECIMAL) AS $$
    SELECT id, name, salary 
    FROM instructor 
    WHERE salary > salary_threshold;
$$ LANGUAGE SQL;

-- Calls the 'well_paid_instructors' function with a salary threshold of 300.
SELECT * FROM well_paid_instructors(300);

-- Creates a type 'two_values' with two integer fields: 'sum' and 'product'.
CREATE TYPE two_values AS (sum INTEGER, product INTEGER);

-- Function that returns the sum and product of two numbers.
CREATE FUNCTION sum_and_product(number_1 INTEGER, number_2 INTEGER) RETURNS two_values AS $$
    SELECT number_1 + number_2 AS sum, number_1 * number_2 AS product;
$$ LANGUAGE SQL;

-- Calls the 'sum_and_product' function with parameters 3 and 3.
SELECT * FROM sum_and_product(3, 3);

-- Function that returns instructors with a salary greater than a given threshold with OUT parameters.
CREATE FUNCTION well_paid_instructors(salary_threshold DECIMAL, OUT name VARCHAR, OUT salary DECIMAL) RETURNS SETOF RECORD AS $$
    SELECT name, salary 
    FROM instructor 
    WHERE salary > salary_threshold;
$$ LANGUAGE SQL;

-- Calls the 'well_paid_instructors' function with a salary threshold of 300.
SELECT * FROM well_paid_instructors(300);


-- Part 3.3

-- Creates a function 'primeira_pl' that returns an INTEGER.
-- This function simply returns the value 1.
CREATE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    SELECT 1;
$$ LANGUAGE plpgsql;

-- Drops the 'primeira_pl' function if it exists.
DROP FUNCTION primeira_pl;

-- Creates a new version of the 'primeira_pl' function that returns an INTEGER.
-- The function contains a BEGIN-END block but does not return a value, so it will fail if called.
CREATE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    BEGIN
        SELECT 1;
    END;
$$ LANGUAGE plpgsql;

-- Creates or replaces the 'primeira_pl' function to return an INTEGER.
-- The function contains a BEGIN-END block and uses the RETURN statement to return the value 1.
CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    BEGIN
        -- Several SQL commands can be placed here.
        RETURN 1;
    END;
$$ LANGUAGE plpgsql;

-- Creates or replaces the 'primeira_pl' function to return an INTEGER.
-- This version of the function declares a variable 'primeira_variavel' with a default value of 3,
-- and returns the value of this variable.
CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    DECLARE
        primeira_variavel INTEGER DEFAULT 3;
    BEGIN
        -- Several SQL commands can be placed here.
        RETURN primeira_variavel;
    END;
$$ LANGUAGE plpgsql;

-- Creates or replaces the 'primeira_pl' function to return an INTEGER.
-- This version of the function modifies the variable 'primeira_variavel' by multiplying it by 2,
-- and then returns the updated value of this variable.
CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    DECLARE
        primeira_variavel INTEGER DEFAULT 3;
    BEGIN
        primeira_variavel := primeira_variavel * 2;
        -- Several SQL commands can be placed here.
        RETURN primeira_variavel;
    END;
$$ LANGUAGE plpgsql;

-- Creates or replaces the 'primeira_pl' function to return an INTEGER.
-- This version of the function incorrectly uses '=' for assignment instead of ':=',
-- which will result in an error.
CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    DECLARE
        primeira_variavel INTEGER = 3;
    BEGIN
        primeira_variavel = primeira_variavel * 2;
        -- Several SQL commands can be placed here.
        RETURN primeira_variavel;
    END;
$$ LANGUAGE plpgsql;

-- Creates or replaces the 'primeira_pl' function to return an INTEGER.
-- This version of the function correctly uses ':=' for assignment and returns the updated value.
CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    DECLARE
        primeira_variavel INTEGER DEFAULT 3;
    BEGIN
        primeira_variavel := primeira_variavel * 2;
        -- Several SQL commands can be placed here.
        RETURN primeira_variavel;
    END;
$$ LANGUAGE plpgsql;

-- Creates or replaces the 'primeira_pl' function to return an INTEGER.
-- This version introduces a new declaration block within the function, re-declaring 'primeira_variavel'
-- and assigning it a new value of 7. The function will return this new value.
CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    DECLARE
        primeira_variavel INTEGER DEFAULT 3;
    BEGIN
        primeira_variavel := primeira_variavel * 2;

        -- Inner block redeclares 'primeira_variavel' and sets it to 7.
        DECLARE
            primeira_variavel INTEGER;
        BEGIN
            primeira_variavel := 7;
        END;

        RETURN primeira_variavel;
    END;
$$ LANGUAGE plpgsql;

-- Creates or replaces the 'primeira_pl' function to return an INTEGER.
-- This version simplifies the previous function by removing the inner DECLARE block.
-- The function will return the value 7 due to the inner BEGIN-END block.
CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    DECLARE
        primeira_variavel INTEGER DEFAULT 3;
    BEGIN
        primeira_variavel := primeira_variavel * 2;

        BEGIN
            primeira_variavel := 7;
        END;

        RETURN primeira_variavel;
    END;
$$ LANGUAGE plpgsql;

-- Calls the 'primeira_pl' function.
SELECT primeira_pl;


-- Part 4.4

-- Drops the 'create_a' function if it exists.
DROP FUNCTION create_a;

-- Creates or replaces the 'create_a' function to return void.
-- The function inserts a record with the name 'Patricia' into table 'a'.
CREATE OR REPLACE FUNCTION create_a(name VARCHAR) RETURNS void AS $$
    BEGIN
        INSERT INTO a(name) VALUES('Patricia');
    END;
$$ LANGUAGE plpgsql;

-- Calls the 'create_a' function with the parameter 'Vinicius Dias'.
SELECT create_a('Vinicius Dias');

-- Creates or replaces the 'create_fake_instructor' function that returns an 'instructor' type.
-- The function returns a row with values 22, 'Fake Name', and 200 as a type 'instructor'.
CREATE OR REPLACE FUNCTION create_fake_instructor() RETURNS instructor AS $$
    BEGIN
        RETURN ROW(SELECT 22, 'Fake Name', 200::DECIMAL)::instructor;
    END;
$$ LANGUAGE plpgsql;

-- Calls the 'create_fake_instructor' function and selects 'id' and 'salary' from the result.
SELECT id, salary FROM create_fake_instructor();

-- Creates or replaces the 'create_fake_instructor' function that returns an 'instructor' type.
-- The function declares a variable 'return_value' of type 'instructor', populates it with values,
-- and then returns the 'return_value' variable.
CREATE OR REPLACE FUNCTION create_fake_instructor() RETURNS instructor AS $$
    DECLARE
        return_value instructor;
    BEGIN
        SELECT 22, 'Fake Name', 200::DECIMAL INTO return_value;

        RETURN return_value;
    END;
$$ LANGUAGE plpgsql;

-- Calls the 'create_fake_instructor' function and selects 'id' and 'salary' from the result.
SELECT id, salary FROM create_fake_instructor();

-- Drops the 'well_paid_instructors' function if it exists.
DROP FUNCTION well_paid_instructors;

-- Creates or replaces the 'well_paid_instructors' function that returns a set of 'instructor'.
-- The function returns all instructors with a salary greater than the given 'salary_value'.
CREATE FUNCTION well_paid_instructors(salary_value DECIMAL) RETURNS SETOF instructor AS $$
    BEGIN
        RETURN QUERY SELECT * FROM instructor WHERE salary > salary_value;
    END;
$$ LANGUAGE plpgsql;

-- Calls the 'well_paid_instructors' function with a salary threshold of 300.
SELECT * FROM well_paid_instructors(300);

-- Drops the 'salary_ok' function if it exists.
DROP FUNCTION salary_ok;

-- Creates or replaces the 'salary_ok' function that takes an 'instructor' record and returns a VARCHAR.
-- This function checks if the instructor's salary is greater than 200. If so, it is considered okay. Otherwise, it can be increased.
CREATE OR REPLACE FUNCTION salary_ok(instructor instructor) RETURNS VARCHAR AS $$
    BEGIN
        -- If the instructor's salary is greater than 200, it's okay. Otherwise, it can be increased.
        IF instructor.salary > 200 THEN
            RETURN 'Salary is okay.';
        ELSE
            RETURN 'Salary can be increased';
        END IF;
    END;
$$ LANGUAGE plpgsql;

-- Selects the name and the result of the 'salary_ok' function from the 'instructor' table.
SELECT name, salary_ok(instructor) FROM instructor;

-- Drops the 'salary_ok' function if it exists.
DROP FUNCTION salary_ok;

-- Creates or replaces the 'salary_ok' function that takes an 'instructor' ID and returns a VARCHAR.
-- This function retrieves the instructor by ID, then checks if their salary is greater than 200.
-- If so, it is considered okay. Otherwise, it can be increased.
CREATE OR REPLACE FUNCTION salary_ok(id_instructor INTEGER) RETURNS VARCHAR AS $$
    DECLARE
        instructor instructor;
    BEGIN
        SELECT * FROM instructor WHERE id = id_instructor INTO instructor;

        -- If the instructor's salary is greater than 200, it's okay. Otherwise, it can be increased.
        IF instructor.salary > 200 THEN
            RETURN 'Salary is okay.';
        ELSE
            RETURN 'Salary can be increased';
        END IF;
    END;
$$ LANGUAGE plpgsql;

-- Selects the name and the result of the 'salary_ok' function by passing the instructor ID from the 'instructor' table.
SELECT name, salary_ok(instructor.id) FROM instructor;

-- Drops the 'salary_ok' function if it exists.
DROP FUNCTION salary_ok;

-- Creates or replaces the 'salary_ok' function that takes an 'instructor' ID and returns a VARCHAR.
-- This function retrieves the instructor by ID and evaluates the salary with a more detailed condition.
-- Salaries greater than 300 are considered okay. Salaries equal to 300 can be increased. Other salaries are considered outdated.
CREATE OR REPLACE FUNCTION salary_ok(id_instructor INTEGER) RETURNS VARCHAR AS $$
    DECLARE
        instructor instructor;
    BEGIN
        SELECT * FROM instructor WHERE id = id_instructor INTO instructor;

        -- If the instructor's salary is greater than 300 reais, it's okay. If it is exactly 300 reais, it can be increased. Otherwise, the salary is outdated.
        IF instructor.salary > 300 THEN
            RETURN 'Salary is okay.';
        ELSEIF instructor.salary = 300 THEN
            RETURN 'Salary can be increased';
        ELSE
            RETURN 'Salary is outdated';     
        END IF;
    END;
$$ LANGUAGE plpgsql;

-- Selects the name and the result of the 'salary_ok' function by passing the instructor ID from the 'instructor' table.
SELECT name, salary_ok(instructor.id) FROM instructor;

-- Creates or replaces the 'salary_ok' function that takes an 'instructor' ID and returns a VARCHAR.
-- This function evaluates the salary using a CASE statement to provide more detailed salary conditions.
CREATE OR REPLACE FUNCTION salary_ok(id_instructor INTEGER) RETURNS VARCHAR AS $$
    DECLARE
        instructor instructor;
    BEGIN
        SELECT * FROM instructor WHERE id = id_instructor INTO instructor;

        -- The function uses a CASE statement to evaluate the salary.
        CASE
            WHEN instructor.salary = 100 THEN
                RETURN 'Salary is very low';
            WHEN instructor.salary = 200 THEN
                RETURN 'Salary is low';
            WHEN instructor.salary = 300 THEN
                RETURN 'Salary is okay';
            ELSE
                RETURN 'Salary is excellent';
        END CASE;
    END;
$$ LANGUAGE plpgsql;

-- Selects the name and the result of the 'salary_ok' function by passing the instructor ID from the 'instructor' table.
SELECT name, salary_ok(instructor.id) FROM instructor;

-- Creates or replaces the 'salary_ok' function that takes an 'instructor' ID and returns a VARCHAR.
-- This function incorrectly uses a CASE statement without a proper condition.
CREATE OR REPLACE FUNCTION salary_ok(id_instructor INTEGER) RETURNS VARCHAR AS $$
    DECLARE
        instructor instructor;
    BEGIN
        SELECT * FROM instructor WHERE id = id_instructor INTO instructor;

        -- The function uses a CASE statement but without valid conditions for evaluation.
        CASE
            WHEN 100 THEN
                RETURN 'Salary is very low';
            WHEN 200 THEN
                RETURN 'Salary is low';
            WHEN 300 THEN
                RETURN 'Salary is okay';
            ELSE
                RETURN 'Salary is excellent';
        END CASE;
    END;
$$ LANGUAGE plpgsql;

