--Question 2

use braintree;

---Create a SQL database using CSV files

/*
select top 10 * from [dbo].[continent_map]
select top 10 * from [dbo].[continents]
select top 10 * from [dbo].[countries]
select top 10 * from [dbo].[per_capita]
*/

--2. List the countries ranked 10-12 in each continent by the percent of year-over-year growth descending from 2011 to 2012.
--The percent of growth should be calculated as: ((2012 gdp - 2011 gdp) / 2011 gdp)

--The list should include the columns:
	--rank
	--continent_name
	--country_code
	--country_name
	--growth_percent

with table1 as
(
select * from
(
select pc.* 
		,cm.continent_code
from [dbo].[per_capita] pc
join [dbo].[continent_map] cm
on pc.country_code = cm.country_code
where year in (2011,2012)
) a
pivot(sum(gdp_per_capita) 
		for year in ([2011],[2012])) b
),
table2 as
(
--((2012 gdp - 2011 gdp) / 2011 gdp)
select country_code,
		continent_code,
		[2011] as [2011_gdp],
		[2012] as [2012_gdp],
		round(((isnull([2012],0) - isnull([2011],0))/nullif([2011],0))*100,2) as growth_percent
from table1
),
table3 as
(
select continent_code,
		country_code,
		growth_percent,
		rank() over(partition by continent_code order by growth_percent asc) as growth_rank
from table2	
)
select --t3.continent_code,
		cont.continent_name,
		t3.country_code,
		cntry.country_name,
		concat(growth_percent,'%') as growth_percent,
		growth_rank as rank
from table3 t3
join continents cont on cont.continent_code = t3.continent_code
join countries cntry on cntry.country_code = t3.country_code
where growth_rank in (10,11,12)