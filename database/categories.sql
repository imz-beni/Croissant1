-- transaction_categories table
-- Owned by: Ishimwe Axcel
-- Purpose: Stores the 8 distinct MoMo transaction types
--          found in the XML data. Other tables reference
--          this one instead of storing the type as free text.

CREATE TABLE transaction_categories (
    category_id INT NOT NULL AUTO_INCREMENT,
    category_code VARCHAR(30) NOT NULL,
    description VARCHAR(120) NULL,


    -- Primary key: every row gets a unique number automatically
    PRIMARY KEY (category_id),

    -- Unique: two categories cannot have the same code
    UNIQUE KEY uq_category_code (category_code)

) ENGINE=InnoDB
  COMMENT='Lookup table for MoMo SMS transaction types';

-- seed data: the 8 transaction types found in the XML
INSERT INTO transaction_categories(category_code, description) VALUES
    ('received',         'money received from another momo user'),
    ('payment',            'outgoing payment to another person'),
    ('transfer',           'money transfer to a phone number'),
    ('bank deposit',       'cash deposited into momo from bank'),
    ('airtime',            'Airtime purchase using MoMo balance'),
    ('direct_payment',     'Payment processed by a merchant or business'),
    ('withdrawal',         'Cash withdrawn from MoMo via an agent'),
    ('bank_transfer',      'Transfer from MoMo to a bank account');

-- CRUD test queries
-- Run these one at a time to verify the table works.
-- Take a screenshot of each result for the PDF.

-- CREATE: insert a test row
INSERT INTO transaction_categories (category_code, description)
VALUES ('test_type', 'Temporary test category');

-- READ: see everything in the table
SELECT * FROM transaction_categories;

-- UPDATE: change the test row's description
UPDATE transaction_categories
SET description = 'Updated test description'
WHERE category_code = 'test_type';

-- Confirm the update worked
SELECT * FROM transaction_categories WHERE category_code = 'test_type';

-- DELETE: remove the test row
DELETE FROM transaction_categories
WHERE category_code = 'test_type';

-- Confirm it's gone
SELECT * FROM transaction_categories;