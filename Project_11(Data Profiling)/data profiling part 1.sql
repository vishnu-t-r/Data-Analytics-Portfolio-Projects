--Data profiling

use [questions];

select * from [dbo].[Sample_Superstore]

select top 10 * from [dbo].[Sample_Superstore]

--counting the number of records in a table

select count(*) as record_count
from [dbo].[Sample_Superstore]


--min, max, avg, standard deviation for the numerical columns

--get the data type for each column in the table

select top 10 * from sys.tables
select top 10 * from sys.columns
select top 10 * from sys.types

select [object_id] from sys.tables
where name = 'Sample_Superstore'


--to get the data type for each column in a table

select [column].[name] as column_name,
		[column].[system_type_id] as [type_id],
		[type].[name] as [data type]
from sys.columns [column]
inner join sys.types [type]
on [column].[user_type_id] = [type].[user_type_id]
where [column].object_id = (select [object_id] from sys.tables
					where name = 'Sample_Superstore')
order by [data type] asc

/*

column_name		type_id		data type
Order_Date		42			datetime2
Ship_Date		42			datetime2
Sales			62			float
Discount		62			float
Profit			62			float
Quantity		56			int
Row_ID			231			nvarchar
Order_ID		231			nvarchar
Ship_Mode		231			nvarchar
Customer_ID		231			nvarchar
Customer_Name	231			nvarchar
Segment			231			nvarchar
Country_Region	231			nvarchar
City			231			nvarchar
State			231			nvarchar
Postal_Code		231			nvarchar
Region			231			nvarchar
Product_ID		231			nvarchar
Category		231			nvarchar
Sub_Category	231			nvarchar
Product_Name	231			nvarchar



*/


-- numeric columns available
/*
Sales			62			float
Discount		62			float
Profit			62			float
Quantity		56			int
*/

--min, max, avg, standard deviation for the numerical columns


select min(sales) as min_value,
		max(sales) as max_value,
		avg(sales) as avg_value,
		stdev(sales) as stdev_value,
		var(sales) as var_value
from [dbo].[Sample_Superstore]


-- earliest and latest date from the date columns

--date columns available

/*
Order_Date		42			datetime2
Ship_Date		42			datetime2
*/

select min(Order_Date) as earliest_date,
		max(Order_Date) as latest_date
from [dbo].[Sample_Superstore]


--Min and Max of String columns

--return the first and last string when soretd in alphabetcial order

/*
Customer_Name	231			nvarchar
*/

select min(Customer_Name) as value_min_string,
		max(Customer_Name) as value_max_string
from [dbo].[Sample_Superstore]


--Testing Range for numerical columns

/*
Quantity		56			int
*/


declare @range_min int =  5;
declare @range_max int =  11;

--count of values below, above and within range

select sum(case when quantity < @range_min then 1 else 0 end) as below_range,
		sum(case when quantity >= @range_min and quantity < @range_max then 1 else 0 end) as within_range,
		sum(case when quantity >= @range_max then 1 else 0 end) as above_range
from [dbo].[Sample_Superstore]


--min/ max/ and avg string length


/*
Row_ID			231			nvarchar
*/

select min(len(row_id)) as min_length,
		max(len(row_id)) as max_length,
		avg(len(row_id)) as avg_length
from [dbo].[Sample_Superstore]

--string length distribution

select len(row_id) as string_length,
		count(*) as len_count
from [dbo].[Sample_Superstore]
group by len(row_id)
order by len(row_id) asc

-- Longest and Shortest string in string columns

/*
Product_Name	231			nvarchar
*/

--List top 10 longest strings

select distinct top 10 Product_Name, len(Product_Name) as string_len
from [dbo].[Sample_Superstore]
order by len(Product_Name) desc


--List of bottom 10 strings based on length

select distinct top 10 Product_Name, len(Product_Name) as string_len
from [dbo].[Sample_Superstore]
order by len(Product_Name) asc


-- finding most popular values (mode)

--can be done on both numerical column,string columns and date columns

/*
Sub_Category	231			nvarchar
*/

select top 1 sub_category, count(*) as record_count
from [dbo].[Sample_Superstore]
group by sub_category
order by record_count desc

--least popular sub category
select top 1 sub_category, count(*) as record_count
from [dbo].[Sample_Superstore]
group by sub_category
order by record_count asc

/*
Ship_Date		42			datetime2
Quantity		56			int
*/

select quantity, count(*) as mode
from [dbo].[Sample_Superstore]
group by quantity
order by mode desc

select top 1 Ship_Date, count(*) as mode
from [dbo].[Sample_Superstore]
group by Ship_Date
order by mode desc



--Number of distinct values

/*
Product_ID		231			nvarchar
*/

select count(distinct product_id) as unique_product_count
from [dbo].[Sample_Superstore]

--distinct values and their count


/* 
Product_Name	231			nvarchar
*/

select product_name, count(*) as prod_count
from [dbo].[Sample_Superstore]
group by product_name


--Sampling data from the table

--Returning random rows for examining

--method 1 
--along with the result new column also will be returned

select top 10 s.*, newid() as new_id
from [dbo].[Sample_Superstore] s
order by new_id 


--method 2
--only columns in table will be returned

SELECT * 
FROM [dbo].[Sample_Superstore]
WHERE row_id IN (
    SELECT TOP (10) row_id
    FROM [dbo].[Sample_Superstore]
    ORDER BY NEWID())


--Return n random column values for a specific columns


/*
Order_ID		231			nvarchar
*/


select top 10 order_id
from [dbo].[Sample_Superstore]
group by order_id
order by newid()


--Null rows in the numbers and date columns



--inserted null records into the table based on the category column and profit column

select *, case when category = 'furniture' then null else category end as new_category
		, case when Profit < 0 then null else Profit end as new_profit
into #sample_superstore_copy
from Sample_Superstore

-- numerical column
-- checking for new_profit column from the #sample_superstore_copy


select value_indicator, count(*) as record_count
from (
select case when new_profit is null then 'null'
			else 'valid' end as value_indicator
from #sample_superstore_copy
) a 
group by value_indicator


-- string column
-- checking for new_category column from the #sample_superstore_copy

select value_indicator, count(*) as record_count
from
(
select case when new_category is null then 'null'
			when len(new_category) = 0 then 'blank'
			else 'valid' end as value_indicator
from #sample_superstore_copy
) a
group by value_indicator


-- Testing uniqueness

select top 10 * from Sample_Superstore;

with t1 as
(
select order_id, customer_id, product_id, count(*) as records
from Sample_Superstore
group by order_id, customer_id, product_id
--order by records desc
), t2 as
(
select records,
		case when records = 1 then 'unique'
			else 'duplicate' end as unique_or_not
from t1
)
select unique_or_not, count(*) as record_count
from t2
group by unique_or_not



/*
select * from Sample_Superstore
where
order_id = 'CA-2017-103135' and customer_id = 'SS-20515' and product_id = 'OFF-BI-10000069'
*/
