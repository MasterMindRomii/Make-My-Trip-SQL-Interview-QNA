# Make-My-Trip SQL Interview Q&A 🚀

A curated collection of **SQL interview questions & answers** inspired by **MakeMyTrip** use cases.  
This project is designed to help you **practice real-world SQL problems** that are commonly asked in data analyst and BI developer interviews.

---

## 📂 Dataset Overview
We work with two tables:

```sql
SELECT * FROM make_my_trip.booking_table;
SELECT * FROM make_my_trip.user_table;

user_table → Contains user_id, segment, and user details.
booking_table → Contains booking_id, user_id, booking_date, and line_of_business (Flight/Hotel).

📝 Questions & Solutions
1️⃣ Total Users vs. April Flight Bookings by Segment
SELECT u.segment,
COUNT(DISTINCT u.user_id) AS 'Total_User',
COUNT(DISTINCT CASE WHEN MONTH(b.booking_date) = 04 THEN u.user_id ELSE NULL END) AS 'Flight_Booked_Count'
FROM user_table u 
LEFT JOIN booking_table b 
ON u.user_id=b.user_id
GROUP BY u.segment;


✅ Insight: Understand which segment booked the most flights in April 2022.

2️⃣ Users Whose First Booking Was a Hotel
SELECT user_id FROM (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY user_id) AS 'First_Booking'
FROM booking_table) a 
WHERE First_Booking = 1 AND line_of_business = 'Hotel';


✅ Insight: Find users who started their journey with a hotel booking (good for marketing campaigns).

3️⃣ Days Between First and Last Booking (User = u1)
SELECT
DATEDIFF(MAX(booking_date),MIN(booking_date)) AS 'DIffrence_in_Days'
FROM booking_table
WHERE user_id = 'u1';


✅ Insight: Measure customer engagement by calculating how long they stayed active.

4️⃣ Flight & Hotel Bookings by Segment (2022)
SELECT u.segment,
SUM(CASE WHEN line_of_business = 'Hotel' THEN 1 ELSE 0 END ) AS 'Hotel_Booking',
SUM(CASE WHEN line_of_business = 'Flight' THEN 1 ELSE 0 END ) AS 'Flight_Booking'
FROM user_table u 
LEFT JOIN booking_table b 
ON u.user_id=b.user_id
WHERE YEAR(booking_date) = 2022
GROUP BY u.segment;


✅ Insight: Compare how each segment contributes to flights vs. hotels.

5️⃣ Earliest April Booking + Total April Bookings by User
WITH CTE AS (
SELECT b.*, u.segment,
ROW_NUMBER() OVER (PARTITION BY u.segment ORDER BY booking_date,booking_id) AS 'rn',
COUNT(*) OVER (PARTITION BY u.segment,u.user_id) AS 'Total_Booking'
FROM user_table u 
INNER JOIN booking_table b 
ON u.user_id=b.user_id
WHERE booking_date BETWEEN '2022-04-01' AND '2022-04-30'
) 

SELECT segment,booking_date, user_id,Total_Booking FROM CTE WHERE rn = 1;

✅ Insight: Identify the first booker per segment and measure their April activity.

👨‍💻 How to Use This Repository

Clone or download the repo.

Run the SQL queries in MySQL, PostgreSQL, or any SQL IDE.

Experiment with dates, segments, and line_of_business to generate fresh insights.

(Optional) Visualize in Power BI or Excel for added impact.

📌 Why This Project Matters

This isn’t just about writing SQL — it’s about thinking like a data analyst:

🧠 Who are the top users per segment?

📆 When do they book the most?

🏨✈️ What do they prefer — flights or hotels?

📈 How can this data guide business decisions?

⭐ Connect & Contribute

If you found this helpful:

🌟 Star this repository to support

🤝 Contribute by adding more queries

🔗 Connect with me on LinkedIn
