-- Create table to log information about instructors

CREATE TABLE log_instructors ( id SERIAL PRIMARY KEY,
                                                 information VARCHAR(255),
                                                             creation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

-- Create function to log information after instructor creation

CREATE FUNCTION create_instructor() RETURNS TRIGGER AS $$
    DECLARE
        average_salary DECIMAL;
        instructor_earns_less INTEGER DEFAULT 0;
        total_instructors INTEGER DEFAULT 0;
        salary_record RECORD;  -- Use RECORD for looping over rows
        percentage DECIMAL(5,2);
    BEGIN
        -- Calculate the average salary, excluding the new instructor's salary
        SELECT AVG(salary) INTO average_salary FROM instructor WHERE id <> NEW.id;

        -- Log if the new instructor earns above the average
        IF NEW.salary > average_salary THEN
            INSERT INTO log_instructors (information) 
                VALUES (NEW.name || ' earns above the average');
        END IF;

        -- Loop through all instructors except the new one
        FOR salary_record IN SELECT salary FROM instructor WHERE id <> NEW.id LOOP
            total_instructors := total_instructors + 1;
            IF NEW.salary > salary_record.salary THEN
                instructor_earns_less := instructor_earns_less + 1;
            END IF;    
        END LOOP;

        -- Calculate the percentage of instructors earning less than the new one
        IF total_instructors > 0 THEN
            percentage := (instructor_earns_less::DECIMAL / total_instructors::DECIMAL) * 100;
        ELSE
            percentage := 0;
        END IF;

        -- Log the percentage information
        INSERT INTO log_instructors (information) 
            VALUES (NEW.name || ' earns more than ' || percentage || '% of the instructor pool');

        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

-- Create trigger to log after inserting a new instructor

CREATE TRIGGER create_log_instructors AFTER
INSERT ON instructor
FOR EACH ROW EXECUTE FUNCTION create_instructor();

-- Test data

INSERT INTO instructor (name, salary)
VALUES ('Maria',
        700);

-- Query tables

SELECT *
FROM instructor;


SELECT *
FROM log_instructors;

-- Function to drop trigger and function

CREATE FUNCTION internal_instructors(instructor_id INTEGER) RETURNS refcursor AS $$
    DECLARE
        salary_cursor refcursor;
    BEGIN
        OPEN salary_cursor FOR SELECT instructor.salary
                                    FROM instructor
                                 WHERE id <> instructor_id
                                    AND salary > 0;
        RETURN salary_cursor;
    END;
$$ LANGUAGE plpgsql;

-- Test function to get instructor salaries except the new one

CREATE FUNCTION create_instructor() RETURNS void AS $$
    DECLARE
        average_salary DECIMAL;
        instructors_earning_less INTEGER DEFAULT 0;
        total_instructors INTEGER DEFAULT 0;
        salary DECIMAL;
        percentage DECIMAL(5,2);
        salary_cursor refcursor;
    BEGIN
        SELECT AVG(instructor.salary) INTO average_salary FROM instructor WHERE id <> NEW.id;

        IF NEW.salary > average_salary THEN
            INSERT INTO instructor_log (information) VALUES (NEW.name || ' earns above average');
        END IF;

        SELECT internal_instructors(NEW.id) INTO salary_cursor;
        LOOP
            FETCH salary_cursor INTO salary;
            EXIT WHEN NOT FOUND;
            total_instructors := total_instructors + 1;

            IF NEW.salary > salary THEN
                instructors_earning_less := instructors_earning_less + 1;
            END IF;
        END LOOP;

        percentage = instructors_earning_less::DECIMAL / total_instructors::DECIMAL * 100;
        ASSERT percentage < 100::DECIMAL, 'new instructors cannot earn more than all previous instructors';

        INSERT INTO instructor_log (information, test)
            VALUES (NEW.name || ' earns more than ' || percentage || '% of the instructor pool','');

        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;


INSERT INTO instructor (name, salary)
VALUES ('John',
        6000);


SELECT *
FROM instructor;

-- Test data to check if the trigger is working properly
DO $$
    DECLARE
        cursor_salaries refcursor;
        salary DECIMAL;
        total_instructors INTEGER DEFAULT 0;
        instructor_receives_less INTEGER DEFAULT 0;
        percentage DECIMAL;
    BEGIN
        SELECT internal_instructors(12) INTO cursor_salaries;
        LOOP
            FETCH cursor_salaries INTO salary;
            EXIT WHEN NOT FOUND;
            total_instructors := total_instructors + 1;

            IF 600::DECIMAL > salary THEN
                instructor_receives_less := instructor_receives_less + 1;
            END IF;
        END LOOP;
        percentage = instructor_receives_less::DECIMAL / total_instructors::DECIMAL * 100;

        RAISE NOTICE 'Percentage: %', percentage;
     END;
$$;

-- Test data to check if the trigger is working properly with a percentage with two decimal places 
DO $$
    DECLARE
        cursor_salaries refcursor;
        salary DECIMAL;
        total_instructors INTEGER DEFAULT 0;
        instructor_receives_less INTEGER DEFAULT 0;
        percentage DECIMAL(5,2);
    BEGIN
        SELECT internal_instructors(12) INTO cursor_salaries;
        LOOP
            FETCH cursor_salaries INTO salary;
            EXIT WHEN NOT FOUND;
            total_instructors := total_instructors + 1;

            IF 600::DECIMAL > salary THEN
                instructor_receives_less := instructor_receives_less + 1;
            END IF;
        END LOOP;
        percentage = instructor_receives_less::DECIMAL / total_instructors::DECIMAL * 100;

        RAISE NOTICE 'Percentage: % %%', percentage;
     END;
$$;

