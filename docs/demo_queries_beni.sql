-- =============================================================
-- Team Croissant · MoMo SMS Data Pipeline
-- File: docs/demo_queries_beni.sql
-- Owner: Imanzi Beni
-- Description: Demo queries focused on the Users table
-- =============================================================

-- Query 1: List all users ranked by total number of transactions
-- they appear in, highest first.
-- Demonstrates JOIN between users and transaction_participants.

SELECT
    u.user_id,
    u.full_name,
    u.phone,
    u.user_type,
    COUNT(tp.transaction_id) AS total_transactions
FROM users u
LEFT JOIN transaction_participants tp
    ON u.user_id = tp.user_id
GROUP BY
    u.user_id,
    u.full_name,
    u.phone,
    u.user_type
ORDER BY total_transactions DESC;


-- Query 2: Find users who have never appeared in any transaction.
-- Demonstrates LEFT JOIN with NULL check.
-- Useful for identifying orphan user records after ingestion.

SELECT
    u.user_id,
    u.full_name,
    u.phone,
    u.user_type,
    u.created_at
FROM users u
LEFT JOIN transaction_participants tp
    ON u.user_id = tp.user_id
WHERE tp.transaction_id IS NULL;