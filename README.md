MakeMyTrip SQL Interview Questions & Solutions
A comprehensive collection of SQL interview questions based on real MakeMyTrip scenarios
Perfect for Data Analysts, BI Developers, and SQL Interview Preparation

🎯 What You'll Learn
Advanced SQL Techniques → Window Functions, CTEs, Complex Joins
Business Analytics → Customer Segmentation, Booking Patterns, Revenue Analysis
Interview Preparation → Real-world problems asked by top travel companies
Data Storytelling → Transform raw data into actionable business insights
📊 Dataset Overview
This project uses two core tables that simulate MakeMyTrip's booking system:

Table	Description	Key Columns
user_table	Customer demographics and segments	user_id, segment
booking_table	All booking transactions	booking_id, user_id, booking_date, line_of_business
-- Quick data preview
SELECT * FROM make_my_trip.user_table LIMIT 5;
SELECT * FROM make_my_trip.booking_table LIMIT 5;
💼 SQL Interview Questions
Question 1: Segment Performance Analysis
Business Problem: Which customer segments are most active in flight bookings during peak season?

SELECT 
    u.segment,
    COUNT(DISTINCT u.user_id) AS total_users,
    COUNT(DISTINCT CASE 
        WHEN MONTH(b.booking_date) = 4 
        AND b.line_of_business = 'Flight' 
        THEN u.user_id 
    END) AS april_flight_users
FROM user_table u 
LEFT JOIN booking_table b ON u.user_id = b.user_id
GROUP BY u.segment
ORDER BY april_flight_users DESC;
💡 Business Insight: Identifies high-value segments for targeted April flight marketing campaigns
Question 2: Customer Journey Analysis
Business Problem: Who are the hotel-first customers and why does this matter?

SELECT user_id 
FROM (
    SELECT 
        user_id,
        line_of_business,
        ROW_NUMBER() OVER (
            PARTITION BY user_id 
            ORDER BY booking_date, booking_id
        ) as first_booking_rank
    FROM booking_table
) first_bookings 
WHERE first_booking_rank = 1 
AND line_of_business = 'Hotel';
💡 Business Insight: Hotel-first customers often have different lifetime values and booking behaviors
🚀 Getting Started
Step 1: Environment Setup
# Clone the repository
git clone <your-repo-url>
cd makemytrip-sql-interview

# Set up your preferred SQL environment
# MySQL, PostgreSQL, SQLite, or any cloud SQL service
Step 2: Data Import
Import the sample datasets provided in /data folder
Ensure both tables are properly indexed for optimal performance
Verify data integrity with row counts and null checks
🎯 Interview Tips
What Interviewers Look For:

✅ Problem-Solving Approach → How you break down complex business problems
✅ SQL Best Practices → Clean, readable, and efficient query structure
✅ Business Acumen → Understanding the "why" behind each analysis
✅ Communication Skills → Explaining your logic and findings clearly
📈 Business Impact
These SQL skills directly translate to real business value:

Revenue Growth → Identify high-value customer segments for targeted campaigns
Cost Optimization → Optimize inventory mix based on demand patterns
Customer Retention → Understand booking behaviors to improve satisfaction
Strategic Planning → Data-driven insights for business expansion decisions
Found this helpful?

⭐ Star this repository to bookmark and support the project
🔗 Share with your network to help others with SQL interview prep
💼 Connect on LinkedIn for more data analytics content and career tips
This project is maintained with ❤️ for the data community. Happy querying!
