//
//  CacheInvalidationManager.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import Foundation

enum CacheInvalidationStrategy {
    case timeBased(expiryInterval: TimeInterval)
    case sizeBased(maxItems: Int)
    case manual
    case combined(strategies: [CacheInvalidationStrategy])
}

class CacheInvalidationManager {
    
    private let coreDataRepository: CoreDataRepositoryProtocol
    private let invalidationStrategy: CacheInvalidationStrategy
    
    init(coreDataRepository: CoreDataRepositoryProtocol = CoreDataRepository(),
         invalidationStrategy: CacheInvalidationStrategy = .timeBased(expiryInterval: 24 * 60 * 60)) {
        self.coreDataRepository = coreDataRepository
        self.invalidationStrategy = invalidationStrategy
    }
    
    func performInvalidation() async throws {
        switch invalidationStrategy {
        case .timeBased:
            try await performTimeBasedInvalidation()
        case .sizeBased(let maxItems):
            try await performSizeBasedInvalidation(maxItems: maxItems)
        case .manual:
            // Manual invalidation doesn't perform automatic cleanup
            break
        case .combined(let strategies):
            for strategy in strategies {
                let tempManager = CacheInvalidationManager(
                    coreDataRepository: coreDataRepository,
                    invalidationStrategy: strategy
                )
                try await tempManager.performInvalidation()
            }
        }
    }
    
    private func performTimeBasedInvalidation() async throws {
        if case .timeBased = invalidationStrategy {
            try await coreDataRepository.clearExpiredCards()
            try await coreDataRepository.clearExpiredPricing()
        }
    }
    
    private func performSizeBasedInvalidation(maxItems: Int) async throws {
        // Get current counts
        let history = try await coreDataRepository.getHistory(limit: nil)
        
        if history.count > maxItems {
            // Remove oldest items
            let itemsToRemove = history.count - maxItems
            let oldestItems = Array(history.suffix(itemsToRemove))
            
            for item in oldestItems {
                try await coreDataRepository.deleteHistoryItem(historyId: item.historyId)
            }
        }
    }
    
    func invalidateCard(cardId: String) async throws {
        try await coreDataRepository.removeCachedCard(cardId: cardId)
        try await coreDataRepository.removeCachedPricing(cardId: cardId)
    }
    
    func invalidateAll() async throws {
        try await coreDataRepository.clearAllData()
    }
    
    func getCacheSize() async throws -> CacheSize {
        let history = try await coreDataRepository.getHistory(limit: nil)
        let cards = try await coreDataRepository.getAllCachedCards()
        let pricing = try await coreDataRepository.getAllCachedPricing()
        
        return CacheSize(
            totalItems: history.count + cards.count + pricing.count,
            historyItems: history.count,
            cachedCards: cards.count,
            cachedPricing: pricing.count
        )
    }
}

struct CacheSize {
    let totalItems: Int
    let historyItems: Int
    let cachedCards: Int
    let cachedPricing: Int
}
