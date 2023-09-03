# How to avoid parking tickts in Mongomery County, Maryland
**Overview**
- Data sourced from DOT in Montgomery, Maryland. Link to [Raw Data](https://catalog.data.gov/dataset/dot-parking-tickets)
- 150,000+ rows of data, SQL is best use for this volume
- Designed ERD to ensure Entity and Relationship Integrity
- Processed raw data (cleaned addresses, classified violations, etc…)
- Created dashboard of results in Tableau

## ERD - four tables are included (Tickets,Locations,Violations, and Vehicle)
![alt text](https://github.com/ConicalDrupe/SQLParkingTickets2023/blob/main/Tickets_ERD.png "ERD image")

## [Dashboard & Results](https://public.tableau.com/app/profile/christopher.boon2264/viz/ParkingTickets2022-2023/ParkingTicketsDashboard)
[Click Here to see dashboard](https://public.tableau.com/app/profile/christopher.boon2264/viz/ParkingTickets2022-2023/ParkingTicketsDashboard)
![alt text](https://github.com/ConicalDrupe/SQLParkingTickets2023/blob/main/dashboard_screenshot.PNG "Dashboard")

## **How should we strategize to avoid a ticket?**
1) **80% of tickets are expired parking**. Be punctual, or pay for extra time.

2) If you are neither punctual or have deep pockets, **park away from areas with lots of activity**. Locations near malls and food hotspots such as Woodmont Ave. ,Cameron St., and Bethesda make up more than 20% of ticketing locations

3) **Take advantage of "weekend slumps"**. Visit and park on Monday or Saturdays when workers are less active

4) **Morning is the most risky time to park**, and should be avoided. There is a skew in the data collection. No tickets occurred from 6pm-12am. This could show a gap in DOT staffing.

## Cleaning Strategy - See create_clean_tables.sql for code
1) Remove Duplicate and Null Rows
2) Use window function to create unique vehicle MakeID, to reduce redundancy
3) Clean Ticket Locations by splitting into address, street, and lot #
4) Replaced redundant false-null lot # for addresses that had both null and non-null values
5) Classify time of ticketing to time of day: Morning, Afternoon, Night, and Late Night
6) Condense Parking Violation Types (From 41 similar types, down to 7 distinct)

