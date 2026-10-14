# PokePrice Architecture Documentation

## Overview
PokePrice follows a modern MVVM (Model-View-ViewModel) architecture with a feature-based structure, implementing clean architecture principles and separation of concerns.

## Architecture Layers

### 1. Feature Layer
Each feature is self-contained with its own MVVM components:
- **Camera Feature**: Card scanning and image capture
- **Pricing Feature**: Results display and pricing information
- **History Feature**: Scan history management
- **Settings Feature**: App configuration and preferences

### 2. Core Layer
Shared components and utilities used across features:
- **Networking**: API communication and error handling
- **Data**: Core Data persistence and caching
- **Models**: Data models and DTOs
- **Utils**: Analytics and helper utilities
- **Architecture**: Base classes and patterns
- **Coordinator**: Navigation management
- **Repository**: Data access abstraction

## MVVM Pattern

### Model
- Data structures representing business entities
- Located in `Core/Models/`
- Examples: `CardInfo`, `PricingData`, `CardIdentificationResponse`

### View
- UI components that display data
- Located in `Features/{Feature}/View/`
- Examples: `CameraView`, `ResultsView`
- Controllers in `Features/{Feature}/ViewController/`

### ViewModel
- Business logic and state management
- Located in `Features/{Feature}/ViewModel/`
- Inherits from `BaseViewModel` for common functionality
- Uses Combine for reactive programming
- Examples: `CameraViewModel`, `ResultsViewModel`

## Design Patterns

### Repository Pattern
Abstracts data access logic and provides a clean interface for data operations:
- `CardRepositoryProtocol`: Defines data operations
- `CardRepository`: Concrete implementation with CoreData caching
- `CoreDataRepositoryProtocol`: CoreData-specific operations
- `CoreDataRepository`: CoreData implementation with async/await
- Located in `Core/Repository/` and `Core/Data/`

### Coordinator Pattern
Manages navigation flow and reduces coupling between view controllers:
- `Coordinator`: Base protocol for all coordinators
- `AppCoordinator`: Root coordinator managing app flow
- Feature coordinators: `CameraCoordinator`, `ResultsCoordinator`, etc.
- Located in `Core/Coordinator/` and `Features/{Feature}/Coordinator/`

### Dependency Injection
Centralized dependency management through `DependencyContainer`:
- Provides lazy-loaded dependencies
- Factory methods for creating ViewModels with proper dependencies
- Located in `Core/Architecture/DependencyContainer.swift`

### Protocol-Oriented Programming
All services and managers use protocols for testability and flexibility:
- `NetworkServiceProtocol`, `CardIdentificationServiceProtocol`
- `CacheManagerProtocol`, `AnalyticsManagerProtocol`
- `CardRepositoryProtocol`, `CoreDataRepositoryProtocol`

### CoreData Caching
Advanced local caching with automatic invalidation:
- `CoreDataStack`: Manages CoreData stack with background contexts
- `CoreDataRepository`: Async/await operations for caching
- `CacheInvalidationManager`: Multiple invalidation strategies
- `ManagedObjectModels`: Type-safe CoreData entities
- Supports time-based, size-based, and manual cache clearing

## Directory Structure

```
PokePrice/
├── Core/
│   ├── Architecture/
│   │   ├── BaseViewModel.swift
│   │   ├── BaseViewController.swift
│   │   └── DependencyContainer.swift
│   ├── Coordinator/
│   │   ├── Coordinator.swift
│   │   └── AppCoordinator.swift
│   ├── Data/
│   │   ├── CacheModel.swift
│   │   ├── CacheManagerProtocol.swift
│   │   ├── CoreDataManager.swift
│   │   ├── CoreDataStack.swift
│   │   ├── CoreDataRepository.swift
│   │   ├── CoreDataModelSetup.swift
│   │   ├── ManagedObjectModels.swift
│   │   ├── PokePriceDataModel.swift
│   │   └── CacheInvalidationManager.swift
│   ├── Models/
│   │   ├── CardIdentificationResponse.swift
│   │   └── PricingData.swift
│   ├── Networking/
│   │   ├── APIError.swift
│   │   ├── NetworkService.swift
│   │   └── CardIdentificationService.swift
│   ├── Repository/
│   │   ├── CardRepositoryProtocol.swift
│   │   └── CardRepository.swift
│   └── Utils/
│       ├── AnalyticsManager.swift
│       └── AnalyticsManagerProtocol.swift
├── Features/
│   ├── Camera/
│   │   ├── Coordinator/
│   │   │   └── CameraCoordinator.swift
│   │   ├── ViewModel/
│   │   │   └── CameraViewModel.swift
│   │   ├── View/
│   │   │   └── CameraView.swift
│   │   └── ViewController/
│   │       └── CameraViewController.swift
│   ├── Pricing/
│   │   ├── Coordinator/
│   │   │   └── ResultsCoordinator.swift
│   │   ├── ViewModel/
│   │   │   └── ResultsViewModel.swift
│   │   ├── View/
│   │   │   └── ResultsView.swift
│   │   └── ViewController/
│   │       └── ResultsViewController.swift
│   ├── History/
│   │   ├── Coordinator/
│   │   │   └── HistoryCoordinator.swift
│   │   └── ViewModel/
│   │       └── HistoryViewModel.swift
│   └── Settings/
│       ├── Coordinator/
│       │   └── SettingsCoordinator.swift
│       └── ViewModel/
│           └── SettingsViewModel.swift
├── AppDelegate.swift
└── SceneDelegate.swift
```

## Key Principles

### Separation of Concerns
- Each layer has a specific responsibility
- No circular dependencies between layers
- Views only handle UI, ViewModels handle logic

### Testability
- Protocol-oriented design enables easy mocking
- Dependency injection allows for test doubles
- ViewModels can be tested independently of UI

### Scalability
- Feature-based structure allows easy addition of new features
- Repository pattern enables swapping data sources
- Coordinator pattern makes navigation flows manageable

### Maintainability
- Clear naming conventions
- Consistent file organization
- Reusable base classes and protocols

## Data Flow

1. **User Action** → View captures user interaction
2. **ViewModel Processing** → ViewModel processes logic through Repository
3. **Repository** → Handles data access (network, cache, database)
4. **Response** → Data flows back through Repository → ViewModel → View
5. **UI Update** → View updates based on ViewModel state changes

## Best Practices

### ViewModels
- Inherit from `BaseViewModel` for common functionality
- Use `@Published` properties for reactive binding
- Keep UI-specific code out of ViewModels
- Use protocols for dependencies

### Views
- Keep views lightweight and focused on UI
- Use Combine to subscribe to ViewModel changes
- Implement delegate patterns for user actions

### Coordinators
- One coordinator per feature flow
- Use weak references to avoid retain cycles
- Clean up child coordinators when done

### Repository
- Implement caching strategy
- Handle errors appropriately
- Use async/await for network operations

## Future Enhancements

- [ ] Implement proper unit testing infrastructure
- [ ] Add SwiftUI views alongside UIKit
- [ ] Implement offline-first architecture
- [ ] Add comprehensive error handling
- [ ] Implement deep linking support
- [ ] Add performance monitoring
- [ ] Add CoreData migration support for schema changes
- [ ] Implement background sync for cached data
