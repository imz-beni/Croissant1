CREATE TABLE IF NOT EXISTS transactions (
    transaction_id       BIGINT          NOT NULL COMMENT 'Financial Transaction Id or TxId extracted from SMS body',
    sms_unix_timestamp   BIGINT          NOT NULL COMMENT 'Raw Unix timestamp (ms) from the XML date attribute',
    transaction_datetime DATETIME        NOT NULL COMMENT 'Human-readable datetime parsed from the SMS body text',
    transaction_type     ENUM(
                            'INCOMING',
                            'MERCHANT_PAYMENT',
                            'BANK_DEPOSIT',
                            'TRANSFER_SENT',
                            'AIRTIME',
                            'BUNDLE',
                            'MERCHANT_DEBIT',
                            'AGENT_WITHDRAWAL'
                         )               NOT NULL COMMENT 'Category of transaction derived from SMS pattern matching',
    amount               DECIMAL(12,2)   NOT NULL COMMENT 'Transaction amount in RWF',
    fee                  DECIMAL(12,2)   NOT NULL DEFAULT 0.00 COMMENT 'Fee charged in RWF; 0 when not applicable',
    balance_after        DECIMAL(12,2)   NOT NULL COMMENT 'Account balance immediately after this transaction (RWF)',
    sender_name          VARCHAR(100)    NULL     COMMENT 'Full name of sender as it appears in SMS body; NULL for deposits',
    sender_phone         VARCHAR(20)     NULL     COMMENT 'Sender phone number; may be masked (e.g. *********013)',
    receiver_name        VARCHAR(100)    NULL     COMMENT 'Full name of receiver; NULL for incoming transactions',
    receiver_phone       VARCHAR(20)     NULL     COMMENT 'Receiver phone number; NULL for incoming or deposit',
    receiver_code        VARCHAR(20)     NULL     COMMENT 'Merchant/agent short code appended after receiver name in payment SMS',
    token                VARCHAR(100)    NULL     COMMENT 'Token string for airtime or Cash Power purchases; NULL otherwise',
    external_tx_id       VARCHAR(100)    NULL     COMMENT 'External transaction UUID present in merchant debit (*164*) messages',
    category_id          INT             NOT NULL COMMENT 'FK to transaction_categories.category_id for reporting grouping',
    raw_sms_body         TEXT            NOT NULL COMMENT 'Original unmodified SMS body text for audit and re-parsing',
    created_at           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Row insertion timestamp',

    PRIMARY KEY (transaction_id),

    CONSTRAINT chk_amount_positive     CHECK (amount       >= 0),
    CONSTRAINT chk_fee_non_negative    CHECK (fee          >= 0),
    CONSTRAINT chk_balance_non_negative CHECK (balance_after >= 0),

    FOREIGN KEY (category_id)
        REFERENCES transaction_categories(category_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    INDEX idx_transaction_datetime (transaction_datetime),
    INDEX idx_transaction_type     (transaction_type),
    INDEX idx_category_id          (category_id)

) COMMENT 'One row per parsed MoMo SMS transaction';



INSERT IGNORE INTO transactions (
    transaction_id, sms_unix_timestamp, transaction_datetime,
    transaction_type, amount, fee, balance_after,
    sender_name, sender_phone, receiver_name, receiver_phone,
    receiver_code, token, external_tx_id, category_id, raw_sms_body
) VALUES (
    76662021700, 1715351458724, '2024-05-10 16:30:51',
    'INCOMING', 2000.00, 0.00, 2000.00,
    'Jane Smith', '*********013', NULL, NULL,
    NULL, NULL, NULL, 1,
    'You have received 2000 RWF from Jane Smith (*********013) on your mobile money account at 2024-05-10 16:30:51. Message from sender: . Your new balance:2000 RWF. Financial Transaction Id: 76662021700.'
);


INSERT IGNORE INTO transactions (
    transaction_id, sms_unix_timestamp, transaction_datetime,
    transaction_type, amount, fee, balance_after,
    sender_name, sender_phone, receiver_name, receiver_phone,
    receiver_code, token, external_tx_id, category_id, raw_sms_body
) VALUES (
    73214484437, 1715351506754, '2024-05-10 16:31:39',
    'MERCHANT_PAYMENT', 1000.00, 0.00, 1000.00,
    NULL, NULL, 'Jane Smith', NULL,
    '12845', NULL, NULL, 2,
    'TxId: 73214484437. Your payment of 1,000 RWF to Jane Smith 12845 has been completed at 2024-05-10 16:31:39. Your new balance: 1,000 RWF. Fee was 0 RWF.'
);


INSERT IGNORE INTO transactions (
    transaction_id, sms_unix_timestamp, transaction_datetime,
    transaction_type, amount, fee, balance_after,
    sender_name, sender_phone, receiver_name, receiver_phone,
    receiver_code, token, external_tx_id, category_id, raw_sms_body
) VALUES (
    1715445936412, 1715445936412, '2024-05-11 18:43:49',
    'BANK_DEPOSIT', 40000.00, 0.00, 40400.00,
    NULL, '250795963036', NULL, NULL,
    NULL, NULL, NULL, 3,
    '*113*R*A bank deposit of 40000 RWF has been added to your mobile money account at 2024-05-11 18:43:49. Your NEW BALANCE :40400 RWF. Cash Deposit::CASH::::0::250795963036.Thank you for using MTN MobileMoney.*EN#'
);


INSERT IGNORE INTO transactions (
    transaction_id, sms_unix_timestamp, transaction_datetime,
    transaction_type, amount, fee, balance_after,
    sender_name, sender_phone, receiver_name, receiver_phone,
    receiver_code, token, external_tx_id, category_id, raw_sms_body
) VALUES (
    1715452495316, 1715452495316, '2024-05-11 20:34:47',
    'TRANSFER_SENT', 10000.00, 100.00, 28300.00,
    NULL, '36521838', 'Samuel Carter', '250791666666',
    NULL, NULL, NULL, 4,
    '*165*S*10000 RWF transferred to Samuel Carter (250791666666) from 36521838 at 2024-05-11 20:34:47 . Fee was: 100 RWF. New balance: 28300 RWF.'
);


INSERT IGNORE INTO transactions (
    transaction_id, sms_unix_timestamp, transaction_datetime,
    transaction_type, amount, fee, balance_after,
    sender_name, sender_phone, receiver_name, receiver_phone,
    receiver_code, token, external_tx_id, category_id, raw_sms_body
) VALUES (
    13913173274, 1715506895734, '2024-05-12 11:41:28',
    'AIRTIME', 2000.00, 0.00, 25280.00,
    NULL, NULL, 'Airtime', NULL,
    NULL, '', NULL, 5,
    '*162*TxId:13913173274*S*Your payment of 2000 RWF to Airtime with token  has been completed at 2024-05-12 11:41:28. Fee was 0 RWF. Your new balance: 25280 RWF . Message: - -. *EN#'
);


INSERT IGNORE INTO transactions (
    transaction_id, sms_unix_timestamp, transaction_datetime,
    transaction_type, amount, fee, balance_after,
    sender_name, sender_phone, receiver_name, receiver_phone,
    receiver_code, token, external_tx_id, category_id, raw_sms_body
) VALUES (
    14262449979, 1717683548224, '2024-06-06 16:19:01',
    'MERCHANT_DEBIT', 600.00, 0.00, 230.00,
    NULL, NULL, 'INFORMATION TECHNOLOGY ENGINEERING CONSTRUCTION ITEC Ltd', NULL,
    NULL, NULL, 'c5e8bfeb-33d8-4eb2-8d22-154e5ff5e310', 6,
    '*164*S*Y''ello,A transaction of 600 RWF by INFORMATION TECHNOLOGY  ENGINEERING CONSTRUCTION   ITEC Ltd on your MOMO account was successfully completed at 2024-06-06 16:19:01. Message from debit receiver: ITEC Pay. Your new balance:230 RWF. Fee was 0 RWF. Financial Transaction Id: 14262449979. External Transaction Id: c5e8bfeb-33d8-4eb2-8d22-154e5ff5e310.*EN#'
);


INSERT IGNORE INTO transactions (
    transaction_id, sms_unix_timestamp, transaction_datetime,
    transaction_type, amount, fee, balance_after,
    sender_name, sender_phone, receiver_name, receiver_phone,
    receiver_code, token, external_tx_id, category_id, raw_sms_body
) VALUES (
    14324965479, 1718079981570, '2024-06-11 06:26:11',
    'BUNDLE', 2000.00, 0.00, 350.00,
    NULL, NULL, 'Bundles and Packs', NULL,
    NULL, '', NULL, 7,
    '*162*TxId:14324965479*S*Your payment of 2000 RWF to Bundles and Packs with token  has been completed at 2024-06-11 06:26:11. Fee was 0 RWF. Your new balance: 350 RWF . Message: - -. *EN#'
);



SELECT transaction_id, transaction_type, amount, fee, balance_after, transaction_datetime
FROM transactions
ORDER BY transaction_datetime;

UPDATE transactions
SET fee = 100.00
WHERE transaction_id = 1715452495316;

DELETE FROM transactions
WHERE transaction_id = 1715452495316;
