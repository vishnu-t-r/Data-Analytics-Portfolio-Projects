--Question 5

use braintree;

/*
select top 10 * from [dbo].[continent_map]
select top 10 * from [dbo].[continents]
select top 10 * from [dbo].[countries]
select top 10 * from [dbo].[per_capita]
*/

--5. Find the sum of gpd_per_capita by year and the count of countries for each year that have non-null gdp_per_capita 
--where 
	--(i) the year is before 2012 and 
	--(ii) the country has a null gdp_per_capita in 2012. 
--Your result should have the columns:
	--year
	--country_count
	--total

--select * from per_capita


--case 1 :  the year is before 2012 

select year, sum(isnull(gdp_per_capita,0)) as total
		,sum(case when gdp_per_capita is null then 0
		else 1 end) as country_count
from per_capita
where year < 2012
group by year
order by year asc


--case 2 : the country has a null gdp_per_capita in 2012

select year, 
		round(sum(isnull(gdp_per_capita,0)),2) as total	
		,sum(1) as country_count
from per_capita
where country_code in 
(select country_code from per_capita
where year = 2012 and gdp_per_capita is null) 
group by year
order by year asc