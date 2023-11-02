
--Question 7: 
--Are there any relationships between journey purposes and the severity of accidents?

select * from accident
select * from vehicle

select * from
(
select a.severity,
		v.journeypurpose,
		count(a.accidentindex) as accident_count
from accident a
left join
vehicle v on a.accidentindex = v.accidentindex
group by a.severity,
		v.journeypurpose
) a
pivot (sum(accident_count)
	for severity in ([Fatal],[Serious],[Slight])
	)as b

