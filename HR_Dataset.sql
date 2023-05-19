use projects;

select *
FROM hr;

-- checking data type
DESCRIBE hr;

-- Cleaning the Dataset

-- changing format of birthdate
UPDATE hr
set birthdate = CASE
	WHEN birthdate like "%-%" THEN DATE_FORMAT(str_to_date(birthdate,"%m-%d-%y"),"%Y-%m-%d")
    WHEN birthdate like "%/%" THEN DATE_FORMAT(str_to_date(birthdate,"%m/%d/%Y"),"%Y-%m-%d")
    else birthdate
    END;
    
-- after I update birthdate column some of the 2-digit years become over current date so i will fix them
UPDATE hr
SET birthdate = CASE
	WHEN birthdate >= CURDATE() THEN concat(year(birthdate)-100,substring(birthdate,5,6))
    ELSE birthdate
    END;

-- changing format of hire_date column
UPDATE hr
set hire_date = CASE
	WHEN hire_date like "%-%" THEN DATE_FORMAT(str_to_date(hire_date,"%m-%d-%y"),"%Y-%m-%d")
    WHEN hire_date like "%/%" THEN DATE_FORMAT(str_to_date(hire_date,"%m/%d/%Y"),"%Y-%m-%d")
    else hire_date
    END;
    
-- changing date format of termdate
UPDATE hr
SET termdate = DATE(STR_TO_DATE(termdate,"%Y-%m-%d %T UTC"))
WHERE termdate IS NOT NULL AND termdate != "";
   
   
-- modify data type of the birthdate column
alter table hr
MODIFY column birthdate DATE;


-- modify data type of the hire_date column
alter table hr
MODIFY column hire_date DATE;

-- modify data type of the termdate column
alter table hr
MODIFY column termdate DATE;

-- Creating Age column
ALTER TABLE hr ADD COLUMN age numeric;

UPDATE hr
SET age = YEAR(CURDATE())- YEAR(birthdate);



-- analyzing the Dataset 

-- What is the gender breakdown of employees in company?

SELECT gender , COUNT(gender)
FROM hr
GROUP BY gender;


-- What is the race breakdown in the company?

SELECT race, COUNT(race)
FROM hr
GROUP BY race;

-- What is the age distribution of employees?

SELECT (CASE 
	WHEN age <= 25 and age > 18 THEN "Young 18-25"
    WHEN age < 40 and age > 25 THEN "Middle Age: 25-40"
    ELSE "OLD: More than 40"
    END
) as age_group, 
COUNT(*)
from hr
GROUP BY age_group;



-- What is the average length of employment for employees who have been terminated ?

SELECT ROUND(AVG(YEAR(termdate)- YEAR(hire_date)),0) as average_year
FROM hr
WHERE termdate IS NOT NULL AND termdate != "" AND termdate < CURDATE();

-- What is the distribution of job titles across the company ?

select jobtitle, count(jobtitle) COUNT
from hr
WHERE termdate = ""
GROUP BY jobtitle;

-- how does the gender distribution vary across departments ?

SELECT department, gender, COUNT(*) count
FROM hr
WHERE termdate = ""
GROUP BY department , gender
ORDER BY department;

-- How is the job title distribution ?

SELECT jobtitle, COUNT(*)
FROM hr
WHERE termdate = ""
GROUP BY jobtitle;


-- What is the distribution of employees across location by city and state ?


SELECT	location_state, COUNT(*) count
FROM hr
GROUP BY location_state;




