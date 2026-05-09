# MoMo Data Research & Standards

Prepared by Nshuti Lancelot  
Team members: Imanzi Beni, Rugwiro Derrick, Ishimwe Axcel, Teta Diana, Nshuti Lancelot

---

## 1. MoMo XML Data Structure

MTN MoMo SMS exports typically come from Android backup apps (e.g., SMS Backup & Restore). The root format is:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<smses count="1024">
  <sms
    protocol="0"
    address="M-Money"
    date="1693000000000"
    type="1"
    subject="null"
    body="You have received 5,000 RWF from John Doe (0788123456).
          Your new balance: 42,500 RWF. Financial Code: 1234567890.
          Fees: 0 RWF."
    read="1"
    status="-1"
    readable_date="Aug 25, 2023 10:23:14 AM"
    contact_name="M-Money"
  />
  <!-- ... more <sms> elements -->
</smses>
```

### Key XML Attributes

| Attribute       | Type      | Notes                                                  |
|-----------------|-----------|--------------------------------------------------------|
| `address`       | string    | Sender — usually `M-Money`, `MTN MoMo`, or a phone number |
| `date`          | long      | Unix timestamp in **milliseconds**                     |
| `type`          | int       | `1` = received, `2` = sent (most MoMo msgs are type 1) |
| `body`          | string    | The actual SMS text — **primary data source**          |
| `readable_date` | string    | Human-readable, use only as fallback                   |

> **Critical note for `parse_xml.py`:** All useful data lives inside the `body` attribute. Parsing is entirely regex/NLP-based on that text. The other attributes are metadata.

---

## 2. Transaction Categories

Based on analysis of real MTN MoMo Rwanda SMS patterns, here are the **7 core transaction types** the system must handle:

### 2.1 Category Table

| Category ID | Name                  | Trigger Keywords in `body`                                      | Direction  |
|-------------|-----------------------|------------------------------------------------------------------|------------|
| `INCOMING`  | Money Received        | `"you have received"`, `"amaze yawe"`, `"received from"`        | Credit (+) |
| `OUTGOING`  | Money Sent            | `"your payment of"`, `"transferred to"`, `"you have sent"`      | Debit (-)  |
| `AIRTIME`   | Airtime Purchase      | `"airtime"`, `"units"`, `"recharge"`                            | Debit (-)  |
| `CASHOUT`   | Cash Withdrawal       | `"cash out"`, `"withdrawn"`, `"agent"`, `"withdraw at"`         | Debit (-)  |
| `PAYMENT`   | Bill / Merchant Pay   | `"payment to"`, `"paid to"`, `"merchant"`, `"lipa"`             | Debit (-)  |
| `BANK`      | Bank Transfer         | `"bank"`, `"equity"`, `"kcb"`, `"bk"`, `"i&m"`                 | Debit (-)  |
| `UNKNOWN`   | Unclassified          | No keyword match — goes to dead_letter log                       | N/A        |

### 2.2 Sample Body Strings per Category

**INCOMING:**
```
You have received 5,000 RWF from John Doe (0788123456).
Your new balance: 42,500 RWF. Financial Code: 1234567890.
```

**OUTGOING (P2P transfer):**
```
Your payment of 2,000 RWF to Jane Smith (0722334455) has been completed.
New balance: 40,500 RWF. Fee: 50 RWF. Financial Code: 9876543210.
```

**AIRTIME:**
```
You have bought 1,000 RWF of airtime for 0788123456.
New balance: 39,500 RWF. Fee: 0 RWF. Financial Code: 1112223330.
```

**CASHOUT:**
```
You have withdrawn 10,000 RWF from agent Kigali City Agent (100234).
New balance: 29,500 RWF. Fee: 100 RWF. Financial Code: 4445556660.
```

**PAYMENT (merchant / bill):**
```
Your payment of 3,500 RWF to MTN Bill Payment (WASAC) has been completed.
New balance: 26,000 RWF. Fee: 0 RWF. Financial Code: 7778889990.
```

**BANK:**
```
Your transfer of 20,000 RWF to Bank of Kigali has been completed.
New balance: 6,000 RWF. Fee: 200 RWF. Financial Code: 2223334440.
```

---

## 3. Fields to Extract per Transaction

These are the normalized fields the ETL pipeline (`clean_normalize.py`) should produce from each `body` string:

| Field              | Type      | Example                  | Notes                                          |
|--------------------|-----------|--------------------------|------------------------------------------------|
| `transaction_id`   | string PK | `"TXN-1234567890"`       | From "Financial Code"; prefix with `TXN-`      |
| `raw_date`         | string    | `"Aug 25, 2023 10:23 AM"`| Original `readable_date` attribute             |
| `timestamp`        | datetime  | `2023-08-25T10:23:14`    | Parsed from `date` (ms) or `readable_date`     |
| `type`             | enum      | `"INCOMING"`             | One of the 7 categories above                  |
| `amount`           | float     | `5000.00`                | Strip commas, cast to float                    |
| `currency`         | string    | `"RWF"`                  | Always `RWF` for Rwanda; keep for future-proofing |
| `fee`              | float     | `50.00`                  | `0.0` if absent                                |
| `balance_after`    | float     | `42500.00`               | "New balance" / "Your new balance"             |
| `counterpart_name` | string    | `"John Doe"`             | Sender/recipient name; `NULL` if absent        |
| `counterpart_phone`| string    | `"+250788123456"`        | Normalize to E.164 format (`+250...`)          |
| `raw_body`         | text      | `"You have received ..."` | Original SMS body; always store for audit      |
| `is_valid`         | boolean   | `true`                   | False if key fields missing → dead_letter      |

---

## 4. Normalization Rules (`clean_normalize.py`)

### 4.1 Amounts
```
"5,000 RWF"  →  5000.0
"1.500 RWF"  →  1500.0   (some locales use period as thousands sep)
```
Strip all commas and non-numeric chars before casting.

### 4.2 Phone Numbers
```
"0788123456"     →  "+250788123456"
"250788123456"   →  "+250788123456"
"+250788123456"  →  "+250788123456"  (already valid)
```
Rwanda country code: `+250`. Strip leading `0` and prepend `+250`.

### 4.3 Dates
- Primary: parse `date` attribute (Unix ms → divide by 1000 → `datetime.fromtimestamp()`)
- Fallback: parse `readable_date` string using `python-dateutil`
- Store as ISO 8601: `YYYY-MM-DDTHH:MM:SS`

### 4.4 Financial Code → Transaction ID
```
"Financial Code: 1234567890"  →  transaction_id = "TXN-1234567890"
```
If no Financial Code is found, generate a hash: `md5(body + date)[:10]` and flag `is_valid = false`.

---

## 5. Proposed Database Schema (SQLite)

### Table: `transactions`

```sql
CREATE TABLE IF NOT EXISTS transactions (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    transaction_id  TEXT UNIQUE NOT NULL,        -- "TXN-1234567890"
    timestamp       TEXT NOT NULL,               -- ISO 8601
    type            TEXT NOT NULL,               -- INCOMING | OUTGOING | AIRTIME | CASHOUT | PAYMENT | BANK | UNKNOWN
    amount          REAL NOT NULL DEFAULT 0.0,
    currency        TEXT NOT NULL DEFAULT 'RWF',
    fee             REAL NOT NULL DEFAULT 0.0,
    balance_after   REAL,
    counterpart_name  TEXT,
    counterpart_phone TEXT,
    raw_body        TEXT NOT NULL,
    is_valid        INTEGER NOT NULL DEFAULT 1,  -- SQLite has no BOOLEAN; 1=true, 0=false
    created_at      TEXT DEFAULT (datetime('now'))
);
```

### Table: `etl_runs`

Tracks each time the pipeline runs — useful for dashboards and debugging.

```sql
CREATE TABLE IF NOT EXISTS etl_runs (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    run_at          TEXT DEFAULT (datetime('now')),
    source_file     TEXT NOT NULL,
    total_parsed    INTEGER DEFAULT 0,
    total_loaded    INTEGER DEFAULT 0,
    total_failed    INTEGER DEFAULT 0,
    status          TEXT DEFAULT 'SUCCESS'       -- SUCCESS | PARTIAL | FAILED
);
```

### Table: `dead_letters`

Rows that failed parsing — never discard SMS data.

```sql
CREATE TABLE IF NOT EXISTS dead_letters (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    raw_body    TEXT NOT NULL,
    raw_date    TEXT,
    fail_reason TEXT,
    logged_at   TEXT DEFAULT (datetime('now'))
);
```

### Recommended Indexes

```sql
CREATE INDEX idx_transactions_type      ON transactions(type);
CREATE INDEX idx_transactions_timestamp ON transactions(timestamp);
CREATE INDEX idx_transactions_valid     ON transactions(is_valid);
```

---

## 6. Dashboard JSON Structure (`data/processed/dashboard.json`)

This is what the frontend reads. The ETL pipeline exports it after every run.

```json
{
  "generated_at": "2024-01-15T09:00:00",
  "summary": {
    "total_transactions": 1024,
    "total_volume_rwf": 4850000.0,
    "total_fees_rwf": 12300.0,
    "date_range": { "from": "2023-01-01", "to": "2024-01-01" }
  },
  "by_type": [
    { "type": "INCOMING",  "count": 310, "total_amount": 1800000.0 },
    { "type": "OUTGOING",  "count": 280, "total_amount": 1400000.0 },
    { "type": "AIRTIME",   "count": 200, "total_amount": 350000.0  },
    { "type": "CASHOUT",   "count": 130, "total_amount": 900000.0  },
    { "type": "PAYMENT",   "count": 80,  "total_amount": 280000.0  },
    { "type": "BANK",      "count": 20,  "total_amount": 120000.0  },
    { "type": "UNKNOWN",   "count": 4,   "total_amount": 0.0       }
  ],
  "monthly_volume": [
    { "month": "2023-08", "credit": 320000.0, "debit": 280000.0 }
  ]
}
```

---


