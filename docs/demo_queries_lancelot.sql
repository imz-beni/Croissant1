SELECT
    transaction_id,
    transaction_datetime,
    transaction_type,
    amount,
    fee,
    (amount + fee)    AS total_deducted,
    balance_after
FROM transactions
WHERE transaction_datetime BETWEEN '2024-05-01 00:00:00'
                               AND '2024-05-31 23:59:59'
ORDER BY transaction_datetime ASC;



SELECT
    t.transaction_id,
    t.transaction_datetime,
    t.transaction_type,
    t.amount,
    sender_u.full_name    AS sender_name,
    sender_u.phone_number AS sender_phone,
    receiver_u.full_name  AS receiver_name,
    receiver_u.phone_number AS receiver_phone
FROM transactions t

LEFT JOIN transaction_user_roles sender_role
    ON sender_role.transaction_id = t.transaction_id
    AND sender_role.role = 'SENDER'
LEFT JOIN users sender_u
    ON sender_u.user_id = sender_role.user_id

LEFT JOIN transaction_user_roles receiver_role
    ON receiver_role.transaction_id = t.transaction_id
    AND receiver_role.role = 'RECEIVER'
LEFT JOIN users receiver_u
    ON receiver_u.user_id = receiver_role.user_id

ORDER BY t.transaction_datetime ASC;


