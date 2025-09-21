# MakeMyTrip SQL Interview Questions & Solutions

> **A comprehensive collection of SQL interview questions based on real MakeMyTrip scenarios**  
> Perfect for Data Analysts, BI Developers, and SQL Interview Preparation

---

## → What You'll Learn

- **Advanced SQL Techniques** → Window Functions, CTEs, Complex Joins
- **Business Analytics** → Customer Segmentation, Booking Patterns, Revenue Analysis  
- **Interview Preparation** → Real-world problems asked by top travel companies
- **Data Storytelling** → Transform raw data into actionable business insights

---

## → Dataset Overview

This project uses **two core tables** that simulate MakeMyTrip's booking system:

| Table | Description | Key Columns |
|-------|-------------|-------------|
| **user_table** | Customer demographics and segments | `user_id`, `segment` |
| **booking_table** | All booking transactions | `booking_id`, `user_id`, `booking_date`, `line_of_business` |

```sql
-- Quick data preview
SELECT * FROM make_my_trip.user_table LIMIT 5;
SELECT * FROM make_my_trip.booking_table LIMIT 5;
```

---

## → SQL Interview Questions

### **Question 1: Segment Performance Analysis**
**Business Problem:** *Which customer segments are most active in flight bookings during peak season?*

```sql
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
```

**→ Business Insight:** Identifies high-value segments for targeted April flight marketing campaigns

---

### **Question 2: Customer Journey Analysis**
**Business Problem:** *Who are the hotel-first customers and why does this matter?*

```sql
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
```

**→ Business Insight:** Hotel-first customers often have different lifetime values and booking behaviors

---

### **Question 3: Customer Lifecycle Metrics**
**Business Problem:** *How do we measure customer engagement duration?*

```sql
SELECT 
    user_id,
    MIN(booking_date) as first_booking,
    MAX(booking_date) as last_booking,
    DATEDIFF(MAX(booking_date), MIN(booking_date)) as days_active,
    COUNT(*) as total_bookings
FROM booking_table
WHERE user_id = 'u1'
GROUP BY user_id;
```

**→ Business Insight:** Longer active periods indicate higher customer satisfaction and retention

---

### **Question 4: Service Mix Analysis**  
**Business Problem:** *How do different segments split between flights vs hotels?*

```sql
SELECT 
    u.segment,
    COUNT(CASE WHEN b.line_of_business = 'Hotel' THEN 1 END) as hotel_bookings,
    COUNT(CASE WHEN b.line_of_business = 'Flight' THEN 1 END) as flight_bookings,
    ROUND(
        COUNT(CASE WHEN b.line_of_business = 'Hotel' THEN 1 END) * 100.0 / 
        COUNT(*), 2
    ) as hotel_percentage
FROM user_table u 
INNER JOIN booking_table b ON u.user_id = b.user_id
WHERE YEAR(b.booking_date) = 2022
GROUP BY u.segment
ORDER BY hotel_percentage DESC;
```

**→ Business Insight:** Helps optimize inventory allocation and cross-selling strategies

---

### **Question 5: Advanced Window Functions**
**Business Problem:** *Who made the first booking in each segment during April 2022?*

```sql
WITH april_segment_analysis AS (
    SELECT 
        u.segment,
        u.user_id,
        b.booking_date,
        b.line_of_business,
        COUNT(*) OVER (PARTITION BY u.user_id) as user_april_bookings,
        ROW_NUMBER() OVER (
            PARTITION BY u.segment 
            ORDER BY b.booking_date, b.booking_id
        ) as segment_rank
    FROM user_table u 
    INNER JOIN booking_table b ON u.user_id = b.user_id
    WHERE b.booking_date BETWEEN '2022-04-01' AND '2022-04-30'
)
SELECT 
    segment,
    user_id as first_booker,
    booking_date,
    line_of_business,
    user_april_bookings
FROM april_segment_analysis 
WHERE segment_rank = 1;
```

**→ Business Insight:** Early adopters in each segment can be valuable brand ambassadors

---

## → Getting Started

### **Step 1: Environment Setup**
```bash
# Clone the repository
git clone <your-repo-url>
cd makemytrip-sql-interview

# Set up your preferred SQL environment
# MySQL, PostgreSQL, SQLite, or any cloud SQL service
```

### **Step 2: Data Import**
- Import the sample datasets provided in `/data` folder
- Ensure both tables are properly indexed for optimal performance
- Verify data integrity with row counts and null checks

### **Step 3: Practice & Experiment**
- Start with Question 1 and work your way through
- Modify date ranges, segments, and filters to explore different scenarios  
- Try to solve each question before looking at the solution
- Document your approach and compare with provided solutions

---

## → Interview Tips

**What Interviewers Look For:**

→ **Problem-Solving Approach** | How you break down complex business problems  
→ **SQL Best Practices** | Clean, readable, and efficient query structure  
→ **Business Acumen** | Understanding the "why" behind each analysis  
→ **Communication Skills** | Explaining your logic and findings clearly  

**Common Follow-Up Questions:**
- "How would you optimize this query for a million-row dataset?"
- "What additional metrics would you track?"
- "How would you present these findings to stakeholders?"

---

## → Business Impact

These SQL skills directly translate to real business value:

**Revenue Growth** → Identify high-value customer segments for targeted campaigns  
**Cost Optimization** → Optimize inventory mix based on demand patterns  
**Customer Retention** → Understand booking behaviors to improve satisfaction  
**Strategic Planning** → Data-driven insights for business expansion decisions  

---

## → Contributing

**Ways to Contribute:**
- **Add Questions** → Submit new SQL challenges from travel/e-commerce domains
- **Optimize Queries** → Improve performance or readability of existing solutions  
- **Create Visualizations** → Add dashboards or charts using tools like Tableau/Power BI
- **Write Tutorials** → Explain advanced concepts for beginners

**Contribution Guidelines:**
1. Fork the repository
2. Create a feature branch (`git checkout -b new-question`)
3. Add your content with proper documentation
4. Submit a pull request with clear descriptions

---

## → Connect & Support

**Found this helpful?**
- **Star this repository** → Bookmark and support the project
- **Share with your network** → Help others with SQL interview prep  
- **Connect on LinkedIn** → More data analytics content and career tips

**Questions or Suggestions?**  
Open an issue or reach out directly → Always happy to help fellow data enthusiasts!

---

*This project is maintained with care for the data community. Happy querying!*
