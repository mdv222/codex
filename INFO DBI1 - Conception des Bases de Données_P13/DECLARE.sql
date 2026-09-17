DECLARE 

cursor cursor_emp is
select Last_name, First_name, Departmentname
from join Employee,Location
where Hire_date>=1998 and Departmentname = 'Washington'

