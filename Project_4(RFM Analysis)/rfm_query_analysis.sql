use Sales;

--select * from [dbo].[customer_transactions]

/*
select distinct InvoiceDate, convert(date, InvoiceDate, 101) as as_datetime
from customer_transactions
*/




select top 10 * from customer_transactions

select max(convert(date, InvoiceDate)) from customer_transactions
select max(InvoiceDate) from customer_transactions


--invoiceno

select distinct invoiceno -- no nulls
from customer_transactions
order by InvoiceNo asc

--stockcode

select distinct StockCode -- no nulls
from customer_transactions
order by StockCode asc

--quantity


select distinct quantity
from customer_transactions
order by quantity asc

--change the quantity datatype to int (current datatype is nvarchar)

alter table customer_transactions
alter column quantity int;

/* quantity -ve is returned quantity */

--invoicedate

alter table customer_transactions
alter column invoicedate date;

/* before data type conversion and after data type conversion will give 2 different values as max invoice date*/
select max(invoicedate) as max_date
from customer_transactions;


update customer_transactions
set InvoiceDate = dateadd(year,11,invoicedate);


--unitprice

select distinct unitprice
from customer_transactions
order by UnitPrice asc

--delete records where unitprice is -ve and 0

delete from customer_transactions
where UnitPrice  <= 0;


--customerid

select distinct customerid
from customer_transactions
order by CustomerID

select * from customer_transactions
where CustomerID is null


--remove records from the table where customerid is null
delete from customer_transactions
where CustomerID is null





--calculate recency, frequency and monetary_value
with rfm_score as(
select customerid,
		sum(quantity*unitprice) as monetary_value,
		count(invoiceno) as frequency,
		datediff(day,max(convert(date, InvoiceDate)),getdate()) as recency
from customer_transactions
group by customerid
),
rfm_calc as
(
select rfm_score .*,
		ntile(4) over(order by monetary_value asc) as rfm_monetary,
		ntile(4) over(order by frequency asc) as rfm_frequency,
		ntile(4) over(order by recency asc) as rfm_recency
from rfm_score 
),
t3 as
(
select rfm_calc.*,
		cast(rfm_recency as varchar)+cast(rfm_frequency as varchar)+cast(rfm_monetary as varchar) as rfm_score
from rfm_calc
)
select t3.*,
case when
rfm_score in 
(111,112,113,114,211,212,213,214) then 'new customer'
when rfm_score in 
(131,132,133,134,141,142,143,231,232,233,234,241,242,243,244) then 'active loyal customer'
when rfm_score in (144) then 'best customer'
when rfm_score in (221,222,223,224) then 'potential customer'
when rfm_score in (311,312,313,314,411,412,413,414) then 'one time customer'
when rfm_score in (331,332,341,342) then 'declining customer'
when rfm_score in (333,334,343,344) then 'slipping best customer'
when rfm_score in (421,422,423,424,431,432,441,442) then 'lost customer'
when rfm_score in (433,434,443,444) then 'churned best customer'
else 'customer' end as customer_segment
from t3

--rfm_score in (121,122,123,124,321,322,323,324) then 'customer'








