
CREATE TABLE IF NOT EXISTS transaction_user_roles (
    role_id         INT         NOT NULL AUTO_INCREMENT COMMENT 'Surrogate PK for this participation record',
    transaction_id  BIGINT      NOT NULL                COMMENT 'FK to transactions.transaction_id',
    user_id         INT         NOT NULL                COMMENT 'FK to users.user_id',
    role            ENUM(
                        'SENDER',
                        'RECEIVER',
                        'ACCOUNT_OWNER',
                        'DEPOSITOR'
                    )           NOT NULL                COMMENT 'Role this user played in the transaction',
    created_at      DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Row insertion timestamp',

    PRIMARY KEY (role_id),

    -- Prevent the same user appearing twice in the same role for the same transaction
    UNIQUE KEY uq_tx_user_role (transaction_id, user_id, role),

    FOREIGN KEY (transaction_id)
        REFERENCES transactions(transaction_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    INDEX idx_txur_transaction_id (transaction_id),
    INDEX idx_txur_user_id        (user_id)

) COMMENT 'Junction table: maps users to transactions with their participation role';




INSERT IGNORE INTO transaction_user_roles (transaction_id, user_id, role) VALUES
(76662021700, 2, 'SENDER'),
(76662021700, 1, 'RECEIVER');

INSERT IGNORE INTO transaction_user_roles (transaction_id, user_id, role) VALUES
(73214484437, 1, 'SENDER'),
(73214484437, 2, 'RECEIVER');

INSERT IGNORE INTO transaction_user_roles (transaction_id, user_id, role) VALUES
(1715445936412, 1, 'ACCOUNT_OWNER');

INSERT IGNORE INTO transaction_user_roles (transaction_id, user_id, role) VALUES
(1715452495316, 1, 'SENDER'),
(1715452495316, 3, 'RECEIVER');

INSERT IGNORE INTO transaction_user_roles (transaction_id, user_id, role) VALUES
(14262449979, 4, 'SENDER'),
(14262449979, 1, 'RECEIVER');

INSERT IGNORE INTO transaction_user_roles (transaction_id, user_id, role) VALUES
(13913173274, 1, 'SENDER');

INSERT IGNORE INTO transaction_user_roles (transaction_id, user_id, role) VALUES
(1715452495316, 5, 'RECEIVER');


SELECT u.user_id, u.full_name, tur.role
FROM transaction_user_roles tur
JOIN users u ON tur.user_id = u.user_id
WHERE tur.transaction_id = 76662021700;

UPDATE transaction_user_roles
SET role = 'ACCOUNT_OWNER'
WHERE transaction_id = 1715445936412 AND user_id = 1;

DELETE FROM transaction_user_roles
WHERE transaction_id = 1715452495316 AND user_id = 5;
