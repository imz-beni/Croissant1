#  Team Croissant — MoMo SMS Data Pipeline & Dashboard

> A fullstack data engineering project that processes MTN Mobile Money (MoMo) SMS transaction data from XML, cleans and categorizes it, stores it in a relational database, and presents it through an interactive analytics dashboard.

---

## Team Members

| Name | Role |
|------|------|
| Imanzi Beni | Repo Lead — project structure & environment setup |
| Rugwiro Derrick | Documentation & README |
| Ishimwe Axcel | System Architecture Diagram |
| Teta Dianah | Scrum Board & Backlog Management |
| Nshuti Lancelot | Research Lead — data analysis & DB schema design |

---

##  Project Description

### What is MoMo SMS Data?
MTN Mobile Money (MoMo) is a widely used mobile payment service. Every transaction — whether a deposit, withdrawal, transfer, airtime purchase, or bill payment — generates an SMS notification sent to the user. These SMS messages are exportable in **XML format**, and contain structured information about each transaction including the amount, date, sender/receiver, and transaction type.

### What Does This System Do?
This system builds a complete data pipeline and analytics interface on top of that raw XML data:

1. **Parse** — reads and extracts transaction records from the raw XML file
2. **Clean & Normalize** — standardizes amounts (strips currency symbols), formats dates consistently, and normalizes phone numbers
3. **Categorize** — classifies each transaction into a type (e.g. incoming money, sent payment, airtime purchase, bank deposit, withdrawal via agent, etc.)
4. **Load** — stores the cleaned, categorized records into a SQLite relational database
5. **Export** — generates a `dashboard.json` file aggregating key metrics for the frontend to consume
6. **Visualize** — presents the data through a browser-based dashboard with charts and summary tables

### Who Is It For?
Anyone who wants to understand their MoMo transaction history at a glance — spending patterns, transaction frequency, category breakdowns, and more — without manually reading through hundreds of SMS messages.

---

##  System Architecture

  https://github.com/imz-beni/Croissant1/blob/main/architecture.png

**High-level flow:**
```
raw/momo.xml
     │
     ▼
[ETL Pipeline]
  parse_xml.py  →  clean_normalize.py  →  categorize.py  →  load_db.py
     │
     ▼
 db.sqlite3
     │
     ├──▶ export → data/processed/dashboard.json
     │
     ▼
[Frontend Dashboard]
  index.html + chart_handler.js
     │
     ▼ (optional)
[FastAPI Layer]
  /transactions  /analytics
```

---

##  Project Structure

```
.
├── README.md                         # Project overview, setup, and links
├── .env.example                      # Environment variable template
├── requirements.txt                  # Python dependencies
├── index.html                        # Dashboard entry point (static)
├── web/
│   ├── styles.css                    # Dashboard styling
│   ├── chart_handler.js              # Fetches data and renders charts/tables
│   └── assets/                       # Images and icons
├── data/
│   ├── raw/                          # Raw XML input (git-ignored)
│   │   └── momo.xml
│   ├── processed/                    # Aggregated output for the frontend
│   │   └── dashboard.json
│   ├── db.sqlite3                    # SQLite database file
│   └── logs/
│       ├── etl.log                   # Structured logs from ETL runs
│       └── dead_letter/              # XML snippets that failed to parse
├── etl/
│   ├── __init__.py
│   ├── config.py                     # File paths, thresholds, category rules
│   ├── parse_xml.py                  # XML parsing using ElementTree/lxml
│   ├── clean_normalize.py            # Amount, date, and phone normalization
│   ├── categorize.py                 # Rule-based transaction classification
│   ├── load_db.py                    # Table creation and upsert logic
│   └── run.py                        # CLI: runs the full ETL pipeline
├── api/                              # Optional bonus API layer
│   ├── __init__.py
│   ├── app.py                        # FastAPI app with /transactions, /analytics
│   ├── db.py                         # SQLite connection helpers
│   └── schemas.py                    # Pydantic response models
├── scripts/
│   ├── run_etl.sh                    # Runs the full ETL pipeline
│   ├── export_json.sh                # Rebuilds dashboard.json
│   └── serve_frontend.sh             # Starts a local HTTP server
└── tests/
    ├── test_parse_xml.py
    ├── test_clean_normalize.py
    └── test_categorize.py
```

---

## Setup & Installation

>  _Full setup instructions will be completed once the ETL and backend are built. The steps below reflect the intended workflow._

### Prerequisites
- Python 3.9+
- pip

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/imz-beni/Croissant1.git
cd Croissant1

# 2. Set up environment variables
cp .env.example .env
# Edit .env with your local values (e.g. path to SQLite DB)

# 3. Install Python dependencies
pip install -r requirements.txt

# 4. Place your MoMo XML file
cp /path/to/your/momo.xml data/raw/momo.xml

# 5. Run the ETL pipeline
bash scripts/run_etl.sh

# 6. Launch the frontend dashboard
bash scripts/serve_frontend.sh
# Then open http://localhost:8000 in your browser
```

---

##  Tech Stack

| Layer | Technology |
|-------|-----------|
| XML Parsing | Python — `xml.etree.ElementTree` / `lxml` |
| Data Cleaning | Python — `dateutil`, `re` |
| Database | SQLite via `sqlite3` |
| Backend API _(optional)_ | FastAPI + Pydantic |
| Frontend | HTML5, CSS3, Vanilla JavaScript |
| Data Visualization | Chart.js _(planned)_ |
| Project Management | GitHub Projects |

---

##  Scrum Board

https://github.com/users/Teta-Dianah/projects/1

---