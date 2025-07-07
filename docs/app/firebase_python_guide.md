# Firebase Python Application Development Guide

This guide provides best practices for creating Python applications deployed on Firebase, including technology stack requirements, project structure, and development lifecycle workflows for agentic LLM coding assistance.

## Overview

Firebase supports Python applications primarily through:

- **Cloud Functions for Firebase** (2nd gen) - Serverless Python functions
- **Cloud Run** - Containerized Python applications
- **App Engine** - Managed Python hosting platform
- **Firebase Admin SDK** - Python SDK for backend operations

## Technology Stack Requirements

### Core Dependencies

```bash
# Firebase and Google Cloud
firebase-admin>=6.0.0
firebase-functions>=0.1.0  # For Cloud Functions
google-cloud-firestore>=2.0.0
google-cloud-storage>=2.0.0

# Web Framework (choose one)
flask>=2.0.0              # Lightweight microframework
fastapi>=0.68.0           # Modern async framework
django>=4.0.0             # Full-featured framework

# Production Server
gunicorn>=20.0.0          # WSGI server for Flask/Django
uvicorn>=0.15.0           # ASGI server for FastAPI

# Development & Testing
pytest>=6.0.0
firebase-admin-python     # Firebase emulator support
requests>=2.25.0
python-dotenv>=0.19.0
```

### System Requirements

```bash
# Required Software
- Python 3.9+ (3.11 recommended)
- Node.js 18+ (for Firebase CLI)
- Docker (for Cloud Run deployment)
- Java 11+ (for Firebase emulators)

# Firebase CLI Installation
npm install -g firebase-tools

# Google Cloud CLI (optional but recommended)
curl https://sdk.cloud.google.com | bash
```

## Project Structure

### Recommended Directory Layout

```
my-firebase-app/
├── README.md                    # Project documentation
├── .env.example                 # Environment variables template
├── .gitignore                   # Git ignore rules
├── requirements.txt             # Python dependencies
├── requirements-dev.txt         # Development dependencies
├── firebase.json                # Firebase configuration
├── .firebaserc                  # Firebase project aliases
├── pyproject.toml              # Python project configuration
├── Dockerfile                   # Container configuration
├── cloudbuild.yaml             # Cloud Build configuration
├── src/                        # Source code (src layout)
│   └── app/
│       ├── __init__.py
│       ├── main.py             # Application entry point
│       ├── config.py           # Configuration management
│       ├── models/             # Data models
│       │   ├── __init__.py
│       │   └── user.py
│       ├── services/           # Business logic
│       │   ├── __init__.py
│       │   ├── auth_service.py
│       │   └── data_service.py
│       ├── utils/              # Utility functions
│       │   ├── __init__.py
│       │   └── helpers.py
│       └── api/                # API routes/endpoints
│           ├── __init__.py
│           ├── auth.py
│           └── users.py
├── functions/                  # Cloud Functions
│   ├── main.py
│   └── requirements.txt
├── tests/                      # Test modules
│   ├── __init__.py
│   ├── conftest.py            # Pytest configuration
│   ├── test_auth.py
│   └── test_data.py
├── docs/                       # Documentation
│   ├── api.md
│   └── deployment.md
├── scripts/                    # Utility scripts
│   ├── deploy.sh
│   └── setup_env.sh
└── static/                     # Static assets (if needed)
    ├── css/
    └── js/
```

### Key Configuration Files

#### firebase.json

```json
{
  "functions": [
    {
      "source": "functions",
      "codebase": "default",
      "runtime": "python311"
    }
  ],
  "hosting": {
    "public": "static",
    "rewrites": [
      {
        "source": "/api/**",
        "run": {
          "serviceId": "my-python-app",
          "region": "us-central1"
        }
      }
    ]
  },
  "emulators": {
    "functions": {
      "port": 5001
    },
    "firestore": {
      "port": 8080
    },
    "ui": {
      "enabled": true,
      "port": 4000
    },
    "singleProjectMode": true
  }
}
```

#### requirements.txt

