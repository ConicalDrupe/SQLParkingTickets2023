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

**How should we strategize to avoid a ticket?**
- Park in the afternoon, but leave before 6pm (afternoon)
- Visit and park on a Monday or Saturday
- Take a vacation during the summer months (namely July)

## Cleaning Strategy
1) Remove Duplicate and Null Rows
2) Use window function to create unique vehicle MakeID, to reduce redundancy
3) Clean Ticket Locations by splitting into address, street, and lot #
4) Replaced redundant false-null lot # for addresses that had both null and non-null values
5) Classify time of ticketing to time of day: Morning, Afternoon, Night, and Late Night
6) Condense Parking Violation Types (From 41 similar types, down to 7 distinct)

### 2) Window funcion to create MakeID for Vehicle Table
<script src="https://gist.github.com/ConicalDrupe/b3a4762812a4e844f8648a51eaf9a3fa.js"></script>

### 5) Create Time Of Day Categories
Morning: 6am-noon
Afternoon: noon-6pm
Evening: 6pm-midnight
Late Night: midnight-6am

### 6) Condense Parking Violations to 7 types
Originally there were 41 classifications of violations. But many types were self-similar. For example, ‘off street’ and ‘on street’ are of the same overtime parking violation.
