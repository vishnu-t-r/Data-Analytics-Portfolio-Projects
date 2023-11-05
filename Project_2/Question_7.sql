--Question 7

use braintree;

/*
select top 10 * from [dbo].[continent_map]
select top 10 * from [dbo].[continents]
select top 10 * from [dbo].[countries]
select top 10 * from [dbo].[per_capita]
*/

--7. Find the country with the highest average gdp_per_capita for each continent for all years. 
	--Now compare your list to the following data set. 
	--Please describe any and all mistakes that you can find with the data set below. 
	--Include any code that you use to help detect these mistakes.
with table1 as
(
select pc.country_code,
		continent_code,
		avg(isnull(gdp_per_capita,0)) as average_gdp
from per_capita pc
join continent_map contmap on pc.country_code = contmap.country_code
group by pc.country_code, continent_code
),
table2 as
(
select *,
	rank() over(partition by continent_code order by average_gdp desc) as rank_gdp
from table1
)
select  rank_gdp as [rank]
		,cont.continent_name
		,cntry.country_code
		,cntry.country_name
		,round(table2.average_gdp,2) as average_gdp_per_capita
from table2
join continents cont on table2.continent_code = cont.continent_code
join countries cntry on table2.country_code = cntry.country_code
where rank_gdp = 1