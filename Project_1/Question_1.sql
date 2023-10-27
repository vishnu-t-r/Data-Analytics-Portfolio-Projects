
--Question 1
--How many accidents have occurred in urban areas versus rural areas?

select area, count(*) as accident_count
from accident
group by area

select (select count(*) from accident where area = 'Urban') as Urban_Accident,
		(select count(*) from accident where area = 'Rural') as Rural_Accident

