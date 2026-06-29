select es1.employee_id es_Santa, 
es1.first_name First_name_santa, 
es1.last_name Last_name_santa,
es2.employee_id es_santa,
es2.first_name First_name,
es2.last_name Last_name
from employee_salary es1
join employee_salary es2
	on es1.employee_id + 1 = es2.employee_id
  ;  
    
-- Union --

select first_name, last_name
from employee_demographics
union all
select first_name, last_name
from employee_salary
;

select first_name, last_name, "Old man" Label
from employee_demographics
where age > 40 and gender = "Male"
union
select first_name, last_name, "Old woman" Label
from employee_demographics
where age > 40 and gender = "Female"
union all
select first_name, last_name, "Overpaid" Label
from employee_salary
where salary > 70000
order by first_name, last_name
;