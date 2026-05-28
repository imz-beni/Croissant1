

import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from dsa.search_algorithms import build_transaction_dict, dict_lookup
from dsa.data_loader import load_transactions_json

# Cache the dict so we only build it once
_transaction_cache: dict | None = None


def _get_cache() -> dict:
    """
    Returns the transaction dictionary cache.
    Builds it from disk on first call, then returns the cached version.
    """
    global _transaction_cache
    if _transaction_cache is None:
        transactions = load_transactions_json('data/processed/transactions.json')
        _transaction_cache = build_transaction_dict(transactions)
    return _transaction_cache


def invalidate_cache() -> None:
    """
    Called by create/update/delete endpoints after writing to disk,
    so the next GET reflects the latest data.
    """
    global _transaction_cache
    _transaction_cache = None


def handle_get_one(transaction_id: int) -> tuple[int, dict]:
    """
    GET /transactions/{id}

    Uses O(1) dictionary lookup to find the transaction.
    Returns (200, transaction) if found, or (404, error) if not.

    Args:
        transaction_id: The integer ID from the URL path.

    Returns:
        Tuple of (HTTP status code, response body dict).
    """
    cache = _get_cache()
    result = dict_lookup(cache, transaction_id)

    if result:
        return 200, result
    else:
        return 404, {"error": f"Transaction with id {transaction_id} not found"}


def handle_get_all() -> tuple[int, dict]:
    """
    GET /transactions

    Returns all transactions with a count.
    """
    cache = _get_cache()
    transactions = list(cache.values())
    return 200, {
        "count": len(transactions),
        "transactions": transactions
    }

