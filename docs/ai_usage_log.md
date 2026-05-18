# AI Usage Log | Team Croissant

This log records all AI tool interactions during the MoMo SMS Database
project, per the assignment's AI Usage Policy. AI was used **only** for
permitted purposes: grammar/syntax checking, code **syntax** verification,
and MySQL best-practice research (with citation). The ERD design, SQL
schema logic, entity relationships, and all written explanations and
reflections were produced by team members **without** AI.

---

## A. Code Syntax Verification 

### Entry 1

**Team member:** Nshuti Lancelot
**Tool:** Claude Sonnet
**Permitted category:** Code syntax verification
**Prompt summary:** "Is this foreign key syntax correct in MySQL? `FOREIGN KEY (category_id) REFERENCES transaction_categories(category_id)`"
**AI response summary:** Confirmed syntax is correct. Suggested adding ON DELETE RESTRICT to prevent orphaned records.
**How it was used:** Added ON DELETE RESTRICT to transactions.sql. The relationship and which tables to link were decided by Lancelot from the ERD.

---

### Entry 2

**Team member:** Nshuti Lancelot
**Tool:** Claude Opus
**Permitted category:** Code syntax verification
**Prompt summary:** "Review my transactions.sql for any syntax issues before I commit."
**AI response summary:** Found that the momo_tx_id UNIQUE constraint was missing and ENGINE=InnoDB was not present at the end.
**How it was used:** Fixed both issues himself. All columns, types, and table design were decided by Lancelot.

---

### Entry 3

**Team member:** Imanzi Beni
**Tool:** ChatGPT-4o
**Permitted category:** Code syntax verification
**Prompt summary:** "Review this CREATE TABLE syntax for the users table and tell me if there are any errors."
**AI response summary:** Pointed out a missing NOT NULL on the phone column and suggested DATETIME instead of DATE for created_at.
**How it was used:** Fixed both issues himself in users.sql. The column choices and table design were Beni's own decisions.

---

### Entry 4

**Team member:** Imanzi Beni
**Tool:** Claude Sonnet
**Permitted category:** Code syntax verification
**Prompt summary:** "Check if this indexes.sql syntax is correct. `CREATE INDEX idx_user_phone ON users(phone);`"
**AI response summary:** Syntax is correct. No issues found.
**How it was used:** Committed indexes.sql after confirmation. Which columns to index was decided by Beni from the team's query patterns.

---

### Entry 5

**Team member:** Ishimwe Axcel
**Tool:** ChatGPT-4o
**Permitted category:** Code syntax verification
**Prompt summary:** "Check if this categories.sql syntax is correct." (pasted the CREATE TABLE block)
**AI response summary:** Syntax is correct. No errors found.
**How it was used:** Committed the file after confirmation. The table structure and attributes were designed by Axcel himself.

---

### Entry 6

**Team member:** Teta Dianah
**Tool:** Claude Opus
**Permitted category:** Code syntax verification
**Prompt summary:** "Is this ALTER TABLE syntax correct for adding a CHECK constraint? `ALTER TABLE system_logs ADD CONSTRAINT chk_log_message_not_empty CHECK (LENGTH(message) > 0);`"
**AI response summary:** Syntax is correct. No issues found.
**How it was used:** Used the confirmed syntax as the pattern for all constraints in validation_rules.sql. The rules themselves were decided by Dianah.

---

### Entry 7

**Team member:** Rugwiro Derrick
**Tool:** ChatGPT-4o
**Permitted category:** Code syntax verification
**Prompt summary:** "Check this JSON for syntax errors." (pasted the complex_transaction.json structure)
**AI response summary:** JSON syntax is valid. No errors found.
**How it was used:** Confirmed the structure was valid and expanded it with full transaction fields himself. The JSON design was Derrick's own work.

---

## B. MySQL Best-Practice Research 

### Entry 8

**Team member:** Nshuti Lancelot
**Tool:** Claude Opus
**Permitted category:** MySQL best-practice research
**Prompt summary:** "Can you explain what ON DELETE CASCADE and ON DELETE RESTRICT mean so I can decide which to use?"
**AI response summary:** CASCADE deletes child rows automatically when the parent is deleted. RESTRICT blocks the deletion and throws an error.
**How it was used:** Chose RESTRICT himself because deleting a category should not silently delete transaction records. Decision was Lancelot's.
https://dev.mysql.com/doc/refman/8.0/en/create-table-foreign-keys.html

