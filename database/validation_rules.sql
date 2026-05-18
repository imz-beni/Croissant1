-- Validation rules for momo_db
-- Owned by: Teta Dianah
-- Purpose: Adding CHECK constraints to make sure wrong data doesn't get saved.
--          I added rules for users, transaction_categories and system_logs.
--          The transactions table constraints are already in database_setup.sql.
--          Make sure all tables exist before running this.

USE momo_db;

-- phone number must be at least 10 digits like 0788123456
ALTER TABLE users
  ADD CONSTRAINT chk_phone_length CHECK (LENGTH(phone) >= 10);

-- name cant be empty, every user needs a name
ALTER TABLE users
  ADD CONSTRAINT chk_name_not_empty CHECK (LENGTH(full_name) > 0);

-- category code like SEND_MONEY cant be left empty
ALTER TABLE transaction_categories
  ADD CONSTRAINT chk_category_code_not_empty CHECK (LENGTH(category_code) > 0);

-- log message should not be empty, otherwise the log means nothing
ALTER TABLE system_logs
  ADD CONSTRAINT chk_log_message_not_empty CHECK (LENGTH(message) > 0);
