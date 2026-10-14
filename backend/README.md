# PokePrice Backend API

FastAPI backend for Pokemon TCG card identification and pricing.

## Features

- Card identification from images
- Multi-currency pricing data (BRL, USD, EUR)
- Currency conversion
- Health check endpoint
- CORS support

## Local Development

### Prerequisites

- Python 3.11+
- pip

### Installation

```bash
cd backend
pip install -r requirements.txt
```

### Running the Server

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

The API will be available at `http://localhost:8000`

### API Documentation

- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

## API Endpoints

### Health Check
- `GET /health` - Health check endpoint

### Card Identification
- `POST /api/identify` - Identify a Pokemon TCG card from image
  - Request: `{"image": "base64_encoded_image"}`
  - Response: Card information

### Pricing
- `GET /api/pricing/{card_id}` - Get pricing for a specific card
  - Response: Pricing data in BRL, USD, EUR

### Currency Conversion
- `POST /api/currency/convert` - Convert between currencies
  - Request: `{"from_currency": "USD", "to_currency": "BRL", "amount": 100}`
  - Response: Converted amount

## Deployment

### Railway

1. Push this code to a GitHub repository
2. Create a new project on Railway
3. Connect your GitHub repository
4. Railway will automatically detect the Python project and deploy it
5. The `railway.toml` file provides deployment configuration

### Render

1. Push this code to a GitHub repository
2. Create a new Web Service on Render
3. Connect your GitHub repository
4. Configure the build and start commands:
   - Build Command: `pip install -r requirements.txt`
   - Start Command: `uvicorn main:app --host 0.0.0.0 --port $PORT`
5. The `render.yaml` file provides deployment configuration

## Environment Variables

Configure these environment variables in your deployment platform:

- `PORT`: Server port (default: 8000)
- `PYTHON_VERSION`: Python version (default: 3.11.0)

## iOS App Integration

Update the backend URL in the iOS app:

```swift
// In NetworkService.swift and CardIdentificationService.swift
private let baseURL = "https://your-backend-url.railway.app"
```

Replace `your-backend-url.railway.app` with your actual deployed backend URL.

## Current Status

The backend currently uses mock data for:
- Card identification (replace with actual ML model)
- Pricing data (replace with actual pricing API)
- Currency exchange rates (replace with actual exchange rate API)

## Future Enhancements

- Integrate actual ML model for card identification
- Connect to real Pokemon TCG pricing APIs
- Implement real-time currency exchange rates
- Add authentication and rate limiting
- Implement database for storing scan history
- Add caching layer for improved performance