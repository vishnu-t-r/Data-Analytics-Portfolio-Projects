--create database supplychain;

use supplychain;

--UPDATE THE DATE COLUMN TO 2022 USING DATEADD FUCNTION

update inventory
set date = dateadd(year,4,date);

select * from inventory

select distinct item_number, Item_name
from inventory
--54 distinct items

select distinct store_number
from inventory
--3 stores

--ADDING A NEW COLUMN TO THE TABLE (UNIT PRICE)


alter table inventory
add unit_price float;

update inventory
set unit_price = round(Sales_amount/nullif(try_convert(float,Sale_quantity),0),2)

--CHANGE THE DATATYPE OF THE COLUMN 'Sale_Quantity' TO FLOAT

select distinct Sale_quantity
from inventory
order by Sale_quantity asc

select * from inventory
where Sale_quantity in ('********  ')


--delete all the records from the table where --> Sale_quantity in ('********  ')

delete from inventory
where Sale_quantity in ('********  ');

--change tthe datatype to float

alter table inventory
alter column Sale_quantity float;

select * from inventory

--REPLACE ALL THE INVALID VALUES IN Inventory_quantity ('********  ') to 0

select * from inventory
where Inventory_quantity in ('********  ')

update inventory
set Inventory_quantity = 0 where Inventory_quantity in ('********  ')

--CHANGE THE DATATYPE OF THE Inventory_quantity column to float

alter table inventory
alter column Inventory_quantity float;


--INVENTORY VALUE ON THE LATEST DATE


select sum(Inventory_value) as Inventory_value
from(
select store_number,
		item_number,
		item_name,
		Sale_quantity,
		Inventory_quantity,
		(Sale_quantity + IIF(Inventory_quantity > 0, Inventory_quantity, 0)) as total_quantity,
		(IIF(Inventory_quantity > 0, Inventory_quantity, 0))*unit_price as Inventory_value
from inventory
where date =  (select max(date) from inventory)
) a



--EXCESS INVENTORY VALUE

--inventory quantity > (isnull(Sale_quantity,0)/4), is considered Excess Inventory

select sum(excess_Inventory_value) as Excess_Inventory_value
from(
select store_number,
		item_number,
		item_name,
		Sale_quantity,
		unit_price,
		--Inventory_quantity,
		IIF(Inventory_quantity > 0, Inventory_quantity, 0) as inventory_quantity,
		IIF((Inventory_quantity - (isnull(Sale_quantity,0)/4)) > 0, (Inventory_quantity - (isnull(Sale_quantity,0)/4)), 0) as Excess_Inventory,
		(IIF((Inventory_quantity - (isnull(Sale_quantity,0)/4)) > 0, (Inventory_quantity - (isnull(Sale_quantity,0)/4)), 0))*unit_price as excess_Inventory_value
from inventory
where date =  (select max(date) from inventory)
) b

--MISSING STOCK VALUE (INVENTORY VALUE FOR WHICH INVENTORY IS SHORT)

--To refill Missing Stock

select sum(missing_Inventory_value) as Missing_inventory_value
from(
select store_number,
		item_number,
		item_name,
		Sale_quantity,
		unit_price,
		--Inventory_quantity,
		IIF(Inventory_quantity < 0, abs(Inventory_quantity), 0) as inventory_quantity,
		(IIF(Inventory_quantity < 0, abs(Inventory_quantity), 0))*unit_price as missing_Inventory_value
from inventory
where date =  (select max(date) from inventory)
and Inventory_quantity < 0
) c


--TOTAL NUMBER OF ITEMS IN STORE/WAREHOUSE
--ON THE LATEST DATE

select count(distinct item_number) as Items
from inventory
where date = (select max(date) from inventory)

--NUMBER OF INVENTORY ITEM POSTITIONS (Combination of Item and Warehouse)
--ON THE LATEST DATE

select count(distinct concat(item_number,store_number)) as Positions
from inventory
where date = (select max(date) from inventory)


--INVENTORY STATUS

--CATEGORISE POSITIONS (Combination of Item and Warehouse) INTO 4 CATEGORIES
--(At-Stock,Below-Safety-Stock,Over-Stock,Stock-Out)

