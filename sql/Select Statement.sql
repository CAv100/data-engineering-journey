SELECT * 
FROM portfolio_projects_sql.employee_demographics;

SELECT first_name, last_name, birth_date, age, (age + 10) * 10 as new_age
FROM portfolio_projects_sql.employee_demographics;
# PEMDAS: Parentheses, Exponent, Multoplication, Division, Addition, and Subtraction
#This is the order at which arithmetic operations a carried out in SQL

SELECT  first_name, gender
FROM portfolio_projects_sql.employee_demographics;