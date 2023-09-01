Select time_of_day,
count(time_of_day)
FROM "Tickets"
group by time_of_day
order by 2 desc

Select time_of_day,
tick_time
FROM "Tickets"
Where tick_time between '13:00:00' and '18:00:00'

-- is there coorelation here? i.e more tickets in areas with lot/garges
Select * 
FROM "Locations"
where "lot/garage" is not null

Select count(t."ticketID") as "Tickets in Lots and Garages"
FROM "Tickets" t
JOIN "Locations" l
ON t.address = l.address
where l."lot/garage" is not null

-- which is a better measure, street or address?
Select l.street,
count(l.street)
FROM "Tickets" t
JOIN "Locations" l
ON t.address = l.address
group by l.street
order by 2 desc

Select t.address,
count(t.address)
FROM "Tickets" t
JOIN "Locations" l
ON t.address = l.address
group by t.address
order by 2 desc

SELECT v.car_make,
v.car_type,
v.car_color,
count(v."makeID")
FROM "Tickets" t
LEFT JOIN "Vehicle" v
on t."makeID" = v."makeID"
group by v.car_make, v.car_type, v.car_color
order by 4 desc

SELECT *
FROM "Vehicle"

-- Violation types
Select v.vio_type,
count(v.vio_type)
FROM "Tickets" t
LEFT JOIN "Violations" v
on t.vio_code = v.vio_code
group by v.vio_type
order by 2 desc


-- Extract Full Table
COPY (Select *
FROM "Tickets" t
LEFT JOIN "Violations" v
on t.vio_code = v.vio_code
LEFT JOIN "Vehicle" h
on t."makeID" = h."makeID"
JOIN "Locations" l
ON t.address = l.address
) TO 'C:\Users\Christopher\Documents\DataProjects2023\Parking Tickets 2023\processed_DOT.csv'
DELIMITER ',' CSV HEADER