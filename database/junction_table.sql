CREATE TABLE IF NOT EXISTS transaction_participants (
    participant_id  BIGINT   NOT NULL AUTO_INCREMENT COMMENT 'Surrogate primary key for this participation record',
    transaction_id  BIGINT   NOT NULL                COMMENT 'FK to transactions.transaction_id',
    user_id         INT      NOT NULL                COMMENT 'FK to users.user_id',
    role            ENUM(
                        'SENDER',
                        'RECEIVER',
                        'AGENT',
                        'MERCHANT',
                        'ACCOUNT_OWNER',
                        'DEPOSITOR'
                    )        NOT NULL                COMMENT 'Role this user played in the transaction',
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Row insertion timestamp',

    PRIMARY KEY (participant_id),

    UNIQUE KEY uq_tx_user_role (transaction_id, user_id, role),

    CONSTRAINT fk_tp_transaction FOREIGN KEY (transaction_id)
        REFERENCES transactions(transaction_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_tp_user FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    INDEX idx_tp_transaction_id (transaction_id),
    INDEX idx_tp_user_id        (user_id)

) ENGINE=InnoDB COMMENT='Junction table: one row per (transaction, user, role) combination';


INSERT INTO transaction_participants (transaction_id, user_id, role)
SELECT t.transaction_id, 2, 'SENDER'
FROM transactions t WHERE t.momo_tx_id = 76662021700
UNION ALL
SELECT t.transaction_id, 1, 'RECEIVER'
FROM transactions t WHERE t.momo_tx_id = 76662021700
UNION ALL
SELECT t.transaction_id, 1, 'SENDER'
FROM transactions t WHERE t.momo_tx_id = 73214484437
UNION ALL
SELECT t.transaction_id, 2, 'RECEIVER'
FROM transactions t WHERE t.momo_tx_id = 73214484437
UNION ALL
SELECT t.transaction_id, 1, 'ACCOUNT_OWNER'
FROM transactions t WHERE t.sms_unix_timestamp = 1715445936412
UNION ALL
SELECT t.transaction_id, 1, 'SENDER'
FROM transactions t WHERE t.sms_unix_timestamp = 1715452495316
UNION ALL
SELECT t.transaction_id, 3, 'RECEIVER'
FROM transactions t WHERE t.sms_unix_timestamp = 1715452495316
UNION ALL
SELECT t.transaction_id, 4, 'AGENT'
FROM transactions t WHERE t.momo_tx_id = 14262449979
UNION ALL
SELECT t.transaction_id, 1, 'RECEIVER'
FROM transactions t WHERE t.momo_tx_id = 14262449979
UNION ALL
SELECT t.transaction_id, 1, 'SENDER'
FROM transactions t WHERE t.momo_tx_id = 13913173274;


SELECT tp.participant_id, u.full_name, tp.role, t.transaction_type, t.amount
FROM transaction_participants tp
JOIN transactions t ON tp.transaction_id = t.transaction_id
JOIN users u        ON tp.user_id        = u.user_id
ORDER BY tp.transaction_id, tp.role;

UPDATE transaction_participants
SET role = 'MERCHANT'
WHERE user_id = 2
  AND transaction_id = (SELECT transaction_id FROM transactions WHERE momo_tx_id = 73214484437);

DELETE tp FROM transaction_participants tp
JOIN transactions t ON tp.transaction_id = t.transaction_id
WHERE tp.role = 'MERCHANT'
  AND t.momo_tx_id = 73214484437;
