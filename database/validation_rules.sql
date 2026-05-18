-- Validation rules for momo_db
-- Owned by: Teta Dianah
-- Purpose: Adding CHECK constraints to make sure wrong data doesn't get saved.
--          I added rules for Transactions, Users,
--          Transaction_Categories and system_logs.
--          Make sure all tables exist before running this.

USE momo_db;

-- amount has to be more than 0, you cant send nothing
ALTER TABLE Transactions
  ADD CONSTRAINT chk_amount_positive CHECK (amount > 0);

-- fee cant be negative, 0 is fine for free transfers
ALTER TABLE Transactions
  ADD CONSTRAINT chk_fee_non_negative CHECK (fee >= 0);

-- balance shouldnt go below 0 after a transaction
ALTER TABLE Transactions
  ADD CONSTRAINT chk_balance_non_negative CHECK (new_balance >= 0);

-- phone number must be at least 10 digits like 0788123456
ALTER TABLE Users
  ADD CONSTRAINT chk_phone_length CHECK (LENGTH(phone) >= 10);

-- name cant be empty, every user needs a name
ALTER TABLE Users
  ADD CONSTRAINT chk_name_not_empty CHECK (LENGTH(full_name) > 0);

-- category code like SEND_MONEY cant be left empty
ALTER TABLE Transaction_Categories
  ADD CONSTRAINT chk_category_code_not_empty CHECK (LENGTH(category_code) > 0);

-- log message should not be empty, otherwise the log means nothing
ALTER TABLE system_logs
  ADD CONSTRAINT chk_log_message_not_empty CHECK (LENGTH(message) > 0);
