def handle_put(transaction_id, body):
    from dsa.data_loader import load_transactions_json, save_transactions_json

    transactions = load_transactions_json('data/processed/transactions.json')

    found = False
    for i in range(len(transactions)):
        if transactions[i]['id'] == transaction_id:
            for key, value in body.items():
                transactions[i][key] = value

            found = True
            updated_transaction = transactions[i]
            break

    if not found:
        return 404, {"error": "Transaction not found"}

    save_transactions_json(transactions, 'data/processed/transactions.json')

    return 200, {
        "message": "Transaction updated successfully",
        "transaction": updated_transaction
    }