---

### Entry 9

**Team member:** Nshuti Lancelot
**Tool:** Claude Sonnet
**Permitted category:** MySQL best-practice research
**Prompt summary:** "Should I use DECIMAL or INT for the amount column in the transactions table?"
**AI response summary:** DECIMAL(12,2) is better for money because it stores exact values. INT drops decimals and would lose cents.
**How it was used:** Used DECIMAL(12,2) for amount, fee, and new_balance. The decision was Lancelot's based on the explanation.
https://dev.mysql.com/doc/refman/8.0/en/fixed-point-types.html

---

### Entry 10

**Team member:** Nshuti Lancelot
**Tool:** ChatGPT-4o
**Permitted category:** MySQL best-practice research
**Prompt summary:** "What is the difference between BIGINT and INT for a primary key like transaction_id?"
**AI response summary:** INT holds up to about 2 billion values while BIGINT holds much more. For a transaction table that could grow large, BIGINT is safer.
**How it was used:** Used BIGINT for transaction_id and participant_id. Final decision was Lancelot's.
https://dev.mysql.com/doc/refman/8.0/en/integer-types.html

---

### Entry 11

**Team member:** Nshuti Lancelot
**Tool:** Claude Sonnet
**Permitted category:** MySQL best-practice research
**Prompt summary:** "What does the UNIQUE constraint do and is it different from a PRIMARY KEY?"
**AI response summary:** Both prevent duplicates but a PRIMARY KEY also enforces NOT NULL. UNIQUE allows one NULL and is used for columns that must be unique but are not the main identifier.
**How it was used:** Added UNIQUE to momo_tx_id as the ERD required. The decision came from the team's ERD design.
https://dev.mysql.com/doc/refman/8.0/en/constraint-primary-key.html

---

### Entry 12

**Team member:** Nshuti Lancelot
**Tool:** Claude Opus
**Permitted category:** MySQL best-practice research
**Prompt summary:** "What is a junction table and why do we need one for the many-to-many relationship between transactions and users?"
**AI response summary:** A junction table holds the foreign keys of both tables, resolving a many-to-many into two one-to-many relationships.
**How it was used:** Used the explanation to design transaction_participants himself. The entity and its columns were Lancelot's own design decisions.

---

### Entry 13

**Team member:** Nshuti Lancelot
**Tool:** ChatGPT-4o
**Permitted category:** MySQL best-practice research
**Prompt summary:** "How should I choose the right ENUM values for the direction column in transactions?"
**AI response summary:** ENUM is appropriate for a fixed set of values. Suggested thinking about what directions a MoMo transaction can go without deciding the values.
**How it was used:** Chose ENUM('sent','received') himself based on the XML data patterns. AI did not decide the values.
https://dev.mysql.com/doc/refman/8.0/en/enum.html

---

### Entry 14

**Team member:** Imanzi Beni
**Tool:** Claude Sonnet
**Permitted category:** MySQL best-practice research
**Prompt summary:** "What MySQL best practices should I follow when writing indexes?"
**AI response summary:** Recommended indexing foreign keys and columns used frequently in WHERE clauses. Avoid over-indexing write-heavy tables.
**How it was used:** Applied the advice to write indexes.sql targeting the most queried columns. Which columns to index was Beni's own decision.
https://dev.mysql.com/doc/refman/8.0/en/optimization-indexes.html

---

### Entry 15

**Team member:** Imanzi Beni
**Tool:** Claude Opus
**Permitted category:** MySQL best-practice research
**Prompt summary:** "What should database_setup.sql include beyond just CREATE TABLE statements?"
**AI response summary:** Should include USE database_name, DROP TABLE IF EXISTS for clean setup, and CREATE TABLE in correct dependency order so foreign keys don't fail.
**How it was used:** Restructured database_setup.sql to follow the recommended order himself. The table designs were not generated by AI.

---

### Entry 16

