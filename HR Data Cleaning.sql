-- Database Creation
CREATE DATABASE hr_projects;

USE hr_projects;

SELECT * FROM hr;

-- Data Cleaning

-- Rename id column to emp_id
ALTER TABLE hr
CHANGE COLUMN id emp_id VARCHAR(20) NULL;

-- Check data types of all columns
DESCRIBE hr;

SELECT birthdate from hr;

SET sql_safe_updates = 0;  -- to turn off sql safe update feature Error code - 1175

-- Change birthdate values to date
UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate,'%d-%m-%Y'),'%Y-%m-%d')
    ELSE NULL
END;

-- Change birthdate column datatype
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

-- Convert hire_date values to date
UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date,'%d-%m-%Y'),'%Y-%m-%d')
    ELSE NULL
END;

-- Change hire_date column data type
ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

-- Convert termdate values to date and remove time
UPDATE hr
SET termdate = DATE(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate != ' ';

-- Convert termdate column to date
ALTER TABLE hr
MODIFY COLUMN termdate DATE;

SELECT * FROM hr;

-- Add age column
ALTER TABLE hr ADD COLUMN age INT;
UPDATE hr
SET age = timestampdiff(Year, birthdate, curdate());

SELECT 
	MIN(age) as youngest,
    MAX(age) oldest
FROM hr;

SELECT count(*) FROM hr where age < 18;                -- Check for negative ages
SELECT count(*) FROM hr WHERE termdate > curdate();    -- Check Termdates in the future