	--NAMES of f1 drivers in alphabetica order
	 
	Select *
	from 
	f1..drivers$
	order by driverRef asc

	--Oldest driver in the dataset
	Select*
from f1..drivers$
	 order by driver_dob ASC

--	  How many French Drivers and Spanish in f1 Union

--Temp Table for French Drivers

DROP TABLE IF EXISTS #frenchdrivers
Create table #frenchdrivers
(driverref nvarchar(255),
driver_nationality nvarchar(255))

insert into #frenchdrivers
Select 
driverRef,driver_nationality 
from f1..drivers$
where driver_nationality ='French'

-- Temp Table for spanish drivers


DROP TABLE IF EXISTS #spanishdrivers
Create table #spanishdrivers
(driverref nvarchar(255),
driver_nationality nvarchar(255))

insert into #spanishdrivers
Select 
driverRef,driver_nationality 
from f1..drivers$
where driver_nationality ='Spanish'

Select*
from #spanishdrivers

--Union
--All spanish and french drivers ever to participate in f1 


Select * FROM
(Select 
driverref,driver_nationality
from
#frenchdrivers
) as a

union 

Select* 
from
(Select 
driverref,driver_nationality
from #spanishdrivers
) as b


--Window 
-- Top 3 most successful F1 driver Per Nationality
Select*
from
(Select
TotalPoints, driverref,driver_nationality,rank() over(partition by driver_nationality order by Totalpoints DESC) as Top_drivers_per_nationality
From
(Select
driverRef,sum(points) as TotalPoints,driver_nationality
from 
f1..drivers$
group by driverRef,driver_nationality) Points) Points2
where 
Top_drivers_per_nationality <= 3


--
--CASE Subquery
--Trying to find the elite drivers in F1 History


Select
driver_surname,driver_classification,count(driver_classification)
from
(Select
driver_surname,sum(points) as Points,

(CASE 
when sum(Points) <= 1000 then 'Average'
When sum(Points) <= 2000 then 'Above Average'
When sum(points) <=3000 then 'Great'
when sum(points) <4000 then 'Superb'
when sum(points) >=5000 then 'Elite'
else 'Poor'
end) Driver_Classification
from 
f1..drivers$
group by
driver_surname) A
group by
driver_classification,driver_surname
having Driver_Classification ='Elite'

-- Joins

Select * 
from 
f1..constructors$ a inner join f1..drivers$ b on a.raceid = b.raceid
where driver_surname ='Alonso'

--View 

Create View EliteDriver as
Select
driver_surname,driver_classification,count(driver_classification) as CountDriver
from
(Select
driver_surname,sum(points) as Points,

(CASE 
when sum(Points) <= 1000 then 'Average'
When sum(Points) <= 2000 then 'Above Average'
When sum(points) <=3000 then 'Great'
when sum(points) <4000 then 'Superb'
when sum(points) >=5000 then 'Elite'
else 'Poor'
end) Driver_Classification
from 
f1..drivers$
group by
driver_surname) A
group by
driver_classification,driver_surname
having Driver_Classification ='Elite'

Select *
from EliteDriver












