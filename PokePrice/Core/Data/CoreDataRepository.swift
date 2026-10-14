//
//  CoreDataRepository.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import Foundation
import CoreData

protocol CoreDataRepositoryProtocol {
    // Card caching
    func cacheCard(_ cardInfo: CardInfo, expiryInterval: TimeInterval) async throws
    func getCachedCard(cardId: String) async throws -> CardInfo?
    func getAllCachedCards() async throws -> [CardInfo]
    func removeCachedCard(cardId: String) async throws
    func clearExpiredCards() async throws
    
    // Pricing caching
    func cachePricing(_ pricingData: PricingData, expiryInterval: TimeInterval) async throws
    func getCachedPricing(cardId: String) async throws -> PricingData?
    func getAllCachedPricing() async throws -> [PricingData]
    func removeCachedPricing(cardId: String) async throws
    func clearExpiredPricing() async throws
    
    // Scan history
    func saveToHistory(_ historyItem: HistoryItem) async throws
    func getHistory(limit: Int?) async throws -> [HistoryItem]
    func deleteHistoryItem(historyId: String) async throws
    func clearHistory() async throws
    
    // Maintenance
    func clearAllData() async throws
}

class CoreDataRepository: CoreDataRepositoryProtocol {
    
    private let coreDataStack: CoreDataStack
    private let cacheValidityDuration: TimeInterval = 24 * 60 * 60 // 24 hours
    
    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - Card Caching
    
    func cacheCard(_ cardInfo: CardInfo, expiryInterval: TimeInterval = 24 * 60 * 60) async throws {
        try await coreDataStack.backgroundContext.perform {
            let context = self.coreDataStack.backgroundContext
            
            // Check if card already exists
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CachedCard")
            fetchRequest.predicate = NSPredicate(format: "cardId == %@", cardInfo.id)
            
            let existingCards = try? context.fetch(fetchRequest)
            let existingCard = existingCards?.first as? CachedCard
            
            if let existingCard = existingCard {
                // Update existing card
                existingCard.name = cardInfo.name
                existingCard.setName = cardInfo.setName
                existingCard.setCode = cardInfo.setCode
                existingCard.cardNumber = cardInfo.cardNumber
                existingCard.rarity = cardInfo.rarity
                existingCard.condition = cardInfo.condition
                existingCard.language = cardInfo.language
                existingCard.imageUrl = cardInfo.imageUrl
                existingCard.expiresAt = Date().addingTimeInterval(expiryInterval)
            } else {
                // Create new card
                let cachedCard = CachedCard.from(cardInfo: cardInfo, expiryInterval: expiryInterval)
                context.insert(cachedCard)
            }
            
            try context.save()
        }
    }
    
    func getCachedCard(cardId: String) async throws -> CardInfo? {
        return try await coreDataStack.backgroundContext.perform {
            let context = self.coreDataStack.backgroundContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CachedCard")
            fetchRequest.predicate = NSPredicate(format: "cardId == %@", cardId)
            
            let results = try? context.fetch(fetchRequest)
            guard let cachedCard = results?.first as? CachedCard else {
                return nil
            }
            
            // Check if expired
            if cachedCard.isExpired {
                context.delete(cachedCard)
                try context.save()
                return nil
            }
            
            return cachedCard.toCardInfo()
        }
    }
    
    func removeCachedCard(cardId: String) async throws {
        try await coreDataStack.backgroundContext.perform {
            let context = self.coreDataStack.backgroundContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CachedCard")
            fetchRequest.predicate = NSPredicate(format: "cardId == %@", cardId)
            
            let results = try? context.fetch(fetchRequest)
            if let cachedCard = results?.first {
                context.delete(cachedCard)
                try context.save()
            }
        }
    }
    
    func clearExpiredCards() async throws {
        try await coreDataStack.backgroundContext.perform {
            let context = self.coreDataStack.backgroundContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CachedCard")
            fetchRequest.predicate = NSPredicate(format: "expiresAt < %@", Date() as NSDate)
            
            let results = try? context.fetch(fetchRequest)
            results?.forEach { context.delete($0) }
            
            try context.save()
        }
    }
    
    func getAllCachedCards() async throws -> [CardInfo] {
        return try await coreDataStack.backgroundContext.perform {
            let context = self.coreDataStack.backgroundContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CachedCard")
            
            let results = try context.fetch(fetchRequest)
            return (results as? [CachedCard])?.map { $0.toCardInfo() } ?? []
        }
    }
    
    // MARK: - Pricing Caching
    
