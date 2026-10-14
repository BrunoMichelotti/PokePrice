//
//  CardRepositoryProtocol.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import Foundation

protocol CardRepositoryProtocol {
    func identifyCard(imageData: Data) async throws -> CardIdentificationResponse
    func getPricing(cardId: String) async throws -> PricingData
    func getCardInfo(cardId: String) async throws -> CardInfo
    func searchCards(query: String) async throws -> [CardInfo]
    
    // Cache management
    func clearCache(for cardId: String) async throws
    func clearAllCache() async throws
    func performCacheMaintenance() async throws
    func getCacheSize() async throws -> CacheSize
}
