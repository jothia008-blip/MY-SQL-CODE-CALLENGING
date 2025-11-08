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



