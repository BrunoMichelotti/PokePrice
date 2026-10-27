# PokePrice

iOS application for Pokemon TCG card identification and pricing, focused on the Brazilian market.

## Overview

PokePrice is a mobile app designed for Pokemon TCG collectors in Brazil, providing instant card identification and accurate pricing in Brazilian Real (BRL). The app uses camera-based scanning to identify cards and fetches pricing data from multiple sources.

## Current Status

**Phase:** Foundation Setup (Phase 1)
**Backend:** ✅ Deployed and Operational on Railway
**iOS:** In Development

### Backend Infrastructure

- **URL:** https://pokeprice-production-b0ac.up.railway.app
- **Framework:** FastAPI 0.104.1
- **Deployment:** Railway (Docker-based)
- **API Documentation:** https://pokeprice-production-b0ac.up.railway.app/docs

**Implemented Endpoints:**
- `GET /` - API information
- `GET /health` - Health check
- `POST /api/identify` - Card identification (mock)
- `GET /api/pricing/{card_id}` - Pricing data (mock)
- `POST /api/currency/convert` - Currency conversion (mock)

### iOS Application

**Architecture:** MVVM with feature-based structure
**CoreData:** ✅ Configured with entities for card caching and scan history
**Planned Dependencies:**
- Alamofire (networking)
- Firebase Analytics & Crashlytics (monitoring)

## Project Management

**Issue Tracker:** GitHub Issues
**Issues:** https://github.com/BrunoMichelotti/PokePrice/issues

### Implementation Roadmap

The project is broken down into 11 vertical tickets, each representing a complete end-to-end feature.

| # | Ticket | Status | Blocked By |
|---|--------|--------|------------|
| 1 | Finish CoreData Setup and Exercise | ✅ Complete | None |
| 2 | Integrate PokeWallet MCP in Backend | Ready | None |
| 3 | Integrate LigaPokemon Pricing API | Ready | None |
| 4 | Set Up Alamofire Networking in iOS App | Ready | None |
| 5 | Implement Camera Capture in iOS App | Ready | #4 |
| 6 | Implement Card Identification Flow in iOS App | Ready | #4, #5 |
| 7 | Build Results Screen with Card Details | Ready | #6 |
| 8 | Implement Scan History with CoreData | Ready | #1, #7 |
| 9 | Implement Banco Central Currency Conversion | Ready | None |
| 10 | Implement Redis Caching in Backend | Ready | None |
| 11 | Set Up Firebase Analytics and Crash Reporting | Ready | None |

## Next Steps

### Tickets Ready to Start (6 tickets)

1. **#4: Set Up Alamofire Networking in iOS App**
   - Install Alamofire via Swift Package Manager
   - Create NetworkService class with singleton pattern
   - Implement request methods for GET/POST endpoints
   - Configure base URL for Railway backend

2. **#2: Integrate PokeWallet MCP in Backend**
   - Research PokeWallet MCP API documentation
   - Install and configure PokeWallet MCP client
   - Replace mock card identification with real API
   - Implement error handling with fallback

3. **#3: Integrate LigaPokemon Pricing API**
   - Set up Apify client in Python backend
   - Configure LigaPokemon Apify actor and API credentials
   - Implement LigaPokemon price fetching
   - Add Redis caching for 24h expiry

4. **#9: Implement Banco Central Currency Conversion**
   - Research Banco Central do Brasil API documentation
   - Implement currency conversion endpoint using BCB API
   - Add caching for exchange rates (Redis, 24h expiry)
   - Implement fallback rates when BCB API is unavailable

5. **#10: Implement Redis Caching in Backend**
   - Set up Redis instance on Railway
   - Install Redis client in Python backend (redis-py)
   - Implement cache wrapper for card identification results
   - Set 24h TTL for all cached data

6. **#11: Set Up Firebase Analytics and Crash Reporting**
   - Set up Firebase project in Firebase Console
   - Add Firebase SDK via Swift Package Manager
   - Configure Firebase Crashlytics and Analytics
   - Add basic event tracking (card scans, errors)

**Recommended Priority:** Start with #4 (Alamofire) to establish iOS foundation, then #2 and #3 for backend integrations.

## Key Features

### Camera-First Workflow
- Full-screen camera with card outline overlay
- Instant card identification via PokeWallet MCP
- Lighting and positioning guidance

### Accurate BRL Pricing
- Primary data source: LigaPokemon (Apify integration)
- Reference pricing: TCGPlayer (USD), CardMarket (EUR)
- Real-time currency conversion via Banco Central do Brasil

### Scan History
- Local storage with CoreData
- 24h price caching for offline viewing
- Search and filter functionality

### Multi-Currency Support
- BRL (primary)
- USD (reference)
- EUR (reference)
- Currency conversion API

## Tech Stack

### Backend
- **Language:** Python 3.11
- **Framework:** FastAPI
- **Deployment:** Railway
- **Database:** Redis (planned)

### iOS
- **Language:** Swift
- **Architecture:** MVVM
- **Storage:** CoreData
- **Networking:** Alamofire (planned)
- **Monitoring:** Firebase (planned)

## Project Structure

```
PokePrice/
├── PokePrice/                    # iOS App
│   ├── Core/
│   │   ├── Data/                 # CoreData stack
│   │   ├── Models/               # Data models
│   │   └── Networking/           # Network layer (planned)
│   └── Features/                # Feature modules
│       ├── Camera/               # Camera functionality (planned)
│       ├── History/              # Scan history (planned)
│       ├── Pricing/             # Pricing display (planned)
│       └── Settings/             # App settings (planned)
├── backend/                      # FastAPI backend
│   ├── main.py                   # FastAPI application
│   ├── Dockerfile                # Docker configuration
│   ├── requirements.txt          # Python dependencies
│   └── railway.toml             # Railway configuration
├── docs/                         # Documentation
│   └── agents/                   # Agent skills configuration
├── PROJECT_STATUS.md             # Detailed project status
└── README.md                     # This file
```

## Success Metrics

### MVP Success Criteria
- 1,000+ downloads in first month
- 70%+ card identification success rate
- 40%+ day-7 retention rate
- API cost under $0.05 per user

### 6-Month Success Criteria
- 10,000+ active users
- 80%+ identification success rate
- 50%+ month-1 retention rate
- Positive user reviews (4.0+ stars)

## Contributing

This project uses GitHub Issues for project management. Please refer to the issues tab for current work items and roadmap.

## License

[License information to be added]

## Contact

**Project Owner:** Bruno Michelotti
**GitHub:** @BrunoMichelotti
**Repository:** https://github.com/BrunoMichelotti/PokePrice

---

For detailed project status, see [PROJECT_STATUS.md](PROJECT_STATUS.md)
