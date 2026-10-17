"""
PokePrice Backend API
FastAPI backend for Pokemon TCG card identification and pricing
"""

from fastapi import FastAPI, HTTPException, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, Dict, Any
import base64
import io
from PIL import Image
import numpy as np
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="PokePrice API",
    description="Pokemon TCG Card Identification and Pricing API",
    version="1.0.0"
)

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure appropriately for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Pydantic models
class CardIdentificationRequest(BaseModel):
    image: str  # Base64 encoded image

class CardIdentificationResponse(BaseModel):
    success: bool
    card: Optional[Dict[str, Any]] = None
    error: Optional[str] = None

class PricingData(BaseModel):
    brl_price: Optional[Dict[str, float]] = None
    usd_price: Optional[Dict[str, float]] = None
    eur_price: Optional[Dict[str, float]] = None

class CurrencyConversionRequest(BaseModel):
    from_currency: str
    to_currency: str
    amount: float

class CurrencyConversionResponse(BaseModel):
    success: bool
    result: Optional[float] = None
    error: Optional[str] = None

# Mock data for card identification (replace with actual ML model)
MOCK_CARD_DATABASE = {
    "charizard_ex": {
        "id": "charizard_ex_123",
        "name": "Charizard ex",
        "setName": "Obsidian Flames",
        "setCode": "OBF",
        "cardNumber": "147/197",
        "rarity": "Ultra Rare",
        "imageUrl": "https://images.pokemontcg.io/obsidianflames/147_hires.png"
    },
    "pikachu_base": {
        "id": "pikachu_base_456",
        "name": "Pikachu",
        "setName": "Base Set",
        "setCode": "BS",
        "cardNumber": "58/102",
        "rarity": "Common",
        "imageUrl": "https://images.pokemontcg.io/base1/58_hires.png"
    }
}

# Mock pricing data (replace with actual pricing API)
MOCK_PRICING_DATA = {
    "charizard_ex_123": {
        "brl_price": {"avg_price": 250.00, "low_price": 180.00, "high_price": 350.00, "source": "LigaPokemon"},
        "usd_price": {"market_price": 45.00, "low_price": 35.00, "high_price": 60.00},
        "eur_price": {"trend_price": 42.00, "low_price": 32.00, "high_price": 55.00}
    },
    "pikachu_base_456": {
        "brl_price": {"avg_price": 15.00, "low_price": 8.00, "high_price": 25.00, "source": "LigaPokemon"},
        "usd_price": {"market_price": 2.50, "low_price": 1.50, "high_price": 4.00},
        "eur_price": {"trend_price": 2.30, "low_price": 1.40, "high_price": 3.80}
    }
}

# Mock currency exchange rates (replace with actual API)
EXCHANGE_RATES = {
    "USD": 1.0,
    "BRL": 5.5,
    "EUR": 0.92
}

@app.get("/")
async def root():
    """Root endpoint with API information"""
    return {
        "message": "PokePrice API",
        "version": "1.0.0",
        "endpoints": {
            "identify": "/api/identify",
            "pricing": "/api/pricing/{card_id}",
            "currency": "/api/currency/convert"
        }
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy"}

@app.post("/api/identify", response_model=CardIdentificationResponse)
async def identify_card(request: CardIdentificationRequest):
    """
    Identify a Pokemon TCG card from image
    
    Args:
        request: CardIdentificationRequest with base64 encoded image
    
    Returns:
        CardIdentificationResponse with card information
    """
    try:
        # Decode base64 image
        image_data = base64.b64decode(request.image)
        image = Image.open(io.BytesIO(image_data))
        
        logger.info(f"Received image for identification: {image.size}")
        
        # TODO: Replace with actual ML model for card identification
        # For now, return a mock response
        card_info = MOCK_CARD_DATABASE["charizard_ex"]
        
        return CardIdentificationResponse(
            success=True,
            card=card_info
        )
        
    except Exception as e:
        logger.error(f"Error identifying card: {str(e)}")
        return CardIdentificationResponse(
            success=False,
            error=f"Failed to identify card: {str(e)}"
        )

@app.get("/api/pricing/{card_id}", response_model=PricingData)
async def get_pricing(card_id: str):
    """
    Get pricing information for a specific card
    
    Args:
        card_id: ID of the card
    
    Returns:
        PricingData with pricing information in multiple currencies
    """
    try:
        logger.info(f"Fetching pricing for card: {card_id}")
        
        # Check if pricing data exists
        if card_id not in MOCK_PRICING_DATA:
            raise HTTPException(status_code=404, detail="Card pricing not found")
        
        pricing_data = MOCK_PRICING_DATA[card_id]
        
        return PricingData(**pricing_data)
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching pricing: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Failed to fetch pricing: {str(e)}")

@app.post("/api/currency/convert", response_model=CurrencyConversionResponse)
async def convert_currency(request: CurrencyConversionRequest):
    """
    Convert currency
    
    Args:
        request: CurrencyConversionRequest with from_currency, to_currency, amount
    
    Returns:
        CurrencyConversionResponse with converted amount
    """
    try:
        logger.info(f"Converting {request.amount} {request.from_currency} to {request.to_currency}")
        
        # Get exchange rates
        from_rate = EXCHANGE_RATES.get(request.from_currency.upper())
        to_rate = EXCHANGE_RATES.get(request.to_currency.upper())
        
        if from_rate is None or to_rate is None:
            return CurrencyConversionResponse(
                success=False,
                error="Unsupported currency"
            )
        
        # Convert to USD first, then to target currency
        usd_amount = request.amount / from_rate
        result = usd_amount * to_rate
        
        return CurrencyConversionResponse(
            success=True,
            result=round(result, 2)
        )
        
    except Exception as e:
        logger.error(f"Error converting currency: {str(e)}")
        return CurrencyConversionResponse(
            success=False,
            error=f"Failed to convert currency: {str(e)}"
        )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)