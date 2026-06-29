-- Temporary Table

create temporary table Temp_table
(first_name varchar(100),
last_name varchar(100),
favourite_movie varchar(100)
)
;

insert into Temp_table values
("Alex", "Freberg", "The Lord of the Rings")
;

select * 
from Temp_table
;

select * 
from employee_salary
;

create temporary table	salary_over_50k
select * 
from employee_salary
where salary > 50000
;

select * 
from salary_over_50k
;