# PokePrice Project Status

**Last Updated:** November 3, 2026
**Project Status:** Active Development
**Current Phase:** Foundation Setup (Phase 1) - Core Features Started

---

## Executive Summary

PokePrice is an iOS application for Pokemon TCG card identification and pricing, focused on the Brazilian market. The project aims to provide users with accurate BRL pricing via LigaPokemon integration, with USD/EUR reference pricing for comparison.

**Current Progress:** Backend infrastructure deployed and operational on Railway, project management workflow established with GitHub Issues, implementation roadmap defined with 11 vertical tickets. CoreData stack configured, PokeWallet MCP and LigaPokemon integrated, networking layer implemented with URLSession, camera feature completed with NetworkService integration.

---

## 1. Current State

### Backend Infrastructure ✅ COMPLETE

**Status:** Deployed and Operational
**Platform:** Railway
**URL:** https://pokeprice-production-b0ac.up.railway.app

**Implemented Features:**
- FastAPI backend with health check endpoint
- PokeWallet MCP integration for card identification (POST /api/identify)
- LigaPokemon pricing integration via Apify (GET /api/pricing/{card_id})
- Currency conversion endpoint (POST /api/currency/convert)
- CORS configuration for iOS app integration
- Docker-based deployment with Railway
- Environment variable configuration for dynamic port binding

**API Endpoints:**
- `GET /` - API information
- `GET /health` - Health check
- `POST /api/identify` - Card identification via PokeWallet MCP
- `GET /api/pricing/{card_id}` - Pricing data via LigaPokemon
- `POST /api/currency/convert` - Currency conversion

**Documentation:**
- Swagger UI: https://pokeprice-production-b0ac.up.railway.app/docs
- ReDoc: https://pokeprice-production-b0ac.up.railway.app/redoc

---

## 2. Project Management

### GitHub Issues Configuration ✅ COMPLETE

**Issue Tracker:** GitHub Issues
**Labels Configured:**
- `needs-triage` - Maintainer needs to evaluate this issue
- `needs-info` - Waiting on reporter for more information
- `ready-for-agent` - Fully specified, ready for an AFK agent
- `ready-for-human` - Requires human implementation
- `wontfix` - Will not be actioned

**Agent Skills Configuration:**
- Issue tracker configured in `docs/agents/issue-tracker.md`
- Triage labels defined in `docs/agents/triage-labels.md`
- Domain docs layout configured in `docs/agents/domain.md`
- AGENTS.md created for agent skill integration

**View Issues:** https://github.com/BrunoMichelotti/PokePrice/issues

---

## 3. Implementation Roadmap

### Vertical Slice Strategy

The project is broken down into 11 vertical tickets, each representing a complete end-to-end feature. Tickets are sized to fit in a single context window and can be implemented independently.

### Ticket Overview

| # | Ticket | Status | Blocked By |
|---|--------|--------|------------|
| 1 | Finish CoreData Setup and Exercise | Complete | None |
| 2 | Integrate PokeWallet MCP in Backend | Complete | None |
| 3 | Integrate LigaPokemon Pricing API | Complete | None |
| 4 | Set Up Alamofire Networking in iOS App | Complete | None |
| 5 | Implement Camera Capture in iOS App | Complete | #4 |
| 6 | Implement Card Identification Flow in iOS App | Ready | #4, #5 |
| 7 | Build Results Screen with Card Details | Ready | #6 |
| 8 | Implement Scan History with CoreData | Ready | #1, #7 |
| 9 | Implement Banco Central Currency Conversion | Ready | None |
| 10 | Implement Redis Caching in Backend | Ready | None |
| 11 | Set Up Firebase Analytics and Crash Reporting | Ready | None |

### Dependency Graph

```
Phase 1: Foundation (COMPLETE)
├── #1: CoreData Setup ✅
├── #2: PokeWallet MCP Integration ✅
├── #3: LigaPokemon Pricing API ✅
├── #4: Alamofire Networking ✅
├── #9: Banco Central Currency Conversion (pending)
├── #10: Redis Caching (pending)
└── #11: Firebase Analytics (pending)

Phase 2: Core Features (In Progress)
├── #5: Camera Capture ✅
└── #6: Card Identification Flow [ready to start]

Phase 3: Polish & UX (Pending)
├── #7: Results Screen [blocked by #6]
└── #8: Scan History [blocked by #1, #7]
```

