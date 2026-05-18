CREATE TABLE IF NOT EXISTS transactions (
    transaction_id       BIGINT          NOT NULL AUTO_INCREMENT    COMMENT 'Surrogate primary key, internal row identifier, not the provider ID',
    momo_tx_id           BIGINT          NULL                       COMMENT 'Provider TxId or Financial Transaction Id parsed from SMS body; NULL when SMS has no ID',
    sms_unix_timestamp   BIGINT          NOT NULL                   COMMENT 'Raw Unix timestamp in ms from the XML date attribute',
    transaction_date     DATETIME        NOT NULL                   COMMENT 'Datetime of the transaction parsed from the SMS body text',
    transaction_type     ENUM(
                             'INCOMING',
                             'MERCHANT_PAYMENT',
                             'BANK_DEPOSIT',
                             'TRANSFER_SENT',
                             'AIRTIME',
                             'BUNDLE',
                             'MERCHANT_DEBIT',
                             'AGENT_WITHDRAWAL'
                         )               NOT NULL                   COMMENT 'Transaction pattern type derived from SMS body structure',
    direction            ENUM(
                             'CREDIT',
                             'DEBIT'
                         )               NOT NULL                   COMMENT 'CREDIT when money enters the account, DEBIT when money leaves',
    amount               DECIMAL(12,2)   NOT NULL                   COMMENT 'Principal amount of the transaction in RWF',
    fee                  DECIMAL(12,2)   NOT NULL DEFAULT 0.00      COMMENT 'Fee charged in RWF; defaults to 0 when not stated in SMS',
    new_balance          DECIMAL(12,2)   NULL                       COMMENT 'Account balance reported after the transaction in RWF; nullable because some messages omit it',
    counterparty_name    VARCHAR(120)    NULL                       COMMENT 'Name of the other party as printed in the SMS body',
    counterparty_phone   VARCHAR(20)     NULL                       COMMENT 'Phone number of the other party; stored as text, may be masked e.g. *********013',
    counterparty_account VARCHAR(30)     NULL                       COMMENT 'Other party or agent account number when printed in the SMS',
    momo_account         VARCHAR(30)     NULL                       COMMENT 'Account owners own MoMo account number when printed in the message',
    receiver_code        VARCHAR(20)     NULL                       COMMENT 'Merchant short code appended after receiver name in payment SMS e.g. 12845',
    token                VARCHAR(100)    NULL                       COMMENT 'Token string returned for airtime or Cash Power purchases',
    external_tx_id       VARCHAR(40)     NULL                       COMMENT 'External Transaction Id present only on merchant debit messages',
    category_id          INT             NOT NULL                   COMMENT 'FK to transaction_categories.category_id',
    log_id               BIGINT          NULL                       COMMENT 'FK to system_logs.log_id, the ingestion record that produced this row',
    raw_body             TEXT            NOT NULL                   COMMENT 'Original SMS body text kept for audit and re-parsing',
    created_at           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp when this row was inserted by the pipeline',

    PRIMARY KEY (transaction_id),
    UNIQUE KEY uq_momo_tx_id (momo_tx_id),

    CONSTRAINT chk_amount_positive      CHECK (amount      > 0),
    CONSTRAINT chk_fee_non_negative     CHECK (fee         >= 0),
    CONSTRAINT chk_balance_non_negative CHECK (new_balance IS NULL OR new_balance >= 0),

    CONSTRAINT fk_tx_category FOREIGN KEY (category_id)
        REFERENCES transaction_categories(category_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_tx_log FOREIGN KEY (log_id)
        REFERENCES system_logs(log_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    INDEX idx_transaction_date (transaction_date),
    INDEX idx_transaction_type (transaction_type),
    INDEX idx_category_id      (category_id),
    INDEX idx_direction        (direction)

) ENGINE=InnoDB COMMENT='One row per MoMo SMS transaction parsed by the pipeline';


INSERT IGNORE INTO transactions (
    momo_tx_id, sms_unix_timestamp, transaction_date,
    transaction_type, direction, amount, fee, new_balance,
    counterparty_name, counterparty_phone, counterparty_account,
    momo_account, receiver_code, token, external_tx_id,
    category_id, log_id, raw_body
) VALUES
(76662021700,  1715351458724, '2024-05-10 16:30:51', 'INCOMING',         'CREDIT', 2000.00,   0.00,  2000.00, 'Jane Smith',        '*********013', NULL, NULL, NULL,    NULL, NULL,                                   1, 1, 'You have received 2000 RWF from Jane Smith (*********013) on your mobile money account at 2024-05-10 16:30:51. Your new balance:2000 RWF. Financial Transaction Id: 76662021700.'),
(73214484437,  1715351506754, '2024-05-10 16:31:39', 'MERCHANT_PAYMENT', 'DEBIT',  1000.00,   0.00,  1000.00, 'Jane Smith',        NULL,           NULL, NULL, '12845', NULL, NULL,                                   2, 2, 'TxId: 73214484437. Your payment of 1,000 RWF to Jane Smith 12845 has been completed at 2024-05-10 16:31:39. Your new balance: 1,000 RWF. Fee was 0 RWF.'),
(NULL,         1715445936412, '2024-05-11 18:43:49', 'BANK_DEPOSIT',     'CREDIT', 40000.00,  0.00, 40400.00, NULL,                '250795963036', NULL, NULL, NULL,    NULL, NULL,                                   4, 3, '*113*R*A bank deposit of 40000 RWF has been added to your mobile money account at 2024-05-11 18:43:49. Your NEW BALANCE :40400 RWF.'),
(NULL,         1715452495316, '2024-05-11 20:34:47', 'TRANSFER_SENT',    'DEBIT',  10000.00, 100.00, 28300.00, 'Samuel Carter',    '250791666666', NULL, NULL, NULL,    NULL, NULL,                                   3, 4, '*165*S*10000 RWF transferred to Samuel Carter (250791666666) from 36521838 at 2024-05-11 20:34:47. Fee was: 100 RWF. New balance: 28300 RWF.'),
(13913173274,  1715506895734, '2024-05-12 11:41:28', 'AIRTIME',          'DEBIT',  2000.00,   0.00, 25280.00, 'Airtime',           NULL,           NULL, NULL, NULL,    '',   NULL,                                   5, 5, '*162*TxId:13913173274*S*Your payment of 2000 RWF to Airtime with token  has been completed at 2024-05-12 11:41:28. Fee was 0 RWF. Your new balance: 25280 RWF.'),
(14262449979,  1717683548224, '2024-06-06 16:19:01', 'MERCHANT_DEBIT',   'DEBIT',  600.00,    0.00,   230.00, 'ITEC Ltd',          NULL,           NULL, NULL, NULL,    NULL, 'c5e8bfeb-33d8-4eb2-8d22-154e5ff5e310', 6, 1, '*164*S*A transaction of 600 RWF by INFORMATION TECHNOLOGY ENGINEERING CONSTRUCTION ITEC Ltd was successfully completed at 2024-06-06 16:19:01. Your new balance:230 RWF.'),
(14324965479,  1718079981570, '2024-06-11 06:26:11', 'BUNDLE',           'DEBIT',  2000.00,   0.00,   350.00, 'Bundles and Packs', NULL,           NULL, NULL, NULL,    '',   NULL,                                   5, 2, '*162*TxId:14324965479*S*Your payment of 2000 RWF to Bundles and Packs with token  has been completed at 2024-06-11 06:26:11. Fee was 0 RWF. Your new balance: 350 RWF.');


SELECT transaction_id, momo_tx_id, transaction_type, direction, amount, fee, new_balance, transaction_date
FROM transactions
ORDER BY transaction_date;

UPDATE transactions
SET fee = 100.00
WHERE momo_tx_id = 76662021700;

DELETE FROM transactions
WHERE momo_tx_id = 14324965479;
