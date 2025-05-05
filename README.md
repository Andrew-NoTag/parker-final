# Parker-B23
NYU Tandon Design Project, Team B23, Parker

## Features

- User authentication (signup and login)
- Parking lot status updates
- Credit-based reward system
- SwiftUI-based frontend for user interaction
- FastAPI backend for API management

## Prerequisites

Before installing and running the application, ensure you have the following installed:

### Backend
- Python 3.10 or higher
- `pip` (Python package manager)
- PostgreSQL (for the database)

### Frontend
- Xcode (latest version)
- macOS (latest version)

## Installation

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/parker-final.git
cd parker-final
```
### 2. Backend Setup

**a. Import Data**
there are 3 tables in total

**b. Install Dependencies**
```bash
pip install -r requirements.txt
```

**c. Configure the Database**
1. Create a PostgreSQL database (e.g., parker_db).
2. Update the database connection string in `backend/app/database.py`:
```
DATABASE_URL = "postgresql://username:password@localhost/parker_db"
```

**d. Start the Backend Server**
```bash
uvicorn backend.app.main:app --reload
```

### 3. Frontend Setup
1. open project in Xcode
2. open `DataService.swift` in Xcode
3. Update the `baseURL` variable to point to your backend server:
```swift
private let baseURL = "http://127.0.0.1:8000"
```