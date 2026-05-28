
import json

def save_transactions_json(transactions, output_path):
    with open(output_path, 'w') as file:
        json.dump(transactions, file, indent=2)
    print(f"Saved {len(transactions)} transactions to {output_path}")

def load_transactions_json(json_path):
    with open(json_path, 'r') as file:
        return json.load(file)

if __name__ == '__main__':
    from parser import parse_xml_to_dict
    
    # Parse XML
    transactions = parse_xml_to_dict('data/raw/modified_sms_v2.xml')
    
    # Save to JSON
    save_transactions_json(transactions, 'data/processed/transactions.json')
    
    # Load and verify
    loaded = load_transactions_json('data/processed/transactions.json')
    print(f"Loaded {len(loaded)} transactions from JSON")
