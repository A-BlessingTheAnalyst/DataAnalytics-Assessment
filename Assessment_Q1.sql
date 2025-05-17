-- Q1: High-Value Customers with Multiple Products
-- Goal: Identify customers who have both a funded savings and a funded investment plan, sorted by total deposits.

SELECT 
    u.id AS owner_id,
    -- Capitalize first and last names properly
    CONCAT(
        UPPER(LEFT(u.first_name, 1)), LOWER(SUBSTRING(u.first_name, 2)),
        ' ',
        UPPER(LEFT(u.last_name, 1)), LOWER(SUBSTRING(u.last_name, 2))
    ) AS name,
    -- Count of distinct funded savings plans (regular savings)
    COUNT(DISTINCT CASE 
        WHEN p.is_regular_savings = 1 AND s.confirmed_amount > 0 THEN p.id 
    END) AS savings_count,

    -- Count of distinct funded investment plans (fund plans)
    COUNT(DISTINCT CASE 
        WHEN p.is_a_fund = 1 AND s.confirmed_amount > 0 THEN p.id 
    END) AS investment_count,
    -- Total confirmed deposits in Naira (from Kobo)
    ROUND(SUM(COALESCE(s.confirmed_amount, 0)) / 100, 2) AS total_deposits

FROM users_customuser AS u
-- Link customers to plans
LEFT JOIN plans_plan AS p ON p.owner_id = u.id
-- Link plans to savings accounts to access transaction amounts
LEFT JOIN savings_savingsaccount AS s ON s.plan_id = p.id
  
GROUP BY u.id, u.first_name, u.last_name
-- Only show users with both savings and investment plans
HAVING savings_count > 0 AND investment_count > 0

-- Sort by total amount deposited
ORDER BY total_deposits DESC;
