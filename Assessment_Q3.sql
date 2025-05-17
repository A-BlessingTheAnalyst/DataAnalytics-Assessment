-- Q3: Account Inactivity Alert
-- Goal: Find all active savings or investment accounts with no transactions in the last 365 days

WITH last_savings_tx AS (
    SELECT 
        plan_id, 
        -- Last known transaction date per plan from savings table
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    GROUP BY plan_id
),

combined_last_tx AS (
    SELECT
        p.id AS plan_id,
        p.owner_id,
        -- Identify the type of the plan
        CASE
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type,
        
        -- Use the latest of the plan's last charge or last savings transaction
        GREATEST(
            p.last_charge_date, 
            lst.last_transaction_date
        ) AS last_transaction_date

    FROM plans_plan p
    LEFT JOIN last_savings_tx lst ON p.id = lst.plan_id

    -- Consider only active savings or investment plans
    WHERE p.is_deleted = 0
      AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)
)

SELECT
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    -- Days since last activity
    DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days

FROM combined_last_tx
-- Filter for accounts inactive for more than 365 days
WHERE last_transaction_date < CURDATE() - INTERVAL 365 DAY

ORDER BY inactivity_days DESC;
