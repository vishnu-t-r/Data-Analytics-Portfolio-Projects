--simple portfolio project
--25 queries answered on a employee database

use int_ques;

select * from employeeinfo

select * from employeeposition

--Write a query to fetch the EmpFname from the EmployeeInfo table in upper case and use the ALIAS name as EmpName.

select upper(EmpFname) AS EmpName from EmployeeInfo

--Write a query to fetch the number of employees working in the department ‘HR’.

select count(*) as employee_count from EmployeeInfo
where department = 'HR'

--Write a query to get the current date.

select getdate() as current_datetime

select sysdatetime() as current_datetime

--Write a query to retrieve the first four characters of  EmpLname from the EmployeeInfo table.

select EmpLname,
		substring(EmpLname,1,4) as Lname_4
from EmployeeInfo

--Write a query to fetch only the place name(string before brackets) from the Address column of EmployeeInfo table.

select EmpFname,
		Address,
		substring(Address,1,charindex('(',Address)-1) as place_name
from EmployeeInfo

--Write a query to create a new table which consists of data and structure copied from the EmployeeInfo table.

select * 
into test_table
from EmployeeInfo

select * from test_table

--Write a query to find all the employees whose salary is between 50000 to 100000.

select * from EmployeePosition
where salary between 50000 and 100000

--Write a query to find the names of employees that begin with ‘S’

select * from EmployeeInfo
where EmpFname like 'S%'

--Write a query to fetch top N records.

select top 2 * from EmployeeInfo

--Write a query to retrieve the EmpFname and EmpLname in a single column as “FullName”. 
--The first name and the last name must be separated with space.

select EmpFname,
		EmpLname,
		concat(EmpFname,' ',EmpLname) as EmpName
from EmployeeInfo

--Write a query find number of employees whose DOB is between 02/05/1965 to 31/12/1980 and are grouped according to gender

select gender, count(*) as employee_num
from employeeinfo
where dob between '1965-05-02' and '1980-12-31'
group by gender

--Write a query to fetch all the records from the EmployeeInfo table 
--ordered by EmpLname in descending order and Department in the ascending order.

select * from employeeinfo
order by emplname desc, department asc

--Write a query to fetch details of employees whose EmpLname ends with an alphabet ‘A’ and contains five alphabets.

select * from employeeinfo
where emplname like '____a'

--Write a query to fetch details of all employees 
--excluding the employees with first names, “Sanjay” and “Sonia” from the EmployeeInfo table.

select * from employeeinfo
where empfname not in ('Sanjay','Sonia')

--Write a query to fetch details of employees with the address code as “DEL”

select * from employeeinfo
where address like '%DEL%'

-- Write a query to fetch all employees who also hold the managerial position.

select * from employeeinfo
where empid in (select empid from employeeposition where EmpPosition = 'manager')

--Write a query to fetch the department-wise count of employees sorted by department’s count in ascending order.

select department, count(*) as employee_count
from employeeinfo
group by department
order by employee_count asc

--Write a query to show the even and odd records from a table.

--even ids
select * from employeeinfo
where empid%2 = 0

--odd ids
select * from employeeinfo
where empid%2 <> 0

--Write a SQL query to retrieve employee details from EmployeeInfo table who have a date of joining in the EmployeePosition table.

select * from employeeinfo
where exists (select empid from employeeposition 
				where employeeposition.EmpID = employeeinfo.EmpID)

--Write a query to retrieve two maximum salaries from the EmployeePosition table.

select top 2 salary from employeeposition
order by salary desc

--Write a query to find the Nth highest salary from the table without using TOP/limit keyword.

select salary
from
(
select salary, rank() over(order by salary desc) as salary_rank
from employeeposition
)a
where salary_rank = 2

--Write a query to retrieve duplicate records from a employeeinfo table.

select empfname, emplname, department, count(*) as n
from employeeinfo
group by empfname, emplname, department
having count(*) > 1

--write a query to add a new email column in the employeeinfo table

alter table employeeinfo
add email varchar(20) null;

select * from employeeinfo

--add email to the new column such that email is 'fisrtname_empid@email.com'

update employeeinfo
set email = concat(empfname,'_',empid,'@','email.com')

select * from employeeinfo

--Write a query to fetch first 20% records from the EmployeeInfo table.

select * from employeeinfo
where empid <= (select count(*)/5 from employeeinfo)


