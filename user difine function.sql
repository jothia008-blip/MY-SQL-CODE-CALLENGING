CREATE DATABASE students_list;

USE students_list;

CREATE TABLE  student (
student_id INT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
subjects VARCHAR(50)
);

INSERT INTO student ( student_id,first_name,last_name,subjects ) values
(1,'sanjay','kumar','math'),
(2,'hari','dhass','science'),
(3,'mani','muthu','english'),
(4,'devi','priya','social'),
(5,'anbu','arasu','tamil');

SELECT
    student_id,
    UPPER(first_name) AS upper_case_name,
    LOWER(last_name) AS lower_case_name,
    SUBSTRING(first_name, 1, 3) AS short_name,
    CONCAT(
        UPPER(LEFT(first_name, 1)), LOWER(SUBSTRING(first_name, 2)), ' ',
        UPPER(LEFT(last_name, 1)), LOWER(SUBSTRING(last_name, 2))
    ) AS formatted_full_name
FROM student;

ALTER TABLE student
ADD admission_date DATE;


SET SQL_SAFE_UPDATES = 0;

UPDATE student
SET admission_date = CASE student_id
    WHEN 1 THEN '2021-06-10'
    WHEN 2 THEN '2022-01-15'
    WHEN 3 THEN '2023-07-01'
    WHEN 4 THEN '2023-03-25'
    WHEN 5 THEN '2024-02-10'
END;


SELECT * fROM student;


SELECT
    student_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    admission_date,
    YEAR(admission_date) AS joining_year,
    DATEDIFF(NOW(), admission_date) AS days_since_admission,
    ROUND(DATEDIFF(NOW(), admission_date) / 365, 1) AS years_since_admission
FROM student;

USE students_list;


DELIMITER $$

CREATE FUNCTION getFullName (first_name VARCHAR(50), last_name VARCHAR(50))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE full_name VARCHAR(100);
    SET full_name = CONCAT(first_name, ' ', last_name);
    RETURN full_name;
END$$

DELIMITER ;

SELECT getFullName('Sanjay', 'Kumar');


DELIMITER $$

CREATE PROCEDURE getStudentDetails(IN sid INT)
BEGIN
    SELECT 
        student_id, 
        CONCAT(first_name, ' ', last_name) AS full_name,
        subjects,
        admission_date
    FROM student
    WHERE student_id = sid;
END $$

DELIMITER ;



