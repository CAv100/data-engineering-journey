-- Stored Procedures

select *
from employee_salary
;

select *
from employee_salary
where salary >= 50000
;

create procedure large_salaries()
select *
from employee_salary
where salary >= 50000
;

delimiter $$
create procedure large_salaries2()
begin
	select *
	from employee_salary
	where salary >= 50000;
	select * 
	from employee_salary
	where salary >= 10000;
end $$
delimiter ;

call large_salaries()
;

call large_salaries2()
;