**Team member:** Imanzi Beni
**Tool:** ChatGPT-4o
**Permitted category:** MySQL best-practice research
**Prompt summary:** "What is the difference between ENUM and VARCHAR for the user_type column?"
**AI response summary:** ENUM is better when values are fixed and known in advance. For user_type with a fixed set of roles, ENUM is cleaner and prevents typos.
**How it was used:** Decided to use ENUM for user_type himself after understanding the difference. The values were decided by Beni.
https://dev.mysql.com/doc/refman/8.0/en/enum.html

---

### Entry 17

**Team member:** Imanzi Beni
**Tool:** Claude Sonnet
**Permitted category:** MySQL best-practice research
**Prompt summary:** "Is VARCHAR(20) enough for a Rwandan phone number stored in international format like 250788123456?"
**AI response summary:** 250788123456 is 12 characters so VARCHAR(20) is sufficient and gives room for any formatting variations.
**How it was used:** Kept VARCHAR(20) for the phone column. The column and its purpose were already decided by Beni from the ERD.

---

### Entry 18

**Team member:** Imanzi Beni
**Tool:** Claude Opus
**Permitted category:** MySQL best-practice research
**Prompt summary:** "What does DROP TABLE IF EXISTS do and is it safe to include in database_setup.sql?"
**AI response summary:** Deletes the table if it already exists before recreating it, making the script rerunnable. It also deletes all data in that table.
**How it was used:** Added DROP TABLE IF EXISTS in the correct order (child tables first). The decision was Beni's.

---

### Entry 19

**Team member:** Imanzi Beni
**Tool:** ChatGPT-4o
**Permitted category:** MySQL best-practice research
**Prompt summary:** "How do I make sure my CREATE TABLE statements run in the right order when there are foreign keys?"
**AI response summary:** A table must exist before another table can reference it with a foreign key, so parent tables must be created first.
**How it was used:** Reordered the CREATE TABLE statements himself in database_setup.sql. The table designs were not changed.

---

### Entry 20

**Team member:** Imanzi Beni
**Tool:** Claude Sonnet
**Permitted category:** MySQL best-practice research
**Prompt summary:** "What is the difference between NULL and NOT NULL and when should a column be nullable?"
**AI response summary:** NOT NULL means a value is required on every row. NULL means the field is optional. Required fields like full_name and phone should be NOT NULL.
**How it was used:** Reviewed all columns in users.sql and corrected the nullable settings himself. The decision of which fields are required came from the ERD.
https://dev.mysql.com/doc/refman/8.0/en/data-type-defaults.html

---

### Entry 21

**Team member:** Ishimwe Axcel
**Tool:** Claude Opus
**Permitted category:** MySQL best-practice research
**Prompt summary:** "Can you explain what crow's foot notation means so I can draw the ERD correctly?"
**AI response summary:** Crow's foot represents the many side of a relationship. A single vertical line represents the one side.
**How it was used:** Used the explanation to correctly draw all relationships in Draw.io himself. The ERD design and entities were the team's own work.

---

### Entry 22

**Team member:** Ishimwe Axcel
**Tool:** ChatGPT-4o
**Permitted category:** MySQL best-practice research
**Prompt summary:** "Is the cardinality between transactions and transaction_categories correct if one transaction can only have one category but one category can apply to many transactions?"
**AI response summary:** Confirmed that is a 1:N relationship — one category to many transactions.
**How it was used:** Updated the ERD to correctly show the 1:N cardinality. The relationship design was already decided by the team.

---

### Entry 23

**Team member:** Ishimwe Axcel
**Tool:** Claude Sonnet
**Permitted category:** MySQL best-practice research
**Prompt summary:** "How should I show a junction table in an ERD diagram?"
**AI response summary:** A junction table appears as its own entity with two foreign keys, with many-to-one relationships on both sides.
**How it was used:** Drew transaction_participants as a separate entity with correct FK arrows. The table design was Lancelot's work.

---

### Entry 24

**Team member:** Ishimwe Axcel
**Tool:** Claude Opus
**Permitted category:** MySQL best-practice research
**Prompt summary:** "What attributes should the transaction_categories table have to properly classify MoMo transaction types?"
**AI response summary:** Explained the concept of a category code for machine use and a description for human readability without deciding the values.
**How it was used:** Designed the categories table himself with category_id, category_code, and description. The design decision was Axcel's.

