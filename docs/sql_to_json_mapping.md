# SQL to JSON Mapping

This document explains how each SQL table maps to the JSON fields
in complex_transaction.json.

## Transactions table
Maps to the root level of the JSON object:
- transaction_id → "transaction_id"
- momo_tx_id → "momo_tx_id"
- amount → "amount"
- fee → "fee"
- new_balance → "new_balance"
- direction → "direction"
- transaction_date → "transaction_date"

## Transaction_Categories table
Maps to the nested "category" object:
- category_id → "category.category_id"
- category_code → "category.category_code"

## Users table
Maps to the nested "sender" and "receiver" objects:
- user_id → "sender.id" or "receiver.id"
- full_name → "sender.name" or "receiver.name"
- phone → "sender.phone" or "receiver.phone"

## System_Logs table
Maps to the nested "log" object:
- log_id → "log.log_id"
- log_level → "log.log_level"
- message → "log.message"
