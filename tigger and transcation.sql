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



CREATE VIEW student_overview AS
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    subjects
FROM student;


CALL getStudentDetails(2);

CREATE VIEW student_summary AS
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    subjects
FROM student;

CREATE TABLE department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE marks (
    mark_id INT PRIMARY KEY,
    student_id INT,
    total_marks INT,
    FOREIGN KEY (student_id) REFERENCES student(student_id)
);


INSERT INTO department VALUES 
(1, 'Science'), (2, 'Commerce'), (3, 'Arts');

INSERT INTO marks VALUES 
(1, 1, 450),
(2, 2, 430),
(3, 3, 490);


CREATE VIEW student_full_details AS
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS full_name,
    s.subjects,
    d.dept_name,
    m.total_marks
FROM student s
JOIN department d ON s.subjects = d.dept_name
JOIN marks m ON s.student_id = m.student_id;


SELECT * FROM student_full_details;



CREATE TABLE student_log (
    student_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    subjects VARCHAR(50),
    deleted_at DATETIME
);

DELIMITER $$

CREATE TRIGGER after_student_delete
AFTER DELETE ON student
FOR EACH ROW
BEGIN
    INSERT INTO student_log (student_id, first_name, last_name, subjects, deleted_at)
    VALUES (OLD.student_id, OLD.first_name, OLD.last_name, OLD.subjects, NOW());
END $$

DELIMITER ;




SELECT * FROM student_log;

CREATE USER 'junior_user'@'localhost' IDENTIFIED BY 'password123';

GRANT SELECT ON student.* TO 'junior_user'@'localhost';

SHOW GRANTS FOR 'junior_user'@'localhost';


START TRANSACTION;

UPDATE marks SET total_marks = total_marks + 5 WHERE student_id = 1;
SAVEPOINT after_first_update;

UPDATE marks SET total_marks = total_marks - 10 WHERE student_id = 3;

ROLLBACK TO after_first_update;

COMMIT;