---

### Entry 25

**Team member:** Ishimwe Axcel
**Tool:** ChatGPT-4o
**Permitted category:** MySQL best-practice research
**Prompt summary:** "How should PK and FK be clearly marked in a professional ERD diagram?"
**AI response summary:** PK should be listed first and clearly labelled. FK columns should be listed separately with an arrow pointing to the referenced table.
**How it was used:** Updated the ERD in Draw.io to clearly label all PK and FK columns. The diagram content was Axcel's own work.

---

### Entry 26

**Team member:** Ishimwe Axcel
**Tool:** Claude Sonnet
**Permitted category:** MySQL best-practice research
**Prompt summary:** "What naming convention should I use for category codes like SEND_MONEY or PAYMENT?"
**AI response summary:** UPPER_SNAKE_CASE is standard for codes because it is readable, consistent, and easy to match in queries.
**How it was used:** Used UPPER_SNAKE_CASE for all category code values in categories.sql himself. The values were decided by Axcel from the XML data.

---

### Entry 27

**Team member:** Teta Dianah
**Tool:** Claude Opus
**Permitted category:** MySQL best-practice research
**Prompt summary:** "Can you explain how MySQL CHECK constraints work and what the syntax looks like?"
**AI response summary:** CHECK constraints are rules MySQL enforces on every INSERT and UPDATE. Showed the ALTER TABLE syntax without deciding the rules.
**How it was used:** Used the explanation to decide which constraints to add across the tables and wrote them herself. The rules were Dianah's own decisions.
https://dev.mysql.com/doc/refman/8.0/en/create-table-check-constraints.html

---

### Entry 28

**Team member:** Teta Dianah
**Tool:** ChatGPT-4o
**Permitted category:** MySQL best-practice research
**Prompt summary:** "What is the difference between ENUM and VARCHAR in MySQL so I can decide which to use for log_level?"
**AI response summary:** ENUM restricts the column to a fixed set of values and is more storage-efficient. VARCHAR accepts any string. ENUM is better when values are known and fixed.
**How it was used:** Chose ENUM('INFO','WARNING','ERROR') for log_level herself. The values were decided based on the types of pipeline events.
https://dev.mysql.com/doc/refman/8.0/en/enum.html

---

### Entry 29

**Team member:** Teta Dianah
**Tool:** Claude Sonnet
**Permitted category:** MySQL best-practice research
**Prompt summary:** "What should a system_logs table typically record in a data processing pipeline?"
**AI response summary:** Explained that it should record a log ID, timestamp, severity level, and a message describing what happened, without deciding the exact columns.
**How it was used:** Used the explanation to decide on the four columns for system_logs herself. The final column choices were Dianah's own decisions.

---

### Entry 30

**Team member:** Teta Dianah
**Tool:** Claude Opus
**Permitted category:** MySQL best-practice research
**Prompt summary:** "What does BIGINT AUTO_INCREMENT mean for the log_id column?"
**AI response summary:** BIGINT sets the data type as a large integer. AUTO_INCREMENT makes MySQL assign the next number automatically on each INSERT without needing to provide a value.
**How it was used:** Confirmed the system_logs.sql already had this correct and kept it as is. The column design was already decided from the ERD.
https://dev.mysql.com/doc/refman/8.0/en/example-auto-increment.html

---

### Entry 31

**Team member:** Rugwiro Derrick
**Tool:** ChatGPT-4o
**Permitted category:** MySQL best-practice research
**Prompt summary:** "What are best practices for structuring a complex JSON object that represents a transaction with nested user and category data?"
**AI response summary:** Recommended using nested objects for related entities rather than flat structures, and using consistent key naming.
**How it was used:** Applied the advice to structure complex_transaction.json with proper nesting himself. The field choices were Derrick's own work from the SQL schema.

---

### Entry 32

