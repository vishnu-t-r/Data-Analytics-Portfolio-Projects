--Question 6

use braintree;

/*
select top 10 * from [dbo].[continent_map]
select top 10 * from [dbo].[continents]
select top 10 * from [dbo].[countries]
select top 10 * from [dbo].[per_capita]
*/

--6. All in a single query, execute all of the steps below and provide the results as your final answer:

	--a. create a single list of all per_capita records for year 2009 that includes columns:

		--continent_name
		--country_code
		--country_name
		--gdp_per_capita

	--b. order this list by:
		--continent_name ascending
		--characters 2 through 4 (inclusive) of the country_name descending

	--c. create a running total of gdp_per_capita by continent_name

	--d. return only the first record from the ordered list 
		 --for which each continent's running total of gdp_per_capita meets or exceeds $70,000.00 with the following columns:

with table1 as
--a, b, c questions completed in this cte table1
(
select 
		--contmap.continent_code,
		cont.continent_name,
		pc.country_code,
		cntry.country_name,
		pc.gdp_per_capita,
		sum(isnull(pc.gdp_per_capita,0)) over(partition by cont.continent_name order by substring(cntry.country_name, 2, 4) desc) as rnng_total
from per_capita pc
join continent_map contmap on contmap.country_code = pc.country_code
join continents cont on cont.continent_code = contmap.continent_code
join countries cntry on cntry.country_code = pc.country_code
where pc.year = 2009
--order by cont.continent_name asc, substring(cntry.country_name, 2, 4) desc
),
table2 as
(
select table1.*,
		row_number() over(partition by continent_name order by substring(country_name, 2, 4) desc) as rw_num
from table1
where rnng_total >= 70000
)

select * from table2
where rw_num = 1