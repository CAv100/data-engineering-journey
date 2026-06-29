-- Case Statements


select first_name, last_name, age,
case
	when age <= 30 then 'Young'
    when age between 31 and 50 then 'Old'
    when age >= 50 then 'On Deaths Door'
end  age_bracket
from employee_demographics
;

-- Pay Increase
-- < 50000 = +5%
-- > 50000 = +7%
-- Finance = +10% bonus


select first_name, last_name, salary,
case
	when salary < 50000 then salary + (salary * 0.05)
    when salary > 50000 then salary + (salary * 0.07)
end new_salary,
case
	when dept_id = 6 then salary * 0.1
end bonus
from employee_salary
;

select *
from parks_departments
;

select *
from employee_salary