```txt
firebase-admin>=6.2.0
firebase-functions>=0.1.0
flask>=2.3.0
gunicorn>=21.0.0
python-dotenv>=1.0.0
pydantic>=2.0.0
google-cloud-firestore>=2.11.0
google-cloud-storage>=2.10.0
```

#### pyproject.toml

```toml
[build-system]
requires = ["setuptools>=61.0", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "my-firebase-app"
version = "0.1.0"
description = "Firebase Python application"
requires-python = ">=3.9"
dependencies = [
    "firebase-admin>=6.2.0",
    "flask>=2.3.0",
    "gunicorn>=21.0.0"
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0.0",
    "black>=23.0.0",
    "flake8>=6.0.0",
    "mypy>=1.0.0"
]

[tool.black]
line-length = 88
target-version = ['py39']

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
```

## Application Entry Points

### Flask Application (src/app/main.py)

```python
import os
from flask import Flask
from firebase_admin import initialize_app, credentials
from .config import Config
from .api import auth_bp, users_bp

def create_app():
    """Application factory pattern"""
    app = Flask(__name__)
    app.config.from_object(Config)

    # Initialize Firebase Admin SDK
    if not len(firebase_admin._apps):
        cred = credentials.ApplicationDefault()
        initialize_app(cred)

    # Register blueprints
    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(users_bp, url_prefix='/api/users')

    return app

# For local development
if __name__ == '__main__':
    app = create_app()
    app.run(debug=True, host='0.0.0.0', port=8080)

# For production deployment
app = create_app()
```

### Cloud Function (functions/main.py)

```python
from firebase_functions import https_fn, firestore_fn
from firebase_admin import initialize_app, firestore
import logging

# Initialize Firebase Admin SDK
initialize_app()
db = firestore.client()

@https_fn.on_request()
def api_endpoint(req: https_fn.Request) -> https_fn.Response:
    """HTTP Cloud Function endpoint"""
    if req.method == 'OPTIONS':
        # Handle CORS preflight
        headers = {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization'
        }
        return https_fn.Response('', status=204, headers=headers)

    try:
        # Your business logic here
        result = {"message": "Hello from Firebase Functions!"}
        return https_fn.Response(
            json.dumps(result),
            mimetype='application/json',
            headers={'Access-Control-Allow-Origin': '*'}
        )
    except Exception as e:
        logging.error(f"Function error: {str(e)}")
        return https_fn.Response(
            json.dumps({"error": "Internal server error"}),
            status=500,
            mimetype='application/json'
        )

@firestore_fn.on_document_created(document="users/{userId}")
def on_user_created(event: firestore_fn.Event[firestore_fn.DocumentSnapshot]) -> None:
    """Firestore trigger function"""
    user_data = event.data.to_dict()
    logging.info(f"New user created: {user_data}")

    # Initialize user data, send welcome email, etc.
```

## Development Lifecycle

### 1. Environment Setup

```bash
# Create project directory
mkdir my-firebase-app && cd my-firebase-app

# Initialize Git repository
git init

# Create virtual environment
python -m venv .venv
source .venv/bin/activate  # Linux/Mac
# .venv\Scripts\activate   # Windows

# Install dependencies
pip install -r requirements.txt
pip install -r requirements-dev.txt

# Initialize Firebase project
firebase init

# Set up environment variables
cp .env.example .env
# Edit .env with your configuration
```

### 2. Local Development

```bash
# Start Firebase emulators
firebase emulators:start

# In another terminal, start your Python app
python -m src.app.main

# Or use development server with hot reload
export FLASK_ENV=development
export FLASK_APP=src.app.main:app
flask run --host=0.0.0.0 --port=8080
```

### 3. Testing Strategy

```python
# tests/conftest.py
import pytest
import os
from src.app.main import create_app

@pytest.fixture
def app():
    """Create test application"""
    os.environ['TESTING'] = 'True'
    app = create_app()
    app.config.update({
        "TESTING": True,
        "FIREBASE_AUTH_EMULATOR_HOST": "localhost:9099",
        "FIRESTORE_EMULATOR_HOST": "localhost:8080"
    })
    return app

@pytest.fixture
def client(app):
    """Create test client"""
    return app.test_client()

# tests/test_auth.py
def test_user_registration(client):
    """Test user registration endpoint"""
    response = client.post('/api/auth/register', json={
        'email': 'test@example.com',
        'password': 'testpass123'
    })
    assert response.status_code == 201
    assert 'user_id' in response.get_json()
```