    func cachePricing(_ pricingData: PricingData, expiryInterval: TimeInterval = 24 * 60 * 60) async throws {
        try await coreDataStack.backgroundContext.perform {
            let context = self.coreDataStack.backgroundContext
            
            // Check if pricing already exists
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CachedPricing")
            fetchRequest.predicate = NSPredicate(format: "cardId == %@", pricingData.cardId)
            
            let existingPricingList = try? context.fetch(fetchRequest)
            let existingPricing = existingPricingList?.first as? CachedPricing
            
            if let existingPricing = existingPricing {
                // Update existing pricing
                existingPricing.usdMarketPrice = pricingData.usdPrice?.marketPrice ?? 0
                existingPricing.usdLowPrice = pricingData.usdPrice?.lowPrice ?? 0
                existingPricing.usdMidPrice = pricingData.usdPrice?.midPrice ?? 0
                existingPricing.usdHighPrice = pricingData.usdPrice?.highPrice ?? 0
                existingPricing.usdSource = pricingData.usdPrice?.source ?? ""
                existingPricing.eurTrendPrice = pricingData.eurPrice?.trendPrice ?? 0
                existingPricing.eurAvgPrice = pricingData.eurPrice?.avgPrice ?? 0
                existingPricing.eurLowPrice = pricingData.eurPrice?.lowPrice ?? 0
                existingPricing.eurSource = pricingData.eurPrice?.source ?? ""
                existingPricing.brlMinPrice = pricingData.brlPrice?.minPrice ?? 0
                existingPricing.brlAvgPrice = pricingData.brlPrice?.avgPrice ?? 0
                existingPricing.brlMaxPrice = pricingData.brlPrice?.maxPrice ?? 0
                existingPricing.brlSource = pricingData.brlPrice?.source ?? ""
                existingPricing.lastUpdated = pricingData.lastUpdated
                existingPricing.currency = pricingData.currency
                existingPricing.expiresAt = Date().addingTimeInterval(expiryInterval)
            } else {
                // Create new pricing
                let cachedPricing = CachedPricing.from(pricingData: pricingData, expiryInterval: expiryInterval)
                context.insert(cachedPricing)
            }
            
            try context.save()
        }
    }
    
    func getCachedPricing(cardId: String) async throws -> PricingData? {
        return try await coreDataStack.backgroundContext.perform {
            let context = self.coreDataStack.backgroundContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CachedPricing")
            fetchRequest.predicate = NSPredicate(format: "cardId == %@", cardId)
            
            let results = try? context.fetch(fetchRequest)
            guard let cachedPricing = results?.first as? CachedPricing else {
                return nil
            }
            
            // Check if expired
            if cachedPricing.isExpired {
                context.delete(cachedPricing)
                try context.save()
                return nil
            }
            
            return cachedPricing.toPricingData()
        }
    }
    
    func removeCachedPricing(cardId: String) async throws {
        try await coreDataStack.backgroundContext.perform {
            let context = self.coreDataStack.backgroundContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CachedPricing")
            fetchRequest.predicate = NSPredicate(format: "cardId == %@", cardId)
            
            let results = try? context.fetch(fetchRequest)
            if let cachedPricing = results?.first {
                context.delete(cachedPricing)
                try context.save()
            }
        }
    }
    
    func clearExpiredPricing() async throws {
        try await coreDataStack.backgroundContext.perform {
            let context = self.coreDataStack.backgroundContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CachedPricing")
            fetchRequest.predicate = NSPredicate(format: "expiresAt < %@", Date() as NSDate)
            
            let results = try? context.fetch(fetchRequest)
            results?.forEach { context.delete($0) }
            
            try context.save()
        }
    }
    
    func getAllCachedPricing() async throws -> [PricingData] {
        return try await coreDataStack.backgroundContext.perform {
            let context = self.coreDataStack.backgroundContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CachedPricing")
            
            let results = try context.fetch(fetchRequest)
            return (results as? [CachedPricing])?.map { $0.toPricingData() } ?? []
        }
    }
    
    // MARK: - Scan History
    
    func saveToHistory(_ historyItem: HistoryItem) async throws {
        try await coreDataStack.backgroundContext.perform {
            let context = self.coreDataStack.backgroundContext
            
            let scanHistory = ScanHistory.from(historyItem: historyItem)
            context.insert(scanHistory)
            
            try context.save()
        }
    }
    
    func getHistory(limit: Int? = nil) async throws -> [HistoryItem] {
        return try await coreDataStack.backgroundContext.perform {
            let context = self.coreDataStack.backgroundContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ScanHistory")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "scanDate", ascending: false)]
            
            if let limit = limit {
                fetchRequest.fetchLimit = limit
            }
            
            let results = try context.fetch(fetchRequest)
            return (results as? [ScanHistory])?.map { $0.toHistoryItem() } ?? []
        }
    }
    
    func deleteHistoryItem(historyId: String) async throws {
        try await coreDataStack.backgroundContext.perform {
            let context = self.coreDataStack.backgroundContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ScanHistory")
            fetchRequest.predicate = NSPredicate(format: "historyId == %@", historyId)
            
            let results = try? context.fetch(fetchRequest)
            if let scanHistory = results?.first {
                context.delete(scanHistory)
                try context.save()
            }
        }
    }
    
    func clearHistory() async throws {
        try await coreDataStack.backgroundContext.perform {
            let context = self.coreDataStack.backgroundContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ScanHistory")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            try context.execute(deleteRequest)
            try context.save()
        }
    }
    
    // MARK: - Maintenance
    
    func clearAllData() async throws {
        try await coreDataStack.backgroundContext.perform {
            self.coreDataStack.clearAllData()
        }
    }
}
