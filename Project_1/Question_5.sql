
--Question 5: 
--Are there any specific weather conditions that contribute to severe accidents?
--severe accidents are accidents which belongs to 'fatal' and 'serious' severity

select * from accident
select * from vehicle

select weatherconditions, count(*) as accident_count
from accident
group by weatherconditions
order by accident_count desc


with t1 as (
select weatherconditions,severity, count(*) as accident_count
from accident
group by weatherconditions, severity
--order by accident_count, severity desc
),
t2 as
(
select * from 
(select * from t1) t
pivot (sum(accident_count)
	for severity in ([Fatal],[Serious],[Slight]))as b
)
select t2.*,
	(isnull(fatal,0)+isnull(serious,0)) as severe_accidents
from t2

--select distinct severity from accident
