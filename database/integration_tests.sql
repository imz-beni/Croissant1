-- Step 1: Insert a user
INSERT INTO Users (full_name, phone, user_type)
VALUES ('Test User', '250788000001', 'CUSTOMER');

-- Step 2: Insert a log
INSERT INTO System_Logs (log_level, message)
VALUES ('INFO', 'Test transaction parsed successfully');

-- Step 3: Insert a transaction
INSERT INTO Transactions (
  momo_tx_id, category_id, amount, fee,
  new_balance, direction, counterparty_name,
  transaction_date, raw_body, log_id,
  sms_unix_timestamp
)
VALUES (
  99999999999, 1, 5000.00, 100.00,
  28300.00, 'DEBIT', 'Test User',
  '2024-05-11 20:34:47',
  '5000 RWF transferred to Test User',
  LAST_INSERT_ID(),
  UNIX_TIMESTAMP('2024-05-11 20:34:47')
);

-- Step 4: Select with joins
SELECT 
  t.transaction_id,
  t.amount,
  t.direction,
  c.category_code,
  l.log_level
FROM Transactions t
JOIN Transaction_Categories c ON t.category_id = c.category_id
LEFT JOIN System_Logs l ON t.log_id = l.log_id
WHERE t.momo_tx_id = 99999999999;

-- Step 5: Update the transaction
UPDATE Transactions
SET amount = 9000.00
WHERE momo_tx_id = 99999999999;

-- Step 6: Insert a participant
INSERT INTO Transaction_Participants (transaction_id, user_id, role)
VALUES (LAST_INSERT_ID(), 1, 'SENDER');

-- Step 7: Delete the transaction
DELETE FROM Transactions
WHERE momo_tx_id = 99999999999;

-- Step 8: Confirm participants were deleted
SELECT * FROM Transaction_Participants
WHERE transaction_id = 1;

