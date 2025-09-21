SELECT * FROM make_my_trip.booking_table;
SELECT * FROM make_my_trip.user_table;

-- 1. Write an SQL query to show, for each segment, the total number of users and the number of users who booked a flight in April 2022.
SELECT u.segment,
COUNT(DISTINCT u.user_id) AS 'Total_User',
COUNT(DISTINCT CASE WHEN MONTH(b.booking_date) = 04 THEN u.user_id ELSE NULL END) AS 'Flight_Booked_Count'
FROM user_table u 
LEFT JOIN booking_table b 
ON u.user_id=b.user_id
GROUP BY u.segment;

-- 2. Write a query to identify users whose first booking was a hotel booking.
SELECT user_id FROM (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY user_id) AS 'First_Booking'
FROM booking_table) a 
WHERE First_Booking = 1 AND line_of_business = 'Hotel';

-- 3. Write a query to calculate the number of days between the first and last booking of the user with user_id = 1.
SELECT
DATEDIFF(MAX(booking_date),MIN(booking_date)) AS 'DIffrence_in_Days'
FROM booking_table
WHERE user_id = 'u1';

-- 4. Write a query to count the number of flight and hotel bookings in each user segment for the year 2022.
SELECT u.segment,
SUM(CASE WHEN line_of_business = 'Hotel' THEN 1 ELSE 0 END ) AS 'Hotel_Booking',
SUM(CASE WHEN line_of_business = 'Flight' THEN 1 ELSE 0 END ) AS 'Flight_Booking'
FROM user_table u 
LEFT JOIN booking_table b 
ON u.user_id=b.user_id
WHERE YEAR(booking_date) = 2022
GROUP BY u.segment;

-- 5. Find, for each segment, the user who made the earliest booking in April 2022, and also return how many total bookings that user made in April 2022.

WITH CTE AS (
SELECT b.*, u.segment,
ROW_NUMBER() OVER (PARTITION BY u.segment ORDER BY booking_date,booking_id) AS 'rn',
COUNT(*) OVER (PARTITION BY u.segment,u.user_id) AS 'Total_Booking'
FROM user_table u 
INNER JOIN booking_table b 
ON u.user_id=b.user_id
WHERE booking_date BETWEEN '2022-04-01' AND '2022-04-30'
) 

SELECT segment,booking_date, user_id,Total_Booking FROM CTE WHERE rn = 1








