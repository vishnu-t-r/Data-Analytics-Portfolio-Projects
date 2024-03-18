  -- https://mystery.knightlab.com/
--crime was a ​murder​ that 
--occurred sometime on ​Jan.15, 2018​ and 
--that it took place in ​SQL City​. 

/*
select * from crime_scene_report
where type = 'murder'
and date = 20180115
and city = 'SQL City'
*/

--Security footage shows that there were 2 witnesses. 
--The first witness lives at the last house on "Northwestern Dr". 
--The second witness, named Annabel, lives somewhere on "Franklin Ave".

/*
--First witness
select * from person
where address_street_name = 'Northwestern Dr'
order by address_number desc
limit 1
--id = 14887 name = 'Mort Schapiro'
*/

/*
--Second witness
select * from person
where name like '%Annabel%'
and address_street_name = 'Franklin Ave'
--id = 16371 name = 'Annabel Miller'
*/

/*
--Interview witnesses
select * from interview
where person_id in (14887,16371)
*/

--a man run out. 
--He had a "Get Fit Now Gym" bag. 
--The membership number on the bag started with "48Z". 
--Only gold members have those bags. 
--The man got into a car with a plate that included "H42W".

--I saw the murder happen, and 
--I recognized the killer from my gym when I was working out last week on January the 9th.

/*
--Query based on first witness
select name from person
where id = (
select person_id from get_fit_now_member
where id like '48Z%'
and membership_status = 'gold'
intersect
select d.id from drivers_license c
left join person d on c.id = d.license_id
where plate_number like '%H42%'
and gender = 'male')
*/

--murderer id = 67318

/*
--querying the interview transcript of the murderer
select * from interview
where person_id = 67318
*/

--Murdere interview
--I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
--She has red hair and she drives a Tesla Model S. 
--I know that she attended the SQL Symphony Concert 3 times in December 2017.

select * from person
where id = (

select id as person_id from person
where license_id in (
select id from drivers_license
where hair_color = 'red'
and car_make = 'Tesla'
and car_model = 'Model S'
and height between 65 and 67)

intersect

select person_id--, count(*) as event_count
from facebook_event_checkin
where event_name = 'SQL Symphony Concert'
and SUBSTR(cast(date as varchar(10)),1,6) = '201712'
group by person_id
having count(*) = 3 )
				
--women murderer is 99716
		   
--Miranda Priestly is murderer
				