---

## 4. Next Steps

### Completed Tickets (5 tickets)

1. ✅ **#1: Finish CoreData Setup and Exercise** - CoreData stack configured with entities and repository
2. ✅ **#2: Integrate PokeWallet MCP in Backend** - MCP integration with logging and fallback
3. ✅ **#3: Integrate LigaPokemon Pricing API** - Apify integration with pricing endpoint
4. ✅ **#4: Set Up Alamofire Networking in iOS App** - URLSession-based NetworkService implemented
5. ✅ **#5: Implement Camera Capture in iOS App** - AVFoundation camera with NetworkService integration

### Tickets Ready to Start (1 ticket)

1. **#6: Implement Card Identification Flow in iOS App**
   - Connect camera capture to NetworkService
   - Handle identification responses
   - Navigate to results screen
   - Error handling and retry logic

### Pending Foundation Tickets (3 tickets)

1. **#9: Implement Banco Central Currency Conversion**
   - Research BCB API documentation
   - Implement currency conversion endpoint
   - Add caching for exchange rates
   - Implement fallback rates

2. **#10: Implement Redis Caching in Backend**
   - Set up Redis instance on Railway
   - Install Redis client (redis-py)
   - Implement cache wrappers
   - Configure 24h TTL

3. **#11: Set Up Firebase Analytics and Crash Reporting**
   - Set up Firebase project
   - Add Firebase SDK via SPM
   - Configure Crashlytics and Analytics
   - Add event tracking

**Recommended Priority:** Continue with #6 (Card Identification Flow) to complete the core camera-to-results flow, then proceed with #7 (Results Screen) for the UI polish.

---

## 5. Technical Foundation

### Backend Stack

**Language:** Python 3.11
**Framework:** FastAPI 0.104.1
**Deployment:** Railway (Docker-based)
**Dependencies:**
- uvicorn (ASGI server)
- pydantic (data validation)
- pillow (image processing)
- numpy (numerical operations)
- python-jose (JWT)
- passlib (password hashing)
- httpx (async HTTP client)
- aiofiles (async file operations)

**Planned Additions:**
- PokeWallet MCP integration (card identification)
- LigaPokemon Apify integration (BRL pricing)
- Redis caching (24h expiry)
- Banco Central API (currency conversion)

### iOS Stack

**Language:** Swift
**Architecture:** MVVM with feature-based structure
**UI Framework:** UIKit (planned)
**Planned Dependencies:**
- Alamofire (networking)
- CoreData (local storage)
- Firebase Analytics & Crashlytics (monitoring)

**Project Structure:**
```
PokePrice/
├── Core/
│   ├── Data/
│   │   ├── CoreDataStack.swift ✅
│   │   ├── CoreDataManager.swift ✅
│   │   ├── CoreDataModelSetup.swift ✅
│   │   ├── CoreDataRepository.swift ✅
│   │   ├── CachedCard.swift ✅
│   │   ├── CachedPricing.swift ✅
│   │   └── ScanHistory.swift ✅
│   ├── Models/
│   │   ├── CardInfo.swift ✅
│   │   ├── PricingData.swift ✅
│   │   └── HistoryItem.swift ✅
│   └── Networking/ (planned)
└── Features/
    ├── Camera/ (planned)
    ├── History/ (planned)
    ├── Pricing/ (planned)
    └── Settings/ (planned)
```

---

## 6. Project Goal

### Vision

PokePrice is a mobile application designed for Pokemon TCG collectors in Brazil, providing instant card identification and accurate pricing in Brazilian Real (BRL).

### Target Market

- **Primary:** Brazilian Pokemon TCG collectors
- **Secondary:** Global collectors with currency conversion needs

### Key Features

1. **Camera-First Workflow**
   - Full-screen camera with card outline overlay
   - Instant card identification via PokeWallet MCP
   - Lighting and positioning guidance

2. **Accurate BRL Pricing**
   - Primary data source: LigaPokemon (Apify integration)
   - Reference pricing: TCGPlayer (USD), CardMarket (EUR)
   - Real-time currency conversion via Banco Central do Brasil

