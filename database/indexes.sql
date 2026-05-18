-- =============================================================
-- Team Croissant · MoMo SMS Data Pipeline
-- File: database/indexes.sql
-- Owner: Imanzi Beni
-- Description: All indexes for the full database.
-- =============================================================

-- USERS
-- Speeds up matching a counterparty phone number from an SMS
-- to an existing user record during ETL ingestion
CREATE INDEX idx_users_phone
    ON users(phone);

-- TRANSACTIONS
-- Speeds up date range queries e.g. all transactions in May 2024
CREATE INDEX idx_transactions_date
    ON transactions(transaction_date);

-- Speeds up filtering by transaction type e.g. all transfers
CREATE INDEX idx_transactions_category
    ON transactions(category_id);

-- Speeds up filtering by money direction e.g. all credits vs debits
CREATE INDEX idx_transactions_direction
    ON transactions(direction);

-- TRANSACTION_PARTICIPANTS
-- Speeds up finding all transactions a specific user was involved in
CREATE INDEX idx_participants_user_id
    ON transaction_participants(user_id);

-- Speeds up finding all participants linked to a specific transaction
CREATE INDEX idx_participants_transaction_id
    ON transaction_participants(transaction_id);

-- SYSTEM_LOGS
-- Speeds up filtering log entries by severity level
CREATE INDEX idx_logs_level
    ON system_logs(log_level);

-- Speeds up time-based log queries
CREATE INDEX idx_logs_logged_at
    ON system_logs(logged_at);