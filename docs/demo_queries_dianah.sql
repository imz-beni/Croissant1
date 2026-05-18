-- Demo queries for system_logs
-- Owned by: Teta Dianah
-- Purpose: Showing some useful queries you can run on the system_logs table.
--          These help you see what happened during the pipeline.

USE momo_db;

-- show all log entries so you can see everything that was recorded
SELECT * FROM system_logs;

-- show only errors and warnings so you can find what went wrong
SELECT * FROM system_logs
WHERE log_level IN ('ERROR', 'WARNING');
