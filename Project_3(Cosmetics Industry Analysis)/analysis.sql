--select * from [dbo].[test]

use int_ques;

--select top 10 * from cosmetics_chemicals;


select top 10 * from cosmetics_chemicals;

--record count
select count(*) as record_count from cosmetics_chemicals


--counting the product name in desc order of the count
select ProductName, count(*) as n
from cosmetics_chemicals
group by ProductName
order by n desc

--count of company
--avocado chart --chart 6
select count(distinct companyname) as company_count from cosmetics_chemicals

--count of brands 
--avocado -- chart 7
select count(distinct brandname) as brand_count from cosmetics_chemicals

--count of primarycategory
--chart 8 --avocado
select count(distinct primarycategory) as primary_cat_count from cosmetics_chemicals

--list of distinct productcategory
select distinct primarycategory
from cosmetics_chemicals
where discontinueddate is null
and ChemicalDateRemoved is null



--count of subcategory
select count(distinct subcategory) as primary_cat_count from cosmetics_chemicals

-- number of products for each company
select companyname, count(distinct productname) as products_per_company
from cosmetics_chemicals
group by companyname
order by products_per_company desc

/*
select distinct productname
from cosmetics_chemicals
where CompanyName = 'L''Oreal USA'
*/

-- number of products for each brand
select brandname, count(distinct productname) as products_per_brand
from cosmetics_chemicals
group by brandname
order by products_per_brand desc

--number of products discontinued per brand
select brandname, count(distinct productname) as discountinued_product_count
from
(
select * from cosmetics_chemicals
where DiscontinuedDate is not null
) a
group by brandname
order by discountinued_product_count desc



--number of products for each brand vs number of discontinued product

select b.brandname,b.products_per_brand,c.discountinued_product_count
from
(
select brandname, count(distinct productname) as products_per_brand
from cosmetics_chemicals
group by brandname
) b
left join 
(
select brandname, count(distinct productname) as discountinued_product_count
from
(
select * from cosmetics_chemicals
where DiscontinuedDate is not null
) a
group by brandname
) c
on b.brandname = c.brandname
order by discountinued_product_count desc


--number of products per brand and primarycategory
select distinct primarycategory from cosmetics_chemicals
--chart 1
--keep brand as a filter
select brandname,primarycategory, count(distinct productname) as product_count
from cosmetics_chemicals
where discontinueddate is null
and chemicaldateremoved is null
group by brandname,primarycategory
order by brandname
--product_count desc

select top 10 * from cosmetics_chemicals

/*
select subcategory
from cosmetics_chemicals
group by subcategory
*/


--number of products per primarycategory and subcategory
--chart 2
--keep primary category as a filter
select primarycategory, subcategory, count(distinct productname) as product_count
from cosmetics_chemicals
where discontinueddate is null
group by primarycategory, subcategory
order by product_count desc


--companyname, brandname, productname, chemicalname table
--chart 3 - table

select companyname,
		brandname,
		productname,
		string_agg(chemicalname,', ') within group(order by chemicalname asc) as chemicals
from (
select distinct companyname,
		brandname,
		productname,
		chemicalname
from cosmetics_chemicals
--product are not discontinued
where discontinueddate is null
and chemicaldateremoved is null
) a--cosmetics_chemicals
group by companyname,
		brandname,
		productname
/*
select distinct companyname,
		brandname,
		productname,
		chemicalname
from cosmetics_chemicals
order by productname asc
*/

select top 10 * from cosmetics_chemicals



--major component of cosmetic product per category
--chart 4 

-- keep primary category as a filter
select primarycategory,chemicalname, count(distinct productname) as product_count
from cosmetics_chemicals
where discontinueddate is null
and chemicaldateremoved is null
group by primarycategory,chemicalname
order by product_count desc



-- most common category that the brands explore
--chart 5 treemap
select primarycategory, count(distinct brandname) as brand_count --how many 
from cosmetics_chemicals
group by primarycategory



-- chart 2 modified query
-- including brand
select brandname, primarycategory, subcategory, count(distinct productname) as product_count
from cosmetics_chemicals
where discontinueddate is null
group by brandname, primarycategory, subcategory
order by product_count desc


select 'companycount' as metric,count(distinct companyname) as [count] from cosmetics_chemicals
union
select 'brandcount' as metric, count(distinct brandname) as [count] from cosmetics_chemicals
union
select 'categorycount' as metric, count(distinct primarycategory) as [count] from cosmetics_chemicals

----query6
--avocado
select distinct companyname, brandname, primarycategory, subcategory
from cosmetics_chemicals