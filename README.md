# DataAnalytics-Assessment

This repository contains SQL solutions to a four-question data analytics assessment. Each query has been designed with a focus on correctness, efficiency, completeness, and readability.

---

## Q1: High-Value Customers with Multiple Products

**Goal:**  
Identify customers who have both a funded savings and a funded investment plan. Rank them based on their total confirmed deposits.

**Approach:**
- Used conditional aggregation with `CASE WHEN` to separately count savings and investment plans where a confirmed deposit exists.
- Used `LEFT JOIN` to connect users, plans, and savings accounts.
- Applied capitalization logic for names to improve readability.
- Filtered for customers with both types of funded products using `HAVING`.
- Sorted by total deposits in descending order.

**Key Decisions:**
- Used `COALESCE` to handle null values in `confirmed_amount`.
- Handled name formatting by capitalizing the first letter of each name.

---

## Q2: Transaction Frequency Analysis

**Goal:**  
Categorize users into transaction frequency bands (High, Medium, Low) based on average monthly activity.

**Approach:**
- Used a CTE (`monthly_tx`) to compute total transactions and active months per user.
- Another CTE (`avg_tx`) calculated the average transactions per month.
- Final query categorized customers into High (≥10), Medium (3–9), and Low (<3) frequency.
- Calculated the customer count and average monthly transactions for each group.

**Key Decisions:**
- Used `TIMESTAMPDIFF` to calculate active months accurately.
- Added `+1` to ensure correct inclusion of first and last month in the activity window.

---

## Q3: Account Inactivity Alert

**Goal:**  
Identify all active (non-deleted) savings or investment plans with no transaction activity in the last 365 days.

**Approach:**
- First CTE (`last_savings_tx`) got the last transaction date per plan from savings.
- Second CTE (`combined_last_tx`) compared each plan’s `last_charge_date` with the last savings transaction.
- Used `GREATEST()` to find the latest activity date per plan.
- Final query filtered plans where the latest activity was over a year ago and computed inactivity in days.

**Key Decisions:**
- Applied plan filtering (`is_regular_savings`, `is_a_fund`) in the second CTE.
- Ensured `p.is_deleted = 0` to only consider active plans.

---

## Q4: Customer Lifetime Value (CLV) Estimation

**Goal:**  
Estimate each customer’s CLV using tenure and transaction count, with a profit rate of 0.1% per transaction per year.

**Approach:**
- Calculated tenure in months since `date_joined` using `TIMESTAMPDIFF`.
- Counted number of confirmed transactions for each user.
- Estimated CLV using the formula:  
  `(Total Transactions / Tenure Months) * 12 * 0.001`
- Capitalized names for improved readability.
- Sorted customers by CLV in descending order.

**Key Decisions:**
- Used `HAVING tenure_months > 0` to avoid divide-by-zero errors.
- Used `JOIN` instead of `LEFT JOIN` since only users with confirmed transactions are required.

---

## Submission Guidelines Followed

- Accurate and correct results  
- Efficient use of CTEs and conditional aggregation  
- Complete handling of edge cases (nulls, inactivity, naming)  
- Well-commented and readable queries  

---



