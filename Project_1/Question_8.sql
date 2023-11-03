
--Question 8: 
--create a stored procedure to Calculate the average age of vehicles involved in accidents , 
--considering light conditions and point of impact as two varibale/inputs:


select * from accident
select * from vehicle

/*
-- example test procedure created
create procedure test_procedure
as
begin
select top 10 * from vehicle
order by agevehicle desc
end 

exec test_procedure
*/

create procedure vehicle_average_age
(@lightcondition varchar(100) = 'Daylight',
@pointofimpact varchar(100) = 'Offside')
as
begin

select avg(agevehicle)
from vehicle v
join accident a
on v.accidentindex = a.accidentindex
where v.pointimpact = @pointofimpact
and a.lightconditions = @lightcondition

end

/*
select * --distinct lightconditions
from accident
*/


exec vehicle_average_age 
exec vehicle_average_age 'Daylight','Offside'
exec vehicle_average_age 'Daylight'--,'Offside'

