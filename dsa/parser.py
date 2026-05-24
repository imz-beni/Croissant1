# dsa/parser.py
import xml.etree.ElementTree as ET
from datetime import datetime
import re

def parse_xml_to_dict(xml_path):
    # Parse the XML file
    tree = ET.parse(xml_path)
    root = tree.getroot()
    
    transactions = []
    transaction_id = 1

    # Loop through each SMS element
    for sms in root.findall('sms'):
        body = sms.get('body', '')
        
        # Skip OTP messages (not transactions)
        if 'one-time password' in body:
            continue
        
        # Get timestamp from date attribute (milliseconds)
        date_ms = int(sms.get('date', 0))
        timestamp = datetime.fromtimestamp(date_ms / 1000)
        timestamp = timestamp.strftime('%Y-%m-%dT%H:%M:%S')

# Build transaction dictionary
        transaction = {
            'id': transaction_id,
            'transaction_type': get_transaction_type(body),
            'amount': extract_amount(body),
            'currency': 'RWF',
            'sender': extract_sender(body),
            'sender_phone': extract_phone(body, 'sender'),
            'receiver': extract_receiver(body),
            'receiver_phone': extract_phone(body, 'receiver'),
            'timestamp': timestamp,
            'balance_after': extract_balance(body),
            'fee': extract_fee(body),
            'transaction_id': extract_txid(body),
            'message': extract_message(body),
            'body_text': body
        }
        
        transactions.append(transaction)
        transaction_id += 1
    
    return transactions

# helper to get transaction type
def get_transaction_type(body):
    if 'You have received' in body:
        return 'received'
    elif 'Your payment of' in body and 'Airtime' in body:
        return 'airtime'
    elif 'Your payment of' in body:
        return 'payment'
    elif 'transferred to' in body:
        return 'transfer'
    elif 'bank deposit' in body:
        return 'bank_deposit'
    elif 'withdrawn' in body:
        return 'withdrawal'
    elif 'DIRECT PAYMENT' in body:
        return 'direct_payment'
    else:
        return 'other'

# helper to extract amount(regex pattern)
def extract_amount(body):
    match = re.search(r'([0-9,]+)\s*RWF', body)
    if match:
        amount_str = match.group(1).replace(',', '')
        return float(amount_str)
    return 0.0

# helper to extract sender
def extract_sender(body):
    if 'You have received' in body:
        match = re.search(r'from ([A-Za-z ]+)', body)
        if match:
            return match.group(1).strip()
    return None

# helper to extract receiver
def extract_receiver(body):
    if 'Your payment of' in body:
        match = re.search(r'to ([A-Za-z0-9 ]+)', body)
        if match:
            name = match.group(1).strip()
            # Remove numbers at the end
            name = re.sub(r'\d+$', '', name).strip()
            return name
    elif 'transferred to' in body:
        match = re.search(r'transferred to ([A-Za-z ]+)', body)
        if match:
            return match.group(1).strip()
    return None

# helper to extract phone number
def extract_phone(body, party):
    match = re.search(r'\(?(250\d{9}|\*+\d{3})\)?', body)
    if match:
        return match.group(1)
    return None

# helper to extract balance
def extract_balance(body):
    match = re.search(r'balance[:\s]+([0-9,]+)\s*RWF', body, re.IGNORECASE)
    if match:
        balance_str = match.group(1).replace(',', '')
        return float(balance_str)
    return 0.0

# helper to extract fee
def extract_fee(body):
    match = re.search(r'[Ff]ee[\s:was]+([0-9,]+)\s*RWF', body)
    if match:
        fee_str = match.group(1).replace(',', '')
        return float(fee_str)
    return 0.0

# helper to extract transaction id
def extract_txid(body):
    match = re.search(r'TxId[:\s]+([0-9]+)', body)
    if match:
        return match.group(1)
    match = re.search(r'Transaction Id[:\s]+([0-9]+)', body)
    if match:
        return match.group(1)
    return ''

# helper to extract message
def extract_message(body):
    match = re.search(r'Message from sender[:\s]+([^.]+)', body)
    if match:
        return match.group(1).strip()
    return ''

if __name__ == '__main__':
    transactions = parse_xml_to_dict('data/raw/modified_sms_v2.xml')
    print(f"Parsed {len(transactions)} transactions")
    if transactions:
        print("First transaction:", transactions[0])