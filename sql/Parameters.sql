-- Parameters


delimiter $$
create procedure large_salaries3(number_id int)
begin
	select salary
	from employee_salary
	where employee_id = number_id
    ;
end $$
delimiter ;

call large_salaries3(2)