-- Demo Queries: Transaction_Categories
-- Owned by: Ishimwe Axcel

-- Query 1: View all transaction categories in the system
-- Use case: a dashboard dropdown listing all available types

SELECT
    category_id,
    category_code,
    description
FROM transaction_categories
ORDER BY category_id ASC;

-- Query 2: Count transactions per category type
-- Use case: shows which transaction types are most common
-- Demonstrates the relationship between transaction_categories
-- and transactions via the category_id foreign key

SELECT
    tc.category_code,
    tc.description,
    COUNT(t.transaction_id)  AS transaction_count,
    SUM(t.amount)            AS total_amount_rwf
FROM transaction_categories tc
LEFT JOIN transactions t ON tc.category_id = t.category_id
GROUP BY tc.category_id, tc.category_code, tc.description
ORDER BY transaction_count DESC;