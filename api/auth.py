# api/auth.py
import base64


def check_basic_auth(headers):
    auth_header = headers.get('Authorization', '')

    if not auth_header.startswith('Basic '):
        return False

    try:
        # Remove 'Basic ' prefix
        encoded_credentials = auth_header[6:]

        # Decode from Base64
        decoded_bytes = base64.b64decode(encoded_credentials)
        decoded_text = decoded_bytes.decode('utf-8')

        if ':' not in decoded_text:
            return False

        username, password = decoded_text.split(':', 1)

        # Check credentials
        correct_username = 'admin'
        correct_password = 'momo2024'

        if username == correct_username and \
                password == correct_password:
            return True
        else:
            return False

    except:
        return False
