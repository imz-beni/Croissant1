SELECT
    transaction_id,
    momo_tx_id,
    transaction_date,
    transaction_type,
    direction,
    amount,
    fee,
    (amount + fee)  AS total_deducted,
    new_balance
FROM transactions
WHERE transaction_date BETWEEN '2024-05-01 00:00:00'
                           AND '2024-05-31 23:59:59'
ORDER BY transaction_date ASC;


SELECT
    t.transaction_id,
    t.momo_tx_id,
    t.transaction_date,
    t.transaction_type,
    t.amount,
    sender_u.full_name    AS sender_name,
    sender_u.phone        AS sender_phone,
    receiver_u.full_name  AS receiver_name,
    receiver_u.phone      AS receiver_phone
FROM transactions t

LEFT JOIN transaction_participants sender_p
    ON sender_p.transaction_id = t.transaction_id
    AND sender_p.role = 'SENDER'
LEFT JOIN users sender_u
    ON sender_u.user_id = sender_p.user_id

LEFT JOIN transaction_participants receiver_p
    ON receiver_p.transaction_id = t.transaction_id
    AND receiver_p.role = 'RECEIVER'
LEFT JOIN users receiver_u
    ON receiver_u.user_id = receiver_p.user_id

ORDER BY t.transaction_date ASC;


SELECT
    transaction_type,
    direction,
    COUNT(*)        AS total_count,
    SUM(amount)     AS total_amount,
    SUM(fee)        AS total_fees,
    AVG(amount)     AS avg_amount
FROM transactions
GROUP BY transaction_type, direction
ORDER BY total_amount DESC;
