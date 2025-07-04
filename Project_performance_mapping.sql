# 1. Create a database named employee
create schema employee ;

/* 3.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, 
and make a list of employees and details of their department. */

SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
FROM
    emp_record_table;

/* 4. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
*/
-- ●	less than two --
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

/* 5.	Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department 
from the employee table and then give the resultant column alias as NAME. */

SELECT 
    CONCAT(FIRST_NAME, ' ', LAST_NAME) AS 'NAME', DEPT
FROM
    emp_record_table
WHERE
    DEPT = 'FINANCE';

/*6. Write a query to list only those employees who have someone reporting to them. 
Also, show the number of reporters (including the President).*/

SELECT 
    e.MANAGER_ID AS 'EMP_ID',
    COUNT(e.EMP_ID) AS 'no_of_reporters'
FROM
    emp_record_table AS e
        INNER JOIN
    emp_record_table AS m ON e.EMP_ID = m.EMP_ID
GROUP BY 1
ORDER BY 2 DESC;

/*7. Write a query to list down all the employees from the healthcare and finance departments using union. 
Take data from the employee record table.*/

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

/* 8. Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and 
EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating for the department. */

select e.EMP_ID, e.FIRST_NAME, e.LAST_NAME, e.ROLE, e.DEPT, e.EMP_RATING, 
max(e.EMP_RATING) over(partition by e.DEPT) as 'max_emp_rating'
from emp_record_table as e
order by e.DEPT, e.EMP_RATING desc;

/*9. Write a query to calculate the minimum and the maximum salary of the employees in each role. 
Take data from the employee record table. */

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

/*11. Write a query to create a view that displays employees in various countries whose salary is more than six thousand. 
Take data from the employee record table. */

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

/* 13. Write a query to create a stored procedure to retrieve the details of the employees 
whose experience is more than three years. Take data from the employee record table.*/

DELIMITER &
CREATE procedure GetExperiencedEmp()
begin
SELECT * FROM emp_record_table where EXP > 3 ORDER BY EXP;
END &
DELIMITER ;

CALL GetExperiencedEmp;

/* 14.	Write a query using stored functions in the project table to check 
whether the job profile assigned to each employee in the data science team matches the organization’s set standard.

The standard being:
For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
For an employee with the experience of 12 to 16 years assign 'MANAGER'. */

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


/* 15. Create an index to improve the cost and performance of the query to find the employee 
whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan. */

create index IDX_empfirst_name ON emp_record_table(FIRST_NAME(50));

SELECT * FROM emp_record_table WHERE FIRST_NAME = 'Eric';

/* 16. Write a query to calculate the bonus for all the employees, 
based on their ratings and salaries (Use the formula: 5% of salary * employee rating).*/

SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, SALARY, EMP_RATING, 
((SALARY*0.05) * EMP_RATING) AS 'Bonus' 
FROM emp_record_table;

/*17. Write a query to calculate the average salary distribution based on the continent and country.
 Take data from the employee record table.*/
 
SELECT CONTINENT, COUNTRY, AVG(SALARY) as 'AVG_SALARY' FROM emp_record_table
group by 1, 2
order by 1, 2;




