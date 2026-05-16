# Data Dictionary
**Author:** Nshuti Lancelot — Schema Lead
**Tables covered:** `transactions`, `transaction_user_roles`

---

## Table: `transactions`

| Column | Data Type | Nullable | Constraints | Description |
|---|---|---|---|---|
| `transaction_id` | BIGINT | NO | PRIMARY KEY | Financial Transaction Id or TxId extracted directly from the SMS body. For messages without an explicit ID (bank deposits, *165* transfers), the SMS Unix timestamp is used as a surrogate. |
| `sms_unix_timestamp` | BIGINT | NO | — | Raw Unix timestamp in milliseconds from the XML `date` attribute. Retained for tracing back to the original XML record. |
| `transaction_datetime` | DATETIME | NO | INDEX | Human-readable datetime string parsed out of the SMS body text (e.g. `2024-05-10 16:30:51`). This is the actual event time, not the SMS delivery time. |
| `transaction_type` | ENUM | NO | — | Pattern-matched category of the transaction. Values: `INCOMING`, `MERCHANT_PAYMENT`, `BANK_DEPOSIT`, `TRANSFER_SENT`, `AIRTIME`, `BUNDLE`, `MERCHANT_DEBIT`, `AGENT_WITHDRAWAL`. |
| `amount` | DECIMAL(12,2) | NO | CHECK >= 0 | Transaction principal amount in RWF. |
| `fee` | DECIMAL(12,2) | NO | DEFAULT 0.00, CHECK >= 0 | Fee charged by MTN in RWF. Zero for most merchant payments and incoming transfers. |
| `balance_after` | DECIMAL(12,2) | NO | CHECK >= 0 | Account balance immediately after this transaction, as reported in the SMS. |
| `sender_name` | VARCHAR(100) | YES | — | Full name of the sender as it appears in the SMS. NULL for bank deposits (no named sender) and outgoing payment types where the account owner is implied. |
| `sender_phone` | VARCHAR(20) | YES | — | Sender's phone number. May be partially masked (e.g. `*********013`). |
| `receiver_name` | VARCHAR(100) | YES | — | Full name of the payment receiver. NULL for incoming transactions where only the account owner is the recipient. |
| `receiver_phone` | VARCHAR(20) | YES | — | Receiver's phone number as it appears in parentheses in transfer messages. |
| `receiver_code` | VARCHAR(20) | YES | — | Short numeric code appended after the receiver name in merchant payment messages (e.g. `12845` in `Jane Smith 12845`). |
| `token` | VARCHAR(100) | YES | — | Token string returned for airtime or Cash Power purchases. Empty string when the SMS includes the token field but no value was returned. |
| `external_tx_id` | VARCHAR(100) | YES | — | External UUID present only in merchant debit messages (`*164*`). Example: `c5e8bfeb-33d8-4eb2-8d22-154e5ff5e310`. |
| `category_id` | INT | NO | FK → transaction_categories | Groups this transaction into a reporting category for dashboards and aggregates. |
| `raw_sms_body` | TEXT | NO | — | The complete unmodified SMS body string. Retained for re-parsing, auditing, and debugging. |
| `created_at` | DATETIME | NO | DEFAULT CURRENT_TIMESTAMP | Timestamp when this row was inserted into the database by the pipeline. |

---

## Table: `transaction_user_roles`

| Column | Data Type | Nullable | Constraints | Description |
|---|---|---|---|---|
| `role_id` | INT | NO | PRIMARY KEY, AUTO_INCREMENT | Surrogate primary key for this participation record. |
| `transaction_id` | BIGINT | NO | FK → transactions, INDEX | References the transaction this role record belongs to. Cascades on delete — if a transaction is removed, its role records are removed too. |
| `user_id` | INT | NO | FK → users, INDEX | References the user involved in this transaction. RESTRICT on delete — a user cannot be deleted while they still appear in any transaction. |
| `role` | ENUM | NO | UNIQUE with (transaction_id, user_id) | The role this user played. Values: `SENDER` — initiator of the outgoing payment; `RECEIVER` — recipient of funds; `ACCOUNT_OWNER` — the primary MoMo account holder (used for bank deposits and airtime where there is no named external party); `DEPOSITOR` — cash deposit agent. |
| `created_at` | DATETIME | NO | DEFAULT CURRENT_TIMESTAMP | Timestamp when this participation record was inserted. |
