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
        let backendResponse = try await networkService.identifyCard(image: imageData)
        // Convert backend response to local model
        return CardIdentificationResponse(
            success: backendResponse.success,
            card: backendResponse.card,
            error: backendResponse.error
        )
    }

    func getPricing(cardId: String) async throws -> PricingData {
        // Check CoreData cache first
        if let cachedPricing = try? await coreDataRepository.getCachedPricing(cardId: cardId) {
            return cachedPricing
        }

        let pricingData = try await networkService.getPricing(cardId: cardId)

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
        // For now, throw an error
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
