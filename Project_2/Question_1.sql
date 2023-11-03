--create database braintree;

use braintree;

---Create a SQL database using CSV files

/*
select top 10 * from [dbo].[continent_map]
select top 10 * from [dbo].[continents]
select top 10 * from [dbo].[countries]
select top 10 * from [dbo].[per_capita]
*/


--conditions
--money values should be rounded to 2 decimal points and preceded by the "$" symbol
--percent values should be between -100.00 to 100.00, rounded to 2 decimal points and followed by the "%" symbol

--1. Data Integrity Checking & Cleanup

/*
Alphabetically list all of the country codes in the continent_map table that appear more than once. 
Display any values where country_code is null as country_code = "FOO" and make this row appear first in the list, 
even though it should alphabetically sort to the middle. Provide the results of this query as your answer.
*/

--select * from continent_map


select 
	isnull(country_code,'FOO') as country_code
from 
	continent_map
group by 
	country_code
having 
	count(*) > 1
order by (case when country_code = 'FOO' then '0' else country_code end) asc


/*
For all countries that have multiple rows in the continent_map table, 
delete all multiple records leaving only the 1 record per country. 
The record that you keep should be the first one when sorted by the continent_code alphabetically ascending. 
Provide the query/ies and explanation of step(s) that you follow to delete these records.
*/

--identify unique rows

select * from (
select 
	country_code,
	continent_code,
	row_number() over(partition by country_code order by country_code asc) as rw_num
from 
	continent_map ) a
where rw_num = 1


--creating a temporary table to store the new table created

--create table temp_table1


select country_code,
continent_code,
row_number() over(partition by country_code order by country_code asc) as rw_num
--inserting into a new temp_table1
into temp_table1
from continent_map; 

select * from temp_table1;


--create a second temp_table2 
--insert only records for which rw_num = 1


select country_code,
continent_code
--insert into temp_table2 for rw_num = 1
into temp_table2
from temp_table1
where rw_num = 1;


select * from temp_table2;


-- delete all records from the actual 'continent_map' table


delete from continent_map;

select * from continent_map;


--insert the temp_table2 data into continent_map table


insert into continent_map
select * from temp_table2;


select * from continent_map;
