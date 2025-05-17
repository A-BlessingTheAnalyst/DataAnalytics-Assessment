-- Q2: Transaction Frequency Analysis
-- Goal: Categorize customers by how frequently they transact (High, Medium, Low)

WITH monthly_tx AS (
    SELECT 
        s.owner_id,
        -- Total number of transactions for the customer
        COUNT(*) AS total_transactions,
        -- Active months based on first and last transaction date
        TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)) + 1 AS active_months
    FROM savings_savingsaccount s
    GROUP BY s.owner_id
),

avg_tx AS (
    SELECT 
        m.owner_id,
        -- Average monthly transactions per customer
        ROUND(m.total_transactions / m.active_months, 2) AS avg_tx_per_month
    FROM monthly_tx m
)

SELECT 
    -- Categorize users by transaction frequency
    CASE
        WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
        WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    
    -- Count of users in each frequency group
    COUNT(*) AS customer_count,
    -- Average transactions per month across users in each group
    ROUND(AVG(avg_tx_per_month), 2) AS avg_transactions_per_month

FROM avg_tx
GROUP BY frequency_category;
