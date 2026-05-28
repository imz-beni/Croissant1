

import re


def route_request(method, path, headers, body):
    from api.auth import check_basic_auth

    # Check authentication before processing any request
    if not check_basic_auth(headers):
        return 401, {"error": "Unauthorized"}

    # ----------------------------------------------------------
    # GET /transactions — list all transactions
    # ----------------------------------------------------------
    if method == 'GET' and path == '/transactions':
        from dsa.data_loader import load_transactions_json
        transactions = load_transactions_json('data/processed/transactions.json')
        return 200, {"count": len(transactions), "transactions": transactions}

    # ----------------------------------------------------------
    # GET /transactions/{id} — get one transaction by ID
    # ----------------------------------------------------------
    if method == 'GET' and path.startswith('/transactions/'):
        from api.endpoints.retrieve import handle_get_one
        match = re.search(r'/transactions/(\d+)', path)
        if match:
            transaction_id = int(match.group(1))
            return handle_get_one(transaction_id)
        return 400, {"error": "Invalid transaction ID"}

    # ----------------------------------------------------------
    # POST /transactions — create a new transaction
    # ----------------------------------------------------------
    if method == 'POST' and path == '/transactions':
        from api.endpoints.create import handle_post
        return handle_post(body)

    # ----------------------------------------------------------
    # PUT /transactions/{id} — update an existing transaction
    # ----------------------------------------------------------
    if method == 'PUT' and path.startswith('/transactions/'):
        from api.endpoints.update import handle_put
        match = re.search(r'/transactions/(\d+)', path)
        if match:
            transaction_id = int(match.group(1))
            return handle_put(transaction_id, body)
        return 400, {"error": "Invalid transaction ID"}

    # ----------------------------------------------------------
    # DELETE /transactions/{id} — delete a transaction
    # ----------------------------------------------------------
    if method == 'DELETE' and path.startswith('/transactions/'):
        from api.endpoints.delete import handle_delete
        match = re.search(r'/transactions/(\d+)', path)
        if match:
            transaction_id = int(match.group(1))
            return handle_delete(transaction_id)
        return 400, {"error": "Invalid transaction ID"}

    # ----------------------------------------------------------
    # No route matched
    # ----------------------------------------------------------
    return 404, {"error": "Endpoint not found"}