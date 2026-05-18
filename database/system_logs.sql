-- System_Logs table
-- Owned by: Teta Dianah
-- Purpose: Records every SMS processed by the pipeline.
--          Makes failed or unparseable messages traceable
--          instead of silently lost.

CREATE TABLE system_logs (

    log_id    BIGINT        NOT NULL AUTO_INCREMENT,
    log_level ENUM('INFO','WARNING','ERROR') NOT NULL,
    message   VARCHAR(255)  NULL,
    logged_at DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (log_id)

) ENGINE=InnoDB
  COMMENT='Audit trail for the MoMo SMS data pipeline';

  -- Sample data: realistic pipeline log entries
  INSERT INTO system_logs (log_level, message) VALUES
    ('INFO',    'Successfully parsed SMS at index 1 - received transaction'),
    ('INFO',    'Successfully parsed SMS at index 2 - payment transaction'),
    ('WARNING', 'SMS at index 45 matched no known pattern - skipped'),
    ('ERROR',   'SMS at index 67 - malformed date field, could not parse'),
    ('INFO',    'Pipeline completed - 1688 records processed, 3 skipped');

-- CRUD test queries
-- Run one at a time, screenshot each result
-- CREATE: insert a test log entry
INSERT INTO system_logs (log_level, message)
VALUES ('WARNING', 'Test log entry for CRUD verification');

-- READ: see all log entries
SELECT * FROM system_logs;

-- UPDATE: correct the test entry
UPDATE system_logs
SET message = 'Updated test log entry'
WHERE message = 'Test log entry for CRUD verification';

-- Confirm update
SELECT * FROM system_logs WHERE log_level = 'WARNING';

-- DELETE: remove the test entry
DELETE FROM system_logs
WHERE message = 'Updated test log entry';

-- Confirm deletion
SELECT * FROM system_logs;