with table1 as
(
select store_number,
		item_number,
		item_name,
		sale_quantity,
		waste_quantity,
		inventory_quantity
from inventory
where date = (select max(date) from inventory)
),
table2 as
(
select table1.*,
		case when try_cast(waste_quantity as float) > 0 then 'Over-Stock'
			when inventory_quantity <= 0 then 'Stock-Out'
			when try_cast(waste_quantity as float) = 0 and inventory_quantity > (isnull(Sale_quantity,0)/4) then 'At-Stock'
			when try_cast(waste_quantity as float) = 0 and inventory_quantity < (isnull(Sale_quantity,0)/4) and inventory_quantity >= 0 
					then 'Below-Safety-Stock'
			end as Inventory_status
from table1
)
select Inventory_status, count(*) as Status_count
from table2
group by Inventory_status


--INVENTORY STATUS OF ITEMS

--OUTPUT SHOULD CONTAIN (Inventory_status, Item, Store,  Quantity corresponding to the status)


with table1 as
(
select store_number,
		item_number,
		item_name,
		sale_quantity,
		waste_quantity,
		inventory_quantity
from inventory
where date = (select max(date) from inventory)
),
table2 as
(
select table1.*,
		(isnull(Sale_quantity,0)/4) as Threshold_quantity,
		case when try_cast(waste_quantity as float) > 0 and inventory_quantity >= 0 then 'Over-Stock'
			when inventory_quantity <= 0 then 'Stock-Out'
			when try_cast(waste_quantity as float) = 0 and inventory_quantity > (isnull(Sale_quantity,0)/4) then 'At-Stock'
			when try_cast(waste_quantity as float) = 0 and inventory_quantity < (isnull(Sale_quantity,0)/4) and inventory_quantity >= 0 
					then 'Below-Safety-Stock'
			end as Inventory_status
from table1
)
select --table2.*,
		table2.Inventory_status,
		table2.store_number,
		table2.item_name,
		table2.item_number,
		case when Inventory_status = 'Stock-Out' then 0
				when Inventory_status = 'At-Stock' then inventory_quantity
				when Inventory_status = 'Below-Safety-Stock' then inventory_quantity
				when Inventory_status = 'Over-Stock' then inventory_quantity
				end as On_hand_quantity
from table2
order by table2.Inventory_status desc,
		table2.store_number asc,
		On_hand_quantity desc

--EVOLUTION OF INVENTORY ITEMS (BASED ON Inventory Status)


with table1 as
(
select *,
		case when try_cast(waste_quantity as float) > 0 and inventory_quantity >= 0  then 'Over-Stock'
			when inventory_quantity <= 0 then 'Stock-Out'
			when try_cast(waste_quantity as float) = 0 and inventory_quantity > (isnull(Sale_quantity,0)/4) then 'At-Stock'
			when try_cast(waste_quantity as float) = 0 and inventory_quantity < (isnull(Sale_quantity,0)/4) and inventory_quantity >= 0 
					then 'Below-Safety-Stock'
			end as Inventory_status
from inventory
)

select date, 
			sum(case when Inventory_status = 'At-Stock' then 1 else 0 end) as [At-Stock],
			sum(case when Inventory_status = 'Below-Safety-Stock' then 1 else 0 end) as [Below-Safety-Stock],
			sum(case when Inventory_status = 'Over-Stock' then 1 else 0 end) as [Over-Stock],
			sum(case when Inventory_status = 'Stock-Out' then 1 else 0 end) as [Stock-Out]
from table1
group by date
order by date asc

--TOTAL VALUE OF INVENTORY EVOLVING OVER TIME (IN MONTH YEAR)

--fisrt calculate the total value of inventory over a period of month and 
--then divide the total value by the number of days in that month 
--(here take number of days where data is available for that month)


with table1 as
(
select date, 
		(IIF(Inventory_quantity > 0, Inventory_quantity, 0))*unit_price as inventory_value
from inventory
),
table2 as
(
select date, sum(inventory_value) as daily_inventory_value
from table1
group by date
--order by date asc
),
table3 as
(
select datename(month,date) as Month_Name, 
		month(date) as Month_Int,
		sum(daily_inventory_value) as monthly_inventory_value,
		count(*) as num_days
from table2
group by datename(month,date), month(date)
--order by month(date) asc
)
select Month_Name,
		round((monthly_inventory_value/num_days),2) as Monthly_Average_Inventory_Value
from table3
order by Month_Int asc



