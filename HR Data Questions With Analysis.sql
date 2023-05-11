USE hr_projects;

SELECT * FROM hr;

-- QUESTIONS

-- 1. What is the gender breakdown of the employees in the company?
SELECT gender, COUNT(*) as gender_count from hr
where age >= 18 and termdate = '0000-00-00'
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, count(*) count_race from hr
where age >= 18 and termdate = '0000-00-00'
GROUP BY race
ORDER BY COUNT(*) DESC;

-- 3. What is the age ditribution of the employees in the company?
SELECT
	min(age) youngest,
    max(age) oldest
from hr
where age >= 18 and termdate = '0000-00-00';

SELECT
	CASE 
		WHEN age >= 18 and age <= 24 THEN '18-24'
        WHEN age >= 25 and age <= 34 THEN '25-34'
        WHEN age >= 35 and age <= 44 THEN '35-44'
        WHEN age >= 45 and age <= 54 THEN '45-54'
        WHEN age >= 55 and age <= 64 THEN '55-64'
        ELSE '65+'
	END as age_group, count(*) age_count
from hr
where age >= 18 and termdate = '0000-00-00'
GROUP BY age_group
ORDER BY age_group;

SELECT
	CASE 
		WHEN age >= 18 and age <= 24 THEN '18-24'
        WHEN age >= 25 and age <= 34 THEN '25-34'
        WHEN age >= 35 and age <= 44 THEN '35-44'
        WHEN age >= 45 and age <= 54 THEN '45-54'
        WHEN age >= 55 and age <= 64 THEN '55-64'
        ELSE '65+'
	END as age_group, gender, count(*) age_count
from hr
where age >= 18 and termdate = '0000-00-00'
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. How many employees work at headquarters vs remote locations?
select location, count(*) count_location
from hr
where age >= 18 and termdate = '0000-00-00'
GROUP BY location;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT 
	round(avg(datediff(termdate,hire_date))/365,0) as avg_len_employee
FROM hr
WHERE termdate <= curdate() and termdate != '0000-00-00' and age >= 18;

-- 6. How does the gender distribution vary across departments and job titles?
SELECT department, gender, count(*) count_gender_depart
from hr
where age >= 18 and termdate = '0000-00-00'
GROUP BY department, gender
ORDER BY department;

SELECT jobtitle, gender, count(*) count_gender_jobtitle
from hr
where age >= 18 and termdate = '0000-00-00'
GROUP BY jobtitle, gender
ORDER BY jobtitle;

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle, count(*) count_jobtitle
from hr
where age >= 18 and termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. Which department has the highest turnover rate?
SELECT department,
	total_count,
    terminated_count,
    terminated_count / total_count as termination_rate
FROM (
	SELECT department,
		count(*) as total_count,
        sum(CASE WHEN termdate != '0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminated_count
	from hr
    where age >= 18
    group by department
    ) as subquery
order by termination_rate desc;

-- 9. What is the distribution of employees across locations by city and state?
SELECT location_city, count(*) city_count
FROM hr
where age >= 18 and termdate = '0000-00-00'
GROUP BY location_city
ORDER BY location_city;

SELECT location_state, count(*) state_count
FROM hr
where age >= 18 and termdate = '0000-00-00'
GROUP BY location_state
ORDER BY location_state;

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT 
	year,
    hires,
    terminations,
    hires - terminations as net_change,
    round(((hires - terminations) / hires) * 100,2) as net_change_percent
FROM (
	SELECT 
		year(hire_date) as year,
        count(*) as hires,
        sum( case when termdate != '0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminations
	FROM hr
    where age >= 18
    GROUP BY year(hire_date)
    ) as subquery
ORDER BY year ASC;

-- 11. What is the tenure distribution for each department?
SELECT department, round(AVG(datediff(termdate,hire_date)/365),0) as avg_tenure
from hr
where termdate <= curdate() and termdate != '0000-00-00' and age >= 18
GROUP BY department;

