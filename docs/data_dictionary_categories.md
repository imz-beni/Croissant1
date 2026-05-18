# Data Dictionary — transaction_categories

| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| category_id | INT | No | Auto-generated unique identifier for each category |
| category_code | VARCHAR(30) | No | Short machine-readable name e.g. payment, transfer. Must be unique |
| description | VARCHAR(120) | Yes | Human-readable explanation of what the category means |