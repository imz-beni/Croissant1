
import time
import sys
import os

# Allow running from project root: python dsa/performance_test.py
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from dsa.data_loader import load_transactions_json
from dsa.search_algorithms import linear_search, build_transaction_dict, dict_lookup


def compare_search_methods(json_path: str = 'data/processed/transactions.json') -> dict:
    """
    Loads transactions and times both search methods over 20 IDs.
    Returns a results dict with times and speedup factor.
    """
    # ── Load data ──────────────────────────────────────────────────────────────
    transactions = load_transactions_json(json_path)
    total = len(transactions)
    print(f"\n{'='*55}")
    print(f"  DSA Performance Test — {total} transactions loaded")
    print(f"{'='*55}")



    transaction_dict = build_transaction_dict(transactions)

    test_ids = list(range(1, 21))


    linear_results = []
    start = time.perf_counter()
    for test_id in test_ids:
        result = linear_search(transactions, test_id)
        linear_results.append(result)
    linear_time = time.perf_counter() - start


    dict_results = []
    start = time.perf_counter()
    for test_id in test_ids:
        result = dict_lookup(transaction_dict, test_id)
        dict_results.append(result)
    dict_time = time.perf_counter() - start

   
    speedup = (linear_time / dict_time) if dict_time > 0 else float('inf')

  
    print(f"\n  Searching for 20 transaction IDs (1–20):")
    print(f"  {'Method':<25} {'Time (seconds)':<20} {'Complexity'}")
    print(f"  {'-'*55}")
    print(f"  {'Linear Search':<25} {linear_time:<20.6f} O(n)")
    print(f"  {'Dictionary Lookup':<25} {dict_time:<20.6f} O(1)")
    print(f"\n  Speedup: Dictionary is {speedup:.2f}x faster than Linear Search")
    print(f"\n  Verification — both methods returned the same results: "
          f"{' YES' if linear_results == dict_results else ' NO MISMATCH!'}")

    
    print(f"""
  Why is Dictionary Lookup faster? 
  Linear Search scans the list item-by-item until it finds the ID.
  For ID #20 in a 1,693-record dataset, it checks up to 20 items.
  For ID #1,690, it checks 1,690 items. Average cost grows with n.
  Time complexity: O(n).

  Dictionary Lookup uses Python's built-in hash table. When you
  call dict[key], Python hashes the key to a memory slot in O(1)
  time — no matter if there are 20 or 2,000,000 records, the
  lookup time stays effectively constant.
  Time complexity: O(1) average.

  Could we do even better? 
  For this use case (exact ID lookup), a hash table is already
  optimal at O(1). But for other search patterns:

  1. Binary Search (O(log n)) — useful if the list must stay sorted
    and memory is tight (no dict overhead).
  2. B-Tree Index (used by databases) — best for range queries like
    "find all transactions between date A and date B".
  3. Trie — fast prefix searches, e.g. finding senders by name prefix.
  {'='*55}
""")

    return {
        'total_transactions': total,
        'test_ids_count': len(test_ids),
        'linear_time': linear_time,
        'dict_time': dict_time,
        'speedup': speedup,
        'results_match': linear_results == dict_results
    }


if __name__ == '__main__':
    compare_search_methods()
