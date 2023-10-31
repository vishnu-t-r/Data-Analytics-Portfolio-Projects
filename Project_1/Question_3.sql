
--Question 3: 
--What is the average age of vehicles involved in accidents based on their type?

select vehicletype, avg(agevehicle) as n
from vehicle 
group by vehicletype

--ALTER TABLE Statement
--alter the datatype of vehicle age column
alter table vehicle
alter column agevehicle int;

with t1 as
(
select vehicletype, avg(agevehicle) as n
from vehicle 
group by vehicletype
)
select * from vehicle 
where vehicletype in (select vehicletype from t1 where n is null)--'Van / Goods 3.5 tonnes'--'Tram'
order by vehicletype

select vehicletype, avg(isnull(agevehicle,0)) as avg_vehicle_age
from vehicle 
group by vehicletype

