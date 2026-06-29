-- String Functions

select length("skyfall");

select first_name, length(first_name)
from employee_demographics
;

select upper("sky");
select lower("sky");
select proper("sky");

select first_name, replace(first_name, "A", "z")
from employee_demographics;
select first_name, substring(first_name, 3,2)
from employee_demographics
;
select locate('x', 'Alexander');

select first_name, locate('An', first_name)
from employee_demographics
;
select first_name, last_name,
concat(first_name, ' ', last_name) full_name
from employee_demographics
;