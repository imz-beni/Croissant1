
def linear_search(transactions: list, target_id: int) -> dict | None:
    """
    Linear Search — O(n) time complexity.
    Scans every transaction one by one until target_id is found.
    Worst case: checks ALL records before finding (or not finding) the match.
    """
    for transaction in transactions:
        if transaction['id'] == target_id:
            return transaction
    return None


def build_transaction_dict(transactions: list) -> dict:
    """
    Build a dictionary mapping id -> transaction object.
    One-time O(n) cost to build, then every lookup is O(1).
    """
    transaction_dict = {}
    for transaction in transactions:
        tid = transaction['id']
        transaction_dict[tid] = transaction
    return transaction_dict


def dict_lookup(transaction_dict: dict, target_id: int) -> dict | None:
    """
    Dictionary Lookup — O(1) average time complexity.
    Python dicts use hash tables: the key is hashed to a memory address
    directly, so no scanning needed regardless of dataset size.
    """
    return transaction_dict.get(target_id, None)
