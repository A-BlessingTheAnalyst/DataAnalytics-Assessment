-- Q4: Customer Lifetime Value (CLV) Estimation
-- Goal: Estimate CLV for each customer based on tenure and transaction volume

SELECT 
    u.id AS customer_id,
    -- Capitalize first and last name properly
    CONCAT(
        UPPER(LEFT(u.first_name, 1)), LOWER(SUBSTRING(u.first_name, 2)),
        ' ',
        UPPER(LEFT(u.last_name, 1)), LOWER(SUBSTRING(u.last_name, 2))
    ) AS name,
    -- Tenure in months since account creation
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    -- Total number of transactions
    COUNT(s.id) AS total_transactions,
    -- Estimated CLV using given formula and 0.1% profit per transaction
    ROUND(
        ((COUNT(s.id) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())) * 12 * 0.001),
        2
    ) AS estimated_clv

FROM users_customuser u
JOIN savings_savingsaccount s ON s.owner_id = u.id
WHERE s.confirmed_amount IS NOT NULL

GROUP BY u.id, u.first_name, u.last_name, u.date_joined
-- Ignore users with zero tenure to avoid division errors
HAVING tenure_months > 0

ORDER BY estimated_clv DESC;
