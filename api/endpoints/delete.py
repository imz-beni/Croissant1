# api/endpoints/delete.py


def handle_delete(transaction_id):
    from dsa.data_loader import (
        load_transactions_json, save_transactions_json)

    transactions = load_transactions_json(
        'data/processed/transactions.json')

    # Find and remove the transaction
    deleted_transaction = None
    for i in range(len(transactions)):
        if transactions[i]['id'] == transaction_id:
            deleted_transaction = transactions[i]
            transactions.pop(i)
            break

    if deleted_transaction is None:
        return 404, {"error": "Transaction not found"}

    # Save updated list
    save_transactions_json(
        transactions, 'data/processed/transactions.json')

    return 200, {
        "message": "Transaction deleted",
        "transaction": deleted_transaction
    }
