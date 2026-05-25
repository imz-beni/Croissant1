# MoMo SMS Transactions API Documentation

## Overview

This API allows clients to interact with mobile money SMS transaction records.
Built using Python's `http.server` module with Basic Authentication.

Base URL: `http://localhost:8000`

## Authentication

All endpoints require Basic Authentication.

- Username: `admin`
- Password: `momo2024`

Using curl:
```
curl -u admin:momo2024 http://localhost:8000/transactions
```

If credentials are wrong or missing:
- Status: `401 Unauthorized`
```json
{"error": "Unauthorized"}
```

---

## Transaction Fields

| Field | Type | Description |
|-------|------|-------------|
| id | int | Auto-generated unique ID |
| transaction_type | string | Type: received, payment, transfer, airtime, etc. |
| amount | float | Transaction amount |
| currency | string | Currency code (default: RWF) |
| sender | string/null | Sender name |
| sender_phone | string/null | Sender phone number |
| receiver | string/null | Receiver name |
| receiver_phone | string/null | Receiver phone number |
| timestamp | string | ISO datetime (e.g. 2024-05-10T16:30:51) |
| balance_after | float | Balance after transaction |
| fee | float | Fee charged |
| transaction_id | string | Original transaction reference |
| message | string | Message from sender |
| body_text | string | Original SMS text |

---

## Endpoints

### GET /transactions

Get all transactions.

```bash
curl -u admin:momo2024 http://localhost:8000/transactions
```

Response (200):
```json
{
  "count": 25,
  "transactions": [
    {
      "id": 1,
      "transaction_type": "received",
      "amount": 2000.0,
      "currency": "RWF",
      "sender": "Jane Smith",
      "timestamp": "2024-05-10T16:30:51"
    }
  ]
}
```

### GET /transactions/{id}

Get one transaction by ID.

```bash
curl -u admin:momo2024 http://localhost:8000/transactions/1
```

Response (200):
```json
{
  "id": 1,
  "transaction_type": "received",
  "amount": 2000.0,
  "currency": "RWF",
  "sender": "Jane Smith",
  "sender_phone": "250XXXXXXX013",
  "receiver": "Account Holder",
  "receiver_phone": null,
  "timestamp": "2024-05-10T16:30:51",
  "balance_after": 2000.0,
  "fee": 0.0,
  "transaction_id": "76662021700",
  "message": "",
  "body_text": "You have received 2000 RWF..."
}
```

Error (404):
```json
{"error": "Transaction not found"}
```

### POST /transactions

Create a new transaction. Required fields: `transaction_type`, `amount`, `timestamp`.

```bash
curl -u admin:momo2024 -X POST \
  http://localhost:8000/transactions \
  -H "Content-Type: application/json" \
  -d '{"transaction_type":"payment","amount":500,"timestamp":"2024-05-30T10:00:00"}'
```

Response (201):
```json
{
  "message": "Transaction created",
  "transaction": {
    "id": 26,
    "transaction_type": "payment",
    "amount": 500.0,
    "currency": "RWF",
    "timestamp": "2024-05-30T10:00:00"
  }
}
```

Error (400):
```json
{"error": "Missing field: amount"}
```

### PUT /transactions/{id}

Update a transaction. Send only the fields you want to change.

```bash
curl -u admin:momo2024 -X PUT \
  http://localhost:8000/transactions/1 \
  -H "Content-Type: application/json" \
  -d '{"amount":1500}'
```

Response (200):
```json
{
  "message": "Transaction updated",
  "transaction": {
    "id": 1,
    "amount": 1500,
    "transaction_type": "received"
  }
}
```

Error (404):
```json
{"error": "Transaction not found"}
```

### DELETE /transactions/{id}

Delete a transaction by ID.

```bash
curl -u admin:momo2024 -X DELETE \
  http://localhost:8000/transactions/1
```

Response (200):
```json
{
  "message": "Transaction deleted",
  "transaction": {
    "id": 1,
    "transaction_type": "received",
    "amount": 2000.0
  }
}
```

Error (404):
```json
{"error": "Transaction not found"}
```

---

## Error Codes

| Code | Meaning |
|------|---------|
| 200 | Success (GET, PUT, DELETE) |
| 201 | Created (POST) |
| 400 | Bad request (missing fields, invalid JSON) |
| 401 | Unauthorized (bad or missing credentials) |
| 404 | Not found (wrong ID or wrong endpoint) |

---

## Running the Server

```bash
python api/server.py
```

Server starts on `http://localhost:8000`.

---

## Security: Basic Auth Limitations

Our API uses Basic Authentication, which works for this project but has
some serious weaknesses in a real-world application.

### Why Basic Auth is Weak

1. **Credentials are not encrypted** - Basic Auth encodes the username and
   password in Base64, but Base64 is encoding, not encryption. Anyone who
   intercepts the request can decode it instantly. For example,
   `YWRtaW46bW9tbzIwMjQ=` decodes straight to `admin:momo2024`.

2. **Credentials sent with every request** - The username and password are
   included in every single API call. This increases the chances of them
   being intercepted compared to a system that only sends credentials once.

3. **No session expiry** - There is no way to expire or revoke access.
   Once someone has the credentials, they have access forever until the
   password is manually changed.

4. **Hardcoded credentials** - In our implementation, the username and
   password are stored directly in the source code. In production, this
   is a security risk because anyone with access to the code can see them.

### Stronger Alternatives

**JWT (JSON Web Tokens)**
- User logs in once with username/password and gets a token back
- The token is sent with each request instead of the actual password
- Tokens can have an expiry time (e.g. 1 hour)
- Server can verify the token without checking a database each time
- If a token is stolen, it expires automatically

**OAuth 2.0**
- Users authenticate through a trusted third party (like Google or GitHub)
- The API never sees the user's actual password
- Access can be scoped (read-only, write, admin)
- Tokens can be revoked at any time
- Used by most major APIs (Google, Facebook, GitHub)

For a production version of this MoMo API, JWT would be the best next step
because it keeps the simplicity of our current approach while adding token
expiry and removing the need to send credentials with every request.
