--Question 4


use braintree;

/*
select top 10 * from [dbo].[continent_map]
select top 10 * from [dbo].[continents]
select top 10 * from [dbo].[countries]
select top 10 * from [dbo].[per_capita]
*/

--4a. What is the count of countries and sum of their related gdp_per_capita values for the year 2007 where the string 'an' 
--(case insensitive) appears anywhere in the country name?

--4b. Repeat question 4a, but this time make the query case sensitive.

--4a

with table1 as
(
select 
		percap.gdp_per_capita,
		cntry.country_name
from per_capita percap
join countries cntry
on percap.country_code = cntry.country_code
where percap.year = 2007
)
-- case sensitive 
select count(*) as country_count
	, round(sum(gdp_per_capita),2) as sum_gdp_per_capita
from table1
--case insensitive
where country_name LIKE '%an%'

--change collation of the column country_name (case sensitive)

--where country_name COLLATE Latin1_General_CS_AS  LIKE '%an%'




-- by default the server instance level collation is case insensitive(CI)
-- LIKE operator is case insensitive by default
-- to make it case sensitive, change the collation