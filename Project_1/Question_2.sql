
--Question 2: 
--Which day of the week has the highest number of accidents?

select top 1 day,count(*) as accident_count
from accident
group by day 
order by accident_count desc


select top 1 DATENAME(weekday,date) as week_day ,count(*) as accident_count
from accident
group by DATENAME(weekday,date)
order by accident_count desc
