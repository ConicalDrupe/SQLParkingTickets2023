--preliminary exploring for cleaning

-- check for duplicate rows
select * from "DOTraw" ou
where (select count(*) from "DOTraw" iner
	  where ou."Ticket Number" = iner."Ticket Number") > 1


DROP TABLE IF EXISTS "DOTclean";

CREATE TABLE "DOTclean" (
	"ticketID" int,
	"makeID" int,
	tick_date date,
	tick_time time without time zone,
	parking_district varchar(255),
	address varchar(255),
	time_of_day varchar(25),
	vio_code int,
	remarks varchar(255),
	vio_description varchar(255),
	vio_type varchar(255),
	street varchar(255),
	"lot/garage" varchar(25),
	car_make varchar(25),
	car_type varchar(25),
	car_color varchar(25),
	car_plate_exp varchar(25)
);
INSERT INTO "DOTclean" ("ticketID")
Select "Ticket Number"
From "DOTraw"
Where "Ticket Number" is not NULL;


--making vehicle make unique id
UPDATE "DOTclean"
SET car_make = temp."Vehicle Make",
	car_type = temp."Vehicle Type",
	car_color = temp."Vehicle Color",
	"makeID" = temp."makeID"
FROM (SELECT "Ticket Number",
"Vehicle Make",
"Vehicle Type",
"Vehicle Color",
DENSE_RANK() OVER(ORDER BY ("Vehicle Make","Vehicle Type","Vehicle Color")) as "makeID"
FROM "DOTraw"
) temp
Where temp."Ticket Number" = "ticketID";

--split up address investigation
SELECT "Ticket Location", 
SPLIT_PART("Ticket Location",'-',1) as lot,
SPLIT_PART("Ticket Location",'-',2) as address
FROM "DOTraw" 
where (SPLIT_PART("Ticket Location",'-',2) = '') is TRUE

--via CTE, split location into address and lot#
WITH CTE as (
Select "Ticket Location", 
"Ticket Number",
CASE
	when (SPLIT_PART("Ticket Location",'-',2) = '') is TRUE Then SPLIT_PART("Ticket Location",'-',1)
	when (SPLIT_PART("Ticket Location",'-',2) = '') is FALSE Then SPLIT_PART("Ticket Location",'-',2)
	END Address,
CASE
	when (SPLIT_PART("Ticket Location",'-',2) = '') is FALSE Then SPLIT_PART("Ticket Location",'-',1)
	Else NULL
	END Lot
From "DOTraw"
)

--remove numbers to get street, using regex. \D is any non-digit & a{m,n} finds between m and n of a
UPDATE "DOTclean" 
SET address = CTE.Address,
	"lot/garage" = CTE.Lot
From CTE
Where CTE."Ticket Number" = "ticketID"
AND length(substring(CTE.Address,'\D{1,36}')) > 4; --discludes 174 addresses with VERY dirty addresses

UPDATE "DOTclean"
SET street = tem.street
FROM (Select substring(CTE.Address,'\D{1,36}') as street,
	  "Ticket Number"
	  from CTE) tem
Where tem."Ticket Number" = "ticketID"
AND length(tem.street) > 4; --discludes 174 addresses with VERY dirty addresses

DELETE FROM "DOTclean"
Where Address is NULL;

--time of day
UPDATE "DOTclean" 
SET tick_date = temp."Date",
	tick_time = temp."Time",
	time_of_day = temp."time_of_day"
FROM (
Select "Ticket Number",
"Date",
"Time",
CASE
	When "Time" between '06:00:00' and '12:00:00' Then 'Morning'
	When "Time" between '12:00:00' and '18:00:00' Then 'Afternoon'
	When "Time" between'18:00:00' and '24:00:00' Then 'Evening'
	Else 'Late Night'
	End time_of_day
From "DOTraw"
) temp
Where temp."Ticket Number" = "ticketID"


-- condense 33 violation codes into 7, called vio_type
UPDATE "DOTclean"
SET vio_code = temp."Violation Code",
	vio_description = temp."Violation Description",
	vio_type = temp."violation_type"
FROM (
Select "Ticket Number",
"Violation Code",
"Violation Description",
CASE
	When "Violation Code" = 10 or "Violation Code" = 12 or "Violation Code" = 17 or "Violation Code" = 22 or "Violation Code" = 22 or "Violation Code" = 23 or "Violation Code" = 25 or "Violation Code" = 31 or "Violation Code" = 32 or "Violation Code" = 57 or "Violation Code" = 11 or "Violation Code" = 18 Then 'No Standing Parking'
	When "Violation Code" = 3 or "Violation Code" = 5 or "Violation Code" = 34 or "Violation Code" = 37 Then 'No Parking Anytime'
	When "Violation Code" = 7 or "Violation Code" = 41 or "Violation Code" = 50 Then 'Expired/Overtime'
	When "Violation Code" = 9 or "Violation Code" = 35 or "Violation Code" = 36 or "Violation Code" = 43 or "Violation Code" = 54 or "Violation Code" = 1 or "Violation Code" = 47 or "Violation Code" = 55 Then 'Sign Violation or Impeding Traffic'
	When "Violation Code" = 2 or "Violation Code" = 38 or "Violation Code" = 42 or "Violation Code" = 48 or "Violation Code" = 39 or "Violation Code" = 40 or "Violation Code" = 46 or "Violation Code" = 56 Then 'Prohibited Vehicle'
	When "Violation Code" = 8 or "Violation Code" = 19 or "Violation Code" = 20 or "Violation Code" = 24 or "Violation Code" = 27 or "Violation Code" = 28 or "Violation Code" = 59 or "Violation Code" = 45 or "Violation Code" = 4 Then 'Orientation Violation'
	Else NULL
	END violation_type
From "DOTraw" 
) temp
Where temp."Ticket Number" = "ticketID"


-- insert remaining
UPDATE "DOTclean"
SET remarks = raw."Remarks",
	car_plate_exp = 
	CASE
		When raw."Plate Month" is NULL or raw."Plate Year" is NULL Then NULL
		ELSE CONCAT(raw."Plate Month", '/', raw."Plate Year")
		END
FROM "DOTraw" raw
Where raw."Ticket Number" = "ticketID"

-- Checking not null constraint before loading into tables
Select *
from "DOTclean"
Where "vio_description" is NULL
or "ticketID" is NULL
or "vio_type" is NULL
or address is NULL
or street is NULL
or tick_time is NULL
or tick_date is NULL
or vio_code is NULL
or "makeID" is NULL
