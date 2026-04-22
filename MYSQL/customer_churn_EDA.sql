-- =====================================================
-- 1. DATA OVERVIEW
-- Objective: Customer Churn EDA
-- =====================================================

USE `customer_subscriptions`;

DESCRIBE customers;

-- Limit records 5

SELECT * FROM customers
LIMIT 5;

-- Total number of records
SELECT COUNT(*) AS total_rows 
FROM customers;

-- Check date range of customer signup
SELECT 
    MIN(signup_date) AS first_signup,
    MAX(signup_date) AS last_signup
FROM customers;

-- =====================================================
-- 2. DATA QUALITY CHECKS
-- Objective: Ensure data reliability before analysis
-- =====================================================

-- Check for duplicate users
SELECT 
    user_id, 
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY user_id
HAVING COUNT(*) > 1;


-- =====================================================
-- 3. DESCRIPTIVE STATISTICS
-- Objective: Understand overall customer behavior
-- =====================================================

SELECT 
    AVG(monthly_fee) AS avg_fee,
    AVG(avg_weekly_usage_hours) AS avg_usage,
    AVG(support_tickets) AS avg_tickets,
    AVG(payment_failures) AS avg_failures,
    AVG(tenure_months) AS avg_tenure
FROM customers;


-- =====================================================
-- 4. FEATURE DISTRIBUTION ANALYSIS
-- Objective: Understand customer segmentation
-- =====================================================

-- Usage segmentation
SELECT 
    CASE 
        WHEN avg_weekly_usage_hours < 5 THEN 'Low'
        WHEN avg_weekly_usage_hours BETWEEN 5 AND 15 THEN 'Medium'
        ELSE 'High'
    END AS usage_group,
    COUNT(*) AS users
FROM customers
GROUP BY usage_group;


-- =====================================================
-- 5. CHURN OVERVIEW 
-- Objective: Measure overall churn rate
-- =====================================================

SELECT 
    COUNT(*) AS total_users,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_users,
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2) AS churn_rate
FROM customers;

-- =====================================================
-- 6. CHURN BY CUSTOMER SEGMENTS
-- Objective: Identify high-risk segments
-- =====================================================

-- Churn by plan type
SELECT 
    plan_type,
    COUNT(*) AS users,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2) AS churn_rate
FROM customers
GROUP BY plan_type
ORDER BY churn_rate DESC;


-- =====================================================
-- 7. BEHAVIOR ANALYSIS
-- Objective: Understand how engagement impacts churn
-- =====================================================

-- Usage vs churn
SELECT 
    CASE 
        WHEN avg_weekly_usage_hours < 5 THEN 'Low Usage'
        WHEN avg_weekly_usage_hours BETWEEN 5 AND 15 THEN 'Medium Usage'
        ELSE 'High Usage'
    END AS usage_group,
    COUNT(*) AS users,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned
FROM customers
GROUP BY usage_group;


-- =====================================================
-- 8. PAYMENT RISK ANALYSIS
-- Objective: Analyze financial friction impact
-- =====================================================

-- Payment failures vs churn
SELECT 
    payment_failures,
    COUNT(*) AS users,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned
FROM customers
GROUP BY payment_failures
ORDER BY payment_failures DESC;


-- =====================================================
-- 9. CUSTOMER LIFECYCLE ANALYSIS
-- Objective: Understand churn across tenure
-- =====================================================

-- Tenure segmentation vs churn
SELECT 
    CASE 
        WHEN tenure_months < 6 THEN 'New Users'
        WHEN tenure_months BETWEEN 6 AND 24 THEN 'Mid Users'
        ELSE 'Loyal Users'
    END AS tenure_group,
    COUNT(*) AS users,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned
FROM customers
GROUP BY tenure_group;


-- =====================================================
-- 10. DETAILED RELATIONSHIP ANALYSIS (FOR DASHBOARD)
-- Objective: Build deeper insights for visualization
-- =====================================================

-- Plan type detailed churn
SELECT 
    plan_type,
    COUNT(*) AS total,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned
FROM customers
GROUP BY plan_type;


-- Usage detailed churn
SELECT 
    CASE 
        WHEN avg_weekly_usage_hours < 5 THEN 'Low'
        WHEN avg_weekly_usage_hours BETWEEN 5 AND 15 THEN 'Medium'
        ELSE 'High'
    END AS usage_group,
    COUNT(*) AS total,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned
FROM customers
GROUP BY usage_group;


-- Payment failure detailed churn
SELECT 
    payment_failures,
    COUNT(*) AS total,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned
FROM customers
GROUP BY payment_failures
ORDER BY payment_failures DESC;


-- Activity level vs churn (Recency Analysis)
SELECT 
    CASE 
        WHEN last_login_days_ago <= 7 THEN 'Active'
        WHEN last_login_days_ago <= 30 THEN 'Warm'
        ELSE 'Inactive'
    END AS activity_level,
    COUNT(*) AS total,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned
FROM customers
GROUP BY activity_level;

-- Tenure detailed churn
SELECT 
    CASE 
        WHEN tenure_months < 6 THEN 'New'
        WHEN tenure_months BETWEEN 6 AND 24 THEN 'Mid'
        ELSE 'Loyal'
    END AS tenure_group,
    COUNT(*) AS total,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned
FROM customers
GROUP BY tenure_group;

-- =====================================================