**Team member:** Rugwiro Derrick
**Tool:** Claude Sonnet
**Permitted category:** MySQL best-practice research
**Prompt summary:** "What should integration tests for a database typically check?"
**AI response summary:** Integration tests should verify that foreign keys work correctly, constraints reject bad data, and joins return expected results.
**How it was used:** Used the explanation to plan and write the test cases in integration_tests.sql himself. The specific tests were Derrick's own decisions.

---

### Entry 33

**Team member:** Rugwiro Derrick
**Tool:** Claude Opus
**Permitted category:** MySQL best-practice research
**Prompt summary:** "How do I write a SQL JOIN query that combines transaction data with category and user data for testing?"
**AI response summary:** Explained the JOIN syntax and the difference between INNER JOIN and LEFT JOIN without writing the query.
**How it was used:** Wrote the JOIN queries himself in integration_tests.sql using the explanation. The logic and test scenarios were Derrick's own decisions.
https://dev.mysql.com/doc/refman/8.0/en/join.html

---

### Entry 34

**Team member:** Rugwiro Derrick
**Tool:** ChatGPT-4o
**Permitted category:** MySQL best-practice research
**Prompt summary:** "How should I document the mapping between SQL table columns and their JSON equivalents?"
**AI response summary:** Suggested a simple table format showing the SQL column name, its data type, and the corresponding JSON key and type side by side.
**How it was used:** Created the mapping table himself in the design document following that format. The content was Derrick's own work.

---

### Entry 35

**Team member:** Rugwiro Derrick
**Tool:** Claude Sonnet
**Permitted category:** MySQL best-practice research
**Prompt summary:** "What makes a good integration test different from a unit test for a database?"
**AI response summary:** A unit test checks one thing in isolation. An integration test checks how multiple parts work together — like whether a transaction INSERT correctly links to a user and category through foreign keys.
**How it was used:** Used the explanation to write more meaningful test cases that tested relationships between tables. The test design was Derrick's own work.

---

## C. Grammar and Spelling Check in Documentation

### Entry 36

**Team member:** Teta Dianah
**Tool:** ChatGPT-4o
**Permitted category:** Grammar/clarity proofread (content authored by human)
**Prompt summary:** "Proofread the data_dictionary_logs.md for typos, don't change the meaning."
**AI response summary:** Minor punctuation fixes only. Content was not changed.
**How it was used:** Accepted punctuation fixes only. All descriptions of columns were written by Dianah herself.

---

## D. Neutral Workflow and Tooling Help 

### Entry 37

**Team member:** Teta Dianah
**Tool:** Claude Opus
**Permitted category:** Git workflow assistance
**Prompt summary:** "How do I connect to MySQL from the terminal on Windows after getting ERROR 2003?"
**AI response summary:** ERROR 2003 means the MySQL service is not running. Use net start MySQL84 to fix it.
**How it was used:** Ran the command herself and connected successfully. No schema, logic, or SQL was generated by AI.

---

### Entry 38

**Team member:** Teta Dianah
**Tool:** ChatGPT-4o
**Permitted category:** Git workflow assistance
**Prompt summary:** "How do I update task statuses on a GitHub Projects board using the command line?"
**AI response summary:** Explained the gh CLI commands for listing and updating project items and their field values.
**How it was used:** Ran the commands herself to move Week 1 tasks to Done and create Week 2 tasks on the Scrum board. No code was generated.

---

### Entry 39

**Team member:** Teta Dianah
**Tool:** Claude Sonnet
**Permitted category:** Git workflow assistance
**Prompt summary:** "How do I push a local branch that doesn't have an upstream set on GitHub?"
**AI response summary:** Use git push --set-upstream origin branch-name to link the local branch to the remote for the first time.
**How it was used:** Ran the command herself and confirmed the branch was pushed. No schema or logic involved.

---

### Entry 40

**Team member:** Rugwiro Derrick
**Tool:** Claude Opus
**Permitted category:** Git workflow assistance
**Prompt summary:** "How do I write an integration test that checks a foreign key constraint actually works?"
**AI response summary:** Try to INSERT a row with a foreign key value that does not exist in the parent table and expect MySQL to reject it with an error.
**How it was used:** Wrote the test himself in integration_tests.sql and verified it threw the expected foreign key error. The test logic and scenario were Derrick's own decisions.

---
