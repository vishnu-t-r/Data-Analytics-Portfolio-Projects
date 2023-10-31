
--Question 4: 
--Can we identify any trends in accidents based on the age of vehicles involved?


--compare the age of vehicle involved and number of accidents
--consider as a hisogram

select * from accident
select * from vehicle

select isnull(agevehicle,0) as vehicle_age, count(*) as accident_count
from vehicle
group by agevehicle
order by agevehicle asc

