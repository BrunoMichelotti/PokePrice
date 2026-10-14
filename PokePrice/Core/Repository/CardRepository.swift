//
//  CardRepository.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import Foundation

class CardRepository: CardRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let coreDataRepository: CoreDataRepositoryProtocol
    private let cacheInvalidationManager: CacheInvalidationManager
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared,
         coreDataRepository: CoreDataRepositoryProtocol = CoreDataRepository(),
         cacheInvalidationManager: CacheInvalidationManager = CacheInvalidationManager()) {
        self.networkService = networkService
        self.coreDataRepository = coreDataRepository
        self.cacheInvalidationManager = cacheInvalidationManager
    }
    
    func identifyCard(imageData: Data) async throws -> CardIdentificationResponse {
        let imageBase64 = imageData.base64EncodedString()
        let endpoint = Endpoint.identifyCard(imageBase64: imageBase64)
        
        return try await withCheckedThrowingContinuation { continuation in
            networkService.request(endpoint) { (result: Result<CardIdentificationResponse, Error>) in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getPricing(cardId: String) async throws -> PricingData {
        // Check CoreData cache first
        if let cachedPricing = try? await coreDataRepository.getCachedPricing(cardId: cardId) {
            return cachedPricing
        }
        
        let endpoint = Endpoint.getPricing(cardId: cardId)
        
        let pricingData = try await withCheckedThrowingContinuation { continuation in
            networkService.request(endpoint) { (result: Result<PricingData, Error>) in
                switch result {
                case .success(let pricing):
                    continuation.resume(returning: pricing)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
        
        // Cache the result in CoreData
        try? await coreDataRepository.cachePricing(pricingData, expiryInterval: 24 * 60 * 60)
        
        return pricingData
    }
    
    func getCardInfo(cardId: String) async throws -> CardInfo {
        // Check CoreData cache first
        if let cachedCard = try? await coreDataRepository.getCachedCard(cardId: cardId) {
            return cachedCard
        }
        
        // This would typically fetch from a cards API
        // For now, we'll implement a basic version
        let endpoint = Endpoint.getPricing(cardId: cardId)
        
        let pricingData = try await withCheckedThrowingContinuation { continuation in
            networkService.request(endpoint) { (result: Result<PricingData, Error>) in
                switch result {
                case .success(let pricing):
                    continuation.resume(returning: pricing)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
        
        // Create a basic CardInfo from the pricing data
        // In a real implementation, this would come from a dedicated cards endpoint
        throw APIError.customError("Card info endpoint not implemented")
    }
    
    func searchCards(query: String) async throws -> [CardInfo] {
        // This would implement a search API
        // For now, return empty array
        return []
    }
    
    // MARK: - Cache Management
    
    func clearCache(for cardId: String) async throws {
        try await coreDataRepository.removeCachedCard(cardId: cardId)
        try await coreDataRepository.removeCachedPricing(cardId: cardId)
    }
    
    func clearAllCache() async throws {
        try await coreDataRepository.clearAllData()
    }
    
    func performCacheMaintenance() async throws {
        try await cacheInvalidationManager.performInvalidation()
    }
    
    func getCacheSize() async throws -> CacheSize {
        return try await cacheInvalidationManager.getCacheSize()
    }
}
