# Created a database named employee
create schema employee ;

-- Purpose: Retrieve employee details along with department information
-- Tables Used: employee_record
-- Columns: EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT

SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
FROM
    emp_record_table;

-- Query: Retrieve Employees with Low Performance Ratings
-- Description: Fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING 
--              for employees whose EMP_RATING is less than 2.

SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM
    emp_record_table
WHERE
    EMP_RATING < 2;
    
-- ●	greater than four --
SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM
    emp_record_table
WHERE
    EMP_RATING > 4;

-- ●	between two and four --
SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM
    emp_record_table
WHERE
    EMP_RATING BETWEEN 2 AND 4;

-- Query: Full Name of Employees in Finance Department
-- Description: Concatenate FIRST_NAME and LAST_NAME of employees 
--   		from the 'Finance' department and alias the result as 'NAME'.

SELECT 
    CONCAT(FIRST_NAME, ' ', LAST_NAME) AS 'NAME', DEPT
FROM
    emp_record_table
WHERE
    DEPT = 'FINANCE';

-- Query: List Employees Who Have Reporters
-- Description: Identify employees who have subordinates (direct reports),
--              including the President, and display the count of reporters.
-- Assumption: EMPLOYEE_ID and MANAGER_ID columns exist in employee_record table.

SELECT 
    e.MANAGER_ID AS 'EMP_ID',
    COUNT(e.EMP_ID) AS 'no_of_reporters'
FROM
    emp_record_table AS e
        INNER JOIN
    emp_record_table AS m ON e.EMP_ID = m.EMP_ID
GROUP BY 1
ORDER BY 2 DESC;

-- Query: Employees from Healthcare and Finance Departments
-- Description: Retrieve a list of employees working in either the 
--              Healthcare or Finance departments using UNION.
-- Table Used: employee_record

SELECT 
    *
FROM
    emp_record_table
WHERE
    DEPT = 'FINANCE' 
UNION SELECT 
    *
FROM
    emp_record_table
WHERE
    DEPT = 'HEALTHCARE';

-- Query: Employee Details with Department-Wise Max Rating
-- Description: List EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, EMP_RATING,
--              and the MAX EMP_RATING within the same department.
-- Table Used: employee_record

select e.EMP_ID, e.FIRST_NAME, e.LAST_NAME, e.ROLE, e.DEPT, e.EMP_RATING, 
max(e.EMP_RATING) over(partition by e.DEPT) as 'max_emp_rating'
from emp_record_table as e
order by e.DEPT, e.EMP_RATING desc;

-- Query: Minimum and Maximum Salary by Role
-- Description: Calculate the lowest and highest salary for each distinct role
--              in the employee_record table.
-- Table Used: employee_record

SELECT 
    ROLE,
    MIN(SALARY) AS 'min_salary',
    MAX(SALARY) AS 'max_salary'
FROM
    emp_record_table
GROUP BY 1;

#10. Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.

select EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EXP,
dense_rank() over(order by EXP desc) as 'emp_rank'
from emp_record_table
order by emp_rank;

-- View: high_salary_employees_by_country
-- Description: Create a view to list employees from different countries 
--              where the SALARY is greater than 6000.
-- Table Used: employee_record

CREATE VIEW high_salary_emp AS
    SELECT 
        *
    FROM
        emp_record_table
    WHERE
        SALARY > 6000;
        
select * from high_salary_emp ;

#12. Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.

SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, ROLE, EXP
FROM
    emp_record_table
WHERE
    EXP > 10;

-- Procedure: get_employees_with_experience
-- Description: Create a stored procedure to retrieve all employee details
--              for those with more than 3 years of experience.
-- Table Used: employee_record

DELIMITER &
CREATE procedure GetExperiencedEmp()
begin
SELECT * FROM emp_record_table where EXP > 3 ORDER BY EXP;
END &
DELIMITER ;

CALL GetExperiencedEmp;

-- ============================================================
-- Task: Validate Job Profiles for Data Science Team
-- Description: Create a stored function to return the standard job profile 
--              based on experience levels. Then, compare it with the actual 
--              assigned roles of employees in the Data Science department 
--              to check for any mismatches.
-- 
-- Standard Role Mapping:
-- • Experience ≤ 2 years           → JUNIOR DATA SCIENTIST
-- • Experience > 2 and ≤ 5 years  → ASSOCIATE DATA SCIENTIST
-- • Experience > 5 and ≤ 10 years → SENIOR DATA SCIENTIST
-- • Experience > 10 and ≤ 12 years→ LEAD DATA SCIENTIST
-- • Experience > 12 and ≤ 16 years→ MANAGER
--
-- Tables Involved: employee_record, project
-- Output: EMP_ID, NAME, EXPERIENCE, ASSIGNED ROLE, EXPECTED ROLE, MATCH STATUS
--

DELIMITER &&
CREATE function Get_Job_Profile(
	experience int
)
RETURNS varchar(30)
DETERMINISTIC
begin
	declare job_profile varchar(30) default '';
    
    IF experience <= 2 then SET job_profile = 'JUNIOR DATA SCIENTIST';
    elseif experience between 2 and 5 then SET job_profile = 'ASSOCIATE DATA SCIENTIST';
    elseif experience between 5 and 10 then SET job_profile = 'SENIOR DATA SCIENTIST';
    elseif experience between 10 and 12 then SET job_profile = 'LEAD DATA SCIENTIST';
	elseif xperience BETWEEN 12 AND 16 then SET job_profile = 'MANAGER';
    else SET job_profile = 'UNKNOWN';
    end if;
return (job_profile);
end &&
DELIMITER ;

SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP, ROLE, 
lower(Get_Job_Profile(EXP)) AS Expected_job_profile,
case 
when ROLE = Get_Job_Profile(EXP) then 'match' ELSE 'MISMATCH'
end as STATUS
from data_science_team;


-- Task: Performance Optimization with Index
-- Description: Create an index on the FIRST_NAME column in the employee_record table 
--              to optimize query performance when searching for employees named 'Eric'.
-- Objective: Improve query execution cost based on EXPLAIN plan analysis.
-- Table Affected: employee_record
-- Index Target: FIRST_NAME

create index IDX_empfirst_name ON emp_record_table(FIRST_NAME(50));

SELECT * FROM emp_record_table WHERE FIRST_NAME = 'Eric';

-- Task: Calculate Employee Bonus Based on Rating and Salary
-- Description: Compute the bonus for all employees using the formula:
--              Bonus = 5% of SALARY × EMP_RATING
-- Objective: Derive a new column that reflects performance-based incentives.
-- Table Used: employee_record
-- Columns Used: SALARY, EMP_RATING
-- Output: EMP_ID, FIRST_NAME, LAST_NAME, SALARY, EMP_RATING, BONUS

SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, SALARY, EMP_RATING, 
((SALARY*0.05) * EMP_RATING) AS 'Bonus' 
FROM emp_record_table;

-- Task: Calculate Average Salary Distribution by Continent and Country
-- Description: Analyze salary patterns by computing the average salary 
--              grouped by both CONTINENT and COUNTRY.
-- Objective: Identify geographic salary trends to support compensation planning.
-- Table Used: employee_record
-- Columns Used: CONTINENT, COUNTRY, SALARY
-- Output: CONTINENT, COUNTRY, AVERAGE_SALARY
 
SELECT CONTINENT, COUNTRY, AVG(SALARY) as 'AVG_SALARY' FROM emp_record_table
group by 1, 2
order by 1, 2;




