select *
from employee_salary
where first_name = "Leslie"
;

select *
from employee_salary
where salary > 50000
;

select *
from employee_salary
where salary >= 50000
;

select *
from employee_salary
where salary < 50000
;

select *
from employee_salary
where salary <= 50000
;

select *
from employee_demographics
where gender = "Female"
;

select *
from employee_demographics
where gender != "Female"
;
select *
from employee_demographics
where birth_date > "1985-01-01"
;

-- and or not -- Logical Operators

select *
from employee_demographics
where gender = "Female"
and birth_date > "1985-01-01"
;

select *
from employee_demographics
where birth_date > "1985-01-01"
or not gender = "Male"
;

select *
from employee_demographics
where birth_date > "1985-01-01"
;

select *
from employee_demographics
where (first_name = "Leslie" and age = 44) or age >55
;

-- Like Statement --
-- % and _ --
select *
from employee_demographics
where first_name  like "jer%"
;