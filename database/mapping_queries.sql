SELECT JSON_OBJECT(
  'transaction_id', t.transaction_id,
  'momo_tx_id',     t.momo_tx_id,
  'amount',         t.amount,
  'fee',            t.fee,
  'new_balance',    t.new_balance,
  'direction',      t.direction,
  'category', JSON_OBJECT(
    'category_id',   c.category_id,
    'category_code', c.category_code
  ),
  'log', JSON_OBJECT(
    'log_id',    l.log_id,
    'log_level', l.log_level,
    'message',   l.message
  )
) AS transaction_json
FROM Transactions t
JOIN Transaction_Categories c ON t.category_id = c.category_id
LEFT JOIN System_Logs l ON t.log_id = l.log_id
WHERE t.transaction_id = 1;
