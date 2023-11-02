
--Question 6: 
--Do accidents often involve impacts on the left-hand side of vehicles?


select * from accident
select * from vehicle

with t1 as
(
select lefthand, count(*) as accident_count from vehicle
where lefthand is not null
group by lefthand
)
select t1.*,
		round((convert(float,(t1.accident_count))*100/sum(accident_count) over()),2) as total
from t1
