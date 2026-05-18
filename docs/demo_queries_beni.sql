-- =============================================================
-- Team Croissant · MoMo SMS Data Pipeline
-- File: docs/demo_queries_beni.sql
-- Owner: Imanzi Beni
-- Description: Demo queries focused on the Users table
-- =============================================================

-- SCREENSHOT 1: SELECT — see all rows
SELECT * FROM users;

-- SCREENSHOT 2: UPDATE — change a value
UPDATE users SET phone = '250781111111' WHERE full_name = 'Jane Smith';
SELECT * FROM users WHERE full_name = 'Jane Smith';

-- SCREENSHOT 3: INSERT — add a new row
INSERT INTO users (full_name, phone, user_type) 
VALUES ('Test User', '250799999999', 'CUSTOMER');
SELECT * FROM users;

-- SCREENSHOT 4: DELETE — remove that test row
DELETE FROM users WHERE full_name = 'Test User';
SELECT * FROM users;