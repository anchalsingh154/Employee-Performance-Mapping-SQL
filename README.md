📊 Employee Performance Mapping – SQL Project

🔹 Problem Scenario

ScienceQtech, a startup in the Data Science domain, required analysis of its employee database for HR performance mapping. As part of the HR appraisal cycle, managers provided ratings for employees, and the HR team requested insights into:

Employee details (department, roles, experience)
Salary analysis (min, max, bonuses)
Performance mapping based on ratings
Validation of job profiles against organizational standards
Country- and continent-wise salary distribution
The goal was to help HR finalize performance appraisals, calculate training needs, and estimate bonus payouts.

🔹 Objectives

Generate employee reports for HR decision-making.
Analyze maximum salary, role-wise pay distribution, and bonus allocation.
Validate employee job roles based on experience standards.
Create views, stored procedures, and functions for reusable queries.
Optimize queries using indexes for faster execution.

🔹 SQL Concepts Used

✔ Database & Schema creation
✔ SELECT queries with filters (WHERE, BETWEEN)
✔ Joins and Unions
✔ Grouping and Aggregations (MIN, MAX, AVG)
✔ Window Functions (DENSE_RANK, MAX OVER)
✔ Views, Stored Procedures, Functions
✔ Indexing for query optimization

🔹 Key Queries & Insights

Employee Reports → Fetch employee details by department.
Performance Analysis → Identify employees with ratings <2, >4, and 2-4.
Concatenated Names → Combine first and last names in Finance dept.
Job Profile Validation → Compare actual vs expected roles based on experience.
Salary Analysis → Min/Max salaries per role, average by continent/country.
Bonuses → Calculate bonus = 5% of salary × rating.

Indexing → Improve search performance for employee names.

🔹 Tech Stack

SQL (MySQL)

Employee Database (simulated dataset)

🔹 How to Run

Clone the repo:

git clone https://github.com/anchalsingh154/Employee-Performance-Mapping-SQL-Project.git
cd Employee-Performance-Mapping-SQL-Project


Open Project_performance_mapping.sql in MySQL Workbench or any SQL IDE.

Run queries step by step to explore insights.
