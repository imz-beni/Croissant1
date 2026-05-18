# Design Rationale
**Author:** Nshuti Lancelot — Schema Lead, Week 2
**Project:** Croissant MoMo SMS Data Pipeline

## Why These Entities?

The source data is 1,693 free-text SMS messages, each describing one financial event. To model this cleanly, we need at least four entities. **Transactions** is the core: it captures every parsed event with its amount, fee, balance, datetime, and the raw SMS body for auditability. **Users** stores every distinct person or business that appears as a sender or receiver across messages — account owner, named contacts like Jane Smith and Samuel Carter, and merchant entities like ITEC Ltd. **Transaction_Categories** provides a lookup table for grouping transaction types into reporting buckets (e.g. Income, Expense, Utility). **System_Logs** records pipeline events — parse failures, validation warnings, import runs — essential for operational monitoring in any data pipeline.

## Why This Relationship Structure?

Transactions sits at the centre. It holds a foreign key to `transaction_categories`, since each transaction belongs to exactly one category. The more interesting relationship is between Transactions and Users: a single transaction can involve two users simultaneously — a sender and a receiver. Storing `sender_user_id` and `receiver_user_id` as two hard-coded columns on Transactions would work for simple cases but breaks down if a transaction ever involves a third party, or if we need to query "every transaction that touched user X regardless of role." A many-to-many resolved with a junction table handles all of this without any schema changes.

## The Junction Table

`transaction_user_roles` holds the triple (transaction_id, user_id, role). The `role` column is an ENUM — SENDER, RECEIVER, ACCOUNT_OWNER, DEPOSITOR — making role-specific queries straightforward. The UNIQUE constraint on (transaction_id, user_id, role) prevents duplicate participation records.

## Trade-offs Considered

Storing `raw_sms_body` on every Transactions row adds storage overhead, but preserves the ability to re-parse when parsing logic improves — a worthwhile trade for a pipeline that processes natural-language input. Using a BIGINT primary key (the MTN transaction ID) instead of AUTO_INCREMENT ties the database identity directly to the source system, eliminating surrogate-key lookups during import. The risk is collision if two message types use overlapping ID spaces; for bank deposits and transfers without an explicit txId, the sms Unix timestamp is used as a surrogate, which is unique within the dataset.

## Data Type Decisions

Money values use `DECIMAL(12,2)` rather than `FLOAT` or `DOUBLE`. This is a deliberate choice: floating-point types cannot represent decimal fractions exactly in binary, meaning a value like 1000.10 RWF could be stored internally as 1000.0999999... and produce rounding errors when summed across thousands of rows. `DECIMAL(12,2)` stores exact fixed-point values, which is a hard requirement for any financial system. The precision of 12 digits total allows amounts up to 9,999,999,999.99 RWF — well beyond any realistic MoMo transaction. Transaction IDs from MTN can exceed standard INT range (max ~2.1 billion), so `BIGINT` is the correct type, supporting values up to ~9.2 quadrillion. All timestamps use `DATETIME` rather than `TIMESTAMP` because `TIMESTAMP` in MySQL is limited to the year 2038 and is subject to timezone conversion — `DATETIME` stores the literal value exactly as parsed from the SMS body.