### 4. Deployment Options

#### Option A: Cloud Functions

```bash
# Deploy functions only
firebase deploy --only functions

# Deploy specific function
firebase deploy --only functions:api_endpoint
```

#### Option B: Cloud Run

```bash
# Build and deploy to Cloud Run
gcloud run deploy my-python-app \
    --source . \
    --region us-central1 \
    --allow-unauthenticated \
    --max-instances 10 \
    --memory 512Mi
```

#### Option C: App Engine

```yaml
# app.yaml
runtime: python311
service: default

env_variables:
  FIREBASE_PROJECT_ID: your-project-id

automatic_scaling:
  min_instances: 0
  max_instances: 10
```

### 5. CI/CD Pipeline

```yaml
# .github/workflows/deploy.yml
name: Deploy to Firebase
on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: "3.11"
      - name: Install dependencies
        run: |
          pip install -r requirements.txt
          pip install -r requirements-dev.txt
      - name: Run tests
        run: pytest
      - name: Run linting
        run: |
          black --check .
          flake8 .

  deploy:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: "18"
      - name: Install Firebase CLI
        run: npm install -g firebase-tools
      - name: Deploy to Firebase
        run: firebase deploy --token "$FIREBASE_TOKEN"
        env:
          FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
```

## Best Practices

### Code Organization

- **Use src layout**: Prevents accidental imports and ensures clean packaging
- **Separate concerns**: Keep business logic, API routes, and data models in separate modules
- **Configuration management**: Use environment variables and config classes
- **Error handling**: Implement comprehensive error handling and logging

### Firebase-Specific Patterns

```python
# Singleton Firebase client pattern
class FirebaseClient:
    _instance = None
    _db = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            if not firebase_admin._apps:
                cred = credentials.ApplicationDefault()
                firebase_admin.initialize_app(cred)
            cls._db = firestore.client()
        return cls._instance

    def get_db(self):
        return self._db

# Use dependency injection
def get_firebase_client():
    return FirebaseClient().get_db()
```

### Security Considerations

```python
# Always validate Firebase ID tokens
from firebase_admin import auth

def verify_firebase_token(token):
    try:
        decoded_token = auth.verify_id_token(token)
        return decoded_token
    except Exception as e:
        raise ValueError(f"Invalid token: {e}")

# Use Firebase Security Rules
# firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Performance Optimization

- **Use connection pooling** for database connections
- **Implement caching** for frequently accessed data
- **Optimize Firestore queries** with proper indexing
- **Use batch operations** for multiple document updates
- **Implement proper error handling** and retries

## Common Pitfalls to Avoid

1. **Don't initialize Firebase Admin SDK multiple times**
2. **Avoid blocking operations in Cloud Functions**
3. **Don't store sensitive data in client-side code**
4. **Avoid deeply nested Firestore document structures**
5. **Don't forget to handle CORS in HTTP functions**
6. **Avoid using synchronous operations in async contexts**

## Development Commands Reference

```bash
# Local development
firebase emulators:start                    # Start emulators
firebase emulators:export ./backup         # Export emulator data
firebase emulators:start --import ./backup # Import emulator data

# Testing
pytest                                      # Run all tests
pytest tests/test_auth.py                  # Run specific test file
pytest -v --tb=short                       # Verbose output with short traceback

# Code quality
black .                                     # Format code
flake8 .                                   # Lint code
mypy src/                                  # Type checking

# Deployment
firebase deploy                            # Deploy everything
firebase deploy --only functions          # Deploy functions only
firebase deploy --only hosting            # Deploy hosting only

# Project management
firebase projects:list                     # List Firebase projects
firebase use project-id                   # Switch to project
firebase login                            # Authenticate with Firebase
```

This guide provides a solid foundation for developing Python applications with Firebase, optimized for both human developers and agentic LLM coding assistance.
