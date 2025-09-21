MakeMyTrip SQL Interview Q&A
A comprehensive collection of SQL interview questions and solutions based on MakeMyTrip use cases. This repository provides real-world SQL problems commonly encountered in data analyst and business intelligence developer interviews.
Table of Contents

Overview
Dataset Structure
Questions & Solutions
Getting Started
Key Insights
Contributing

Overview
This project simulates real-world data analysis scenarios using travel booking data. Each question is designed to test different SQL concepts including joins, window functions, aggregations, and date manipulations commonly used in business intelligence roles.
Dataset Structure
The project uses two main tables:
User Table

user_id: Unique identifier for each user
segment: User classification category
Additional user demographic details

Booking Table

booking_id: Unique identifier for each booking
user_id: Links to user table
booking_date: Date of booking
line_of_business: Service type (Flight/Hotel)

sql-- Sample data exploration
SELECT * FROM make_my_trip.booking_table;
SELECT * FROM make_my_trip.user_table;
Questions & Solutions
1. Total Users vs April Flight Bookings by Segment
Business Question: Which user segments have the highest flight booking rates in April?
sqlSELECT 
    u.segment,
    COUNT(DISTINCT u.user_id) AS total_users,
    COUNT(DISTINCT CASE 
        WHEN MONTH(b.booking_date) = 4 AND b.line_of_business = 'Flight' 
        THEN u.user_id 
        ELSE NULL 
    END) AS april_flight_bookings
FROM user_table u 
LEFT JOIN booking_table b ON u.user_id = b.user_id
GROUP BY u.segment;
Key Insight: Identifies which segments show strongest seasonal flight booking patterns for targeted marketing campaigns.

2. Users Whose First Booking Was a Hotel
Business Question: Which users started their customer journey with hotel bookings?
sqlSELECT user_id 
FROM (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date) AS booking_rank
    FROM booking_table
) ranked_bookings 
WHERE booking_rank = 1 AND line_of_business = 'Hotel';
Key Insight: Valuable for understanding user onboarding patterns and designing targeted retention strategies for hotel-first customers.

3. Days Between First and Last Booking for Specific User
Business Question: How long do individual users remain active on the platform?
sqlSELECT
    DATEDIFF(MAX(booking_date), MIN(booking_date)) AS days_active
FROM booking_table
WHERE user_id = 'u1';
Key Insight: Measures customer lifecycle duration and engagement depth for individual user analysis.

4. Flight vs Hotel Bookings by Segment (2022)
Business Question: How do different segments split between flight and hotel bookings?
sqlSELECT 
    u.segment,
    SUM(CASE WHEN b.line_of_business = 'Hotel' THEN 1 ELSE 0 END) AS hotel_bookings,
    SUM(CASE WHEN b.line_of_business = 'Flight' THEN 1 ELSE 0 END) AS flight_bookings
FROM user_table u 
LEFT JOIN booking_table b ON u.user_id = b.user_id
WHERE YEAR(b.booking_date) = 2022
GROUP BY u.segment;
Key Insight: Reveals service preference patterns across customer segments for resource allocation and inventory planning.

5. Earliest April Booking with User Activity Summary
Business Question: Who made the first booking in each segment during April, and what was their total activity?
sqlWITH april_bookings AS (
    SELECT 
        b.*, 
        u.segment,
        ROW_NUMBER() OVER (PARTITION BY u.segment ORDER BY b.booking_date, b.booking_id) AS segment_rank,
        COUNT(*) OVER (PARTITION BY u.segment, u.user_id) AS user_total_bookings
    FROM user_table u 
    INNER JOIN booking_table b ON u.user_id = b.user_id
    WHERE b.booking_date BETWEEN '2022-04-01' AND '2022-04-30'
) 
SELECT 
    segment, 
    booking_date, 
    user_id, 
    user_total_bookings
FROM april_bookings 
WHERE segment_rank = 1;
Key Insight: Identifies early adopters and high-activity users within each segment for VIP customer programs.
Getting Started
Prerequisites

SQL database system (MySQL, PostgreSQL, SQLite, etc.)
Basic understanding of SQL joins, window functions, and aggregations

Setup Instructions

Clone the repository

bash   git clone <repository-url>
   cd makemytrip-sql-interview

Import the dataset

Load the provided sample data into your preferred SQL environment
Ensure both user_table and booking_table are properly created


Run the queries

Execute each query in your SQL IDE
Modify parameters (dates, user IDs, segments) to explore different scenarios


Analyze results

Export results to Excel or connect to BI tools like Power BI for visualization
Use insights to answer business questions and create data-driven recommendations



Key Insights
This project demonstrates essential data analyst thinking patterns:
Customer Segmentation: Understanding how different user groups behave and prefer different services
Temporal Analysis: Identifying seasonal patterns and booking trends over time
Customer Journey Mapping: Tracking user progression from first booking to ongoing engagement
Business Performance Metrics: Measuring key indicators like user retention, service preference, and segment performance
Data-Driven Decision Making: Converting raw booking data into actionable business intelligence
Skills Demonstrated

Advanced SQL Functions: Window functions, CTEs, case statements
Data Analysis: Customer segmentation, cohort analysis, behavioral patterns
Business Intelligence: KPI development, performance measurement
Problem-Solving: Real-world business scenario analysis

Contributing
Contributions are welcome! Here's how you can help:

Add new questions: Submit additional SQL problems relevant to travel/booking industry
Improve solutions: Optimize existing queries or provide alternative approaches
Enhance documentation: Add more detailed explanations or business context
Create visualizations: Add charts or dashboards to complement the SQL analysis

License
This project is open source and available under the MIT License.

Connect with the Author
If you found this repository helpful for your interview preparation or data analysis learning:

Star this repository to show support
Share it with others preparing for SQL interviews
Connect on LinkedIn for more data analysis content
