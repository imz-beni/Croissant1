# Data Dictionary – system_logs
**Owned by: Teta Dianah**  
**Purpose:** Describes each column in the system_logs table and what it stores.

| Column | Data Type | Nullable | Description |
|--------|-----------|----------|-------------|
| log_id | BIGINT | No | Unique ID for each log entry, auto-increments so you dont have to set it manually |
| log_level | ENUM('INFO', 'WARNING', 'ERROR') | No | Shows how serious the log is – INFO means things went fine, WARNING means something was skipped, ERROR means something broke |
| message | VARCHAR(255) | Yes | The actual log message describing what happened during the pipeline |
| logged_at | DATETIME | No | The exact date and time the log was recorded, defaults to when the row was inserted |