3. **Scan History**
   - Local storage with CoreData
   - 24h price caching for offline viewing
   - Search and filter functionality

4. **Multi-Currency Support**
   - BRL (primary)
   - USD (reference)
   - EUR (reference)
   - Currency conversion API

### Monetization Strategy

- **Free Tier:** Limited API usage per user
- **Premium Tier:** Unlimited scans, advanced features (future)

### Launch Plan

1. **TestFlight Beta** - Brazilian market focus
2. **Brazil-Only Launch** - Validate assumptions
3. **Global Expansion** - After product-market fit

---

## 7. Success Metrics

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

### 1-Year Success Criteria

- 50,000+ active users
- Sustainable unit economics
- Expansion to additional markets
- v2 features launched and adopted

---

## 8. Risk Mitigation

### Technical Risks

**API Cost Overrun**
- Mitigation: Aggressive caching, usage limits, cost monitoring

**PokeWallet MCP Downtime**
- Mitigation: Multi-fallback strategy with manual search

**Camera Performance**
- Mitigation: Test on low-end devices, photo library fallback

### Market Risks

**User Adoption**
- Mitigation: TestFlight beta validation, iterative improvements

**Competition**
- Mitigation: Brazilian market specialization, BRL pricing accuracy

**Pokemon IP Issues**
- Mitigation: Legal counsel consultation, rebranding option

---

## 9. Recent Updates

### November 3, 2026

- ✅ Completed CoreData setup with entities and repository
- ✅ Integrated PokeWallet MCP in backend with logging and fallback
- ✅ Integrated LigaPokemon pricing via Apify
- ✅ Implemented NetworkService with URLSession (replaced Alamofire requirement)
- ✅ Completed camera feature with AVFoundation and NetworkService integration
- ✅ Fixed iOS build errors and added model conversions
- ✅ Build succeeds for iOS Simulator

### October 25, 2026

- ✅ Deployed FastAPI backend to Railway
- ✅ Configured GitHub Issues with triage workflow
- ✅ Created 11 vertical implementation tickets
- ✅ Configured agent skills (AGENTS.md, docs/agents/*)
- ✅ Set up CoreData stack with entities (CachedCard, CachedPricing, ScanHistory)
- ✅ Created data models (CardInfo, PricingData, HistoryItem)
- ✅ Implemented CoreDataRepository with full CRUD operations

### October 17, 2026

- ✅ Initial FastAPI backend created
- ✅ Dockerfile configured for Railway deployment
- ✅ Railway.toml and render.yaml configured
- ✅ Backend deployed successfully

---

## 10. Stakeholder Communication

### For Product Managers

- **Current Focus:** Foundation setup (Phase 1)
- **Next Milestone:** Complete camera and identification flow (Phase 2)
- **Timeline:** 2 weeks per phase (estimated)
- **Blocking Issues:** None

### For Developers

- **Branch Strategy:** Feature branches from main
- **Code Review:** Required for all tickets
- **Testing:** Unit tests for business logic, integration tests for APIs
- **Documentation:** Inline comments, AGENTS.md for agent context

### For Stakeholders

- **Budget:** $5/m Railway credit (free tier)
- **Timeline:** 16 weeks to launch (8 phases, 2 weeks each)
- **Risk Level:** Medium (technical complexity, market validation)
- **ROI Potential:** High (untapped Brazilian market)

---

## 11. Resources

### Documentation

- **GitHub Repository:** https://github.com/BrunoMichelotti/PokePrice
- **Backend API:** https://pokeprice-production-b0ac.up.railway.app/docs
- **Issues:** https://github.com/BrunoMichelotti/PokePrice/issues
- **Architecture:** /ARCHITECTURE.md

### External Resources

- **Railway:** https://railway.app
- **PokeWallet MCP:** (research in progress)
- **LigaPokemon:** (research in progress)
- **Banco Central API:** (research in progress)

---

## 12. Contact

**Project Owner:** Bruno Michelotti
**GitHub:** @BrunoMichelotti
**Repository:** https://github.com/BrunoMichelotti/PokePrice

---

*This document is updated weekly or upon major milestones. For real-time progress, refer to GitHub Issues.*
