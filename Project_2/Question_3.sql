--Question 3

use braintree;

/*
select top 10 * from [dbo].[continent_map]
select top 10 * from [dbo].[continents]
select top 10 * from [dbo].[countries]
select top 10 * from [dbo].[per_capita]
*/

--3. For the year 2012, create a 3 column, 1 row report showing the percent share of gdp_per_capita for the following regions:

--(i) Asia, (ii) Europe, (iii) the Rest of the World. 
--Result should look something like
	-- |Asia	|	Europe	|	Rest of World	|
	-- |25.0%	|	25.0%	|	50.0%			|

with table1 as
(
select percap.country_code,
	percap.year,
	percap.gdp_per_capita,
	cont.continent_code,
	cont.continent_name
from per_capita percap
join [continent_map] contmap on contmap.country_code = percap.country_code
join [continents] cont on cont.continent_code = contmap.continent_code
where percap.year = 2012
),
table2 as
(
select *,
	case when continent_name in ('Asia','Europe') then continent_name
			else 'Rest of World' end as new_continent_group
from table1
),
table3 as
(
select distinct new_continent_group,
		sum(isnull(gdp_per_capita,0)) over(partition by new_continent_group) as total_gdp,
		sum(isnull(gdp_per_capita,0)) over() as total,
		(sum(isnull(gdp_per_capita,0)) over(partition by new_continent_group))/(sum(isnull(gdp_per_capita,0)) over()) as fraction_gdp,
		round((((sum(isnull(gdp_per_capita,0)) over(partition by new_continent_group))/(sum(isnull(gdp_per_capita,0)) over()))*100),0) as percent_gdp
from table2
),
table4 as
(
select *
from
(
select new_continent_group,percent_gdp from table3
) a
pivot (sum(percent_gdp) for new_continent_group in ([Asia],[Europe],[Rest of World]) ) b
)

select concat(Asia,'%') as Asia,
		concat(Europe, '%') as Europe,
		concat([Rest of World], '%') as [Rest of World]
from table4
