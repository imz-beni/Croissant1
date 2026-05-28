# api/validators.py


def validate_create_data(body):
    # Check required fields for creating a transaction
    required = ['transaction_type', 'amount', 'timestamp']

    for field in required:
        if field not in body:
            return False, f"Missing field: {field}"

    # Make sure amount is a number
    try:
        float(body['amount'])
    except (ValueError, TypeError):
        return False, "Amount must be a number"

    return True, None


def validate_update_data(body):
    # For updates, just need at least one field
    if len(body) == 0:
        return False, "No fields to update"

    # Check amount if provided
    if 'amount' in body:
        try:
            float(body['amount'])
        except (ValueError, TypeError):
            return False, "Amount must be a number"

    return True, None


def validate_id(id_string):
    # Check that ID from URL is a valid number
    try:
        tid = int(id_string)
        if tid < 1:
            return False, "ID must be positive"
        return True, tid
    except (ValueError, TypeError):
        return False, "ID must be a number"
