# Make-My-Trip SQL Interview Q&A

A curated collection of **SQL interview questions and answers** inspired by MakeMyTrip-style use cases.  
This project is designed to help you practice **real-world SQL problems** frequently asked in data analyst and BI developer interviews.

---

## Dataset Overview

We work with two tables:

```sql
SELECT * FROM make_my_trip.booking_table;
SELECT * FROM make_my_trip.user_table;
Table Details:
→ user_table → Contains user_id, segment, and other user attributes
→ booking_table → Contains booking_id, user_id, booking_date, and line_of_business (Flight/Hotel)

Questions and Solutions
1. Total Users vs. April Flight Bookings by Segment
sql
Copy code
SELECT u.segment,
COUNT(DISTINCT u.user_id) AS 'Total_User',
COUNT(DISTINCT CASE WHEN MONTH(b.booking_date) = 04 THEN u.user_id ELSE NULL END) AS 'Flight_Booked_Count'
FROM user_table u 
LEFT JOIN booking_table b 
ON u.user_id=b.user_id
GROUP BY u.segment;
Insight → Shows how many users exist in each segment and how many booked flights in April 2022.

2. Users Whose First Booking Was a Hotel
sql
Copy code
SELECT user_id FROM (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY user_id) AS 'First_Booking'
FROM booking_table) a 
WHERE First_Booking = 1 AND line_of_business = 'Hotel';
Insight → Identifies users who started their journey with a hotel booking, useful for targeted marketing campaigns.

3. Days Between First and Last Booking (Example: user_id = 'u1')
sql
Copy code
SELECT
DATEDIFF(MAX(booking_date),MIN(booking_date)) AS 'DIffrence_in_Days'
FROM booking_table
WHERE user_id = 'u1';
Insight → Measures engagement duration by calculating how long the user stayed active.

4. Flight & Hotel Bookings by Segment (2022)
sql
Copy code
SELECT u.segment,
SUM(CASE WHEN line_of_business = 'Hotel' THEN 1 ELSE 0 END ) AS 'Hotel_Booking',
SUM(CASE WHEN line_of_business = 'Flight' THEN 1 ELSE 0 END ) AS 'Flight_Booking'
FROM user_table u 
LEFT JOIN booking_table b 
ON u.user_id=b.user_id
WHERE YEAR(booking_date) = 2022
GROUP BY u.segment;
Insight → Compares how each segment contributes to hotel vs. flight bookings during 2022.

5. Earliest April Booking and Total April Bookings per User
sql
Copy code
WITH CTE AS (
SELECT b.*, u.segment,
ROW_NUMBER() OVER (PARTITION BY u.segment ORDER BY booking_date,booking_id) AS 'rn',
COUNT(*) OVER (PARTITION BY u.segment,u.user_id) AS 'Total_Booking'
FROM user_table u 
INNER JOIN booking_table b 
ON u.user_id=b.user_id
WHERE booking_date BETWEEN '2022-04-01' AND '2022-04-30'
) 
SELECT segment, booking_date, user_id, Total_Booking 
FROM CTE 
WHERE rn = 1;
Insight → Finds the earliest April booking per segment and counts total April bookings for that user.

How to Use This Repository
→ Clone or download this repository
→ Run the SQL queries in MySQL, PostgreSQL, or your preferred SQL IDE
→ Experiment with date ranges, user segments, and line_of_business values to explore different scenarios
→ (Optional) Create visualizations in Power BI or Excel to make the insights more impactful

Why This Project Matters
This project goes beyond writing queries — it teaches you to think like a data analyst:

→ Who are the top users per segment?
→ When do they book the most?
→ What do they prefer — flights or hotels?
→ How can this data help businesses improve decision-making?

By solving these questions, you demonstrate business acumen and technical ability, both of which recruiters look for.

Connect and Contribute
→ Star this repository if you found it helpful
→ Contribute by adding new SQL scenarios and solutions
→ Connect with me on LinkedIn to discuss SQL, data analytics, or collaborations
