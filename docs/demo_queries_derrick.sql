-- Query 1: Total transactions per category
SELECT 
  c.category_code,
  COUNT(t.transaction_id) AS total_transactions,
  SUM(t.amount) AS total_amount_rwf
FROM Transactions t
JOIN Transaction_Categories c ON t.category_id = c.category_id
GROUP BY c.category_code
ORDER BY total_amount_rwf DESC;

-- Query 2: Top 5 users by transaction volume
SELECT 
  u.full_name,
  u.user_type,
  COUNT(tp.transaction_id) AS total_transactions
FROM Users u
JOIN Transaction_Participants tp ON u.user_id = tp.user_id
GROUP BY u.user_id
ORDER BY total_transactions DESC
LIMIT 5;

-- Query 3: Daily transaction counts
SELECT 
  DATE(transaction_date) AS day,
  COUNT(*) AS total_transactions,
  SUM(amount) AS total_amount_rwf
FROM Transactions
GROUP BY DATE(transaction_date)
ORDER BY day;
