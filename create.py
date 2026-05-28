def handle_post(body):
    required_fields = ['transaction_type', 'amount', 'timestamp']

    for field in required_fields:
        if field not in body:
            return 400, {"error": f"Missing required field: {field}"}

    from dsa.data_loader import load_transactions_json, save_transactions_json

    try:
        transactions = load_transactions_json('data/processed/transactions.json')
    except:
        transactions = []

    if transactions:
        max_id = max([t['id'] for t in transactions])
        new_id = max_id + 1
    else:
        new_id = 1

    new_transaction = {
        'id': new_id,
        'transaction_type': body.get('transaction_type'),
        'amount': float(body.get('amount')),
        'currency': body.get('currency', 'RWF'),
        'sender': body.get('sender'),
        'sender_phone': body.get('sender_phone'),
        'receiver': body.get('receiver'),
        'receiver_phone': body.get('receiver_phone'),
        'timestamp': body.get('timestamp'),
        'balance_after': body.get('balance_after', 0.0),
        'fee': body.get('fee', 0.0),
        'transaction_id': body.get('transaction_id', ''),
        'message': body.get('message', ''),
        'body_text': body.get('body_text', '')
    }

    transactions.append(new_transaction)
    save_transactions_json(transactions, 'data/processed/transactions.json')

    return 201, {
        "message": "Transaction created successfully",
        "transaction": new_transaction
    }

