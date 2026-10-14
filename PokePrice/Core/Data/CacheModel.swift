//
//  CacheModel.swift
//  PokePrice
//
//  Created by Bruno on 23/08/26.
//

import Foundation

struct CacheModel {
    let cardId: String
    let cardData: CardIdentificationResponse
    let pricingData: PricingData
    let timestamp: Date
    let expiryDate: Date
    
    var isExpired: Bool {
        return Date() > expiryDate
    }
}

class CacheManager {
    
    static let shared = CacheManager()
    private let cacheValidityDuration: TimeInterval = 24 * 60 * 60 // 24 hours
    
    private init() {}
    
    private var cache: [String: CacheModel] = [:]
    
    func set(cardId: String, cardData: CardIdentificationResponse, pricingData: PricingData) {
        let cacheModel = CacheModel(
            cardId: cardId,
            cardData: cardData,
            pricingData: pricingData,
            timestamp: Date(),
            expiryDate: Date().addingTimeInterval(cacheValidityDuration)
        )
        cache[cardId] = cacheModel
    }
    
    func get(cardId: String) -> (CardIdentificationResponse, PricingData)? {
        guard let cacheModel = cache[cardId], !cacheModel.isExpired else {
            remove(cardId: cardId)
            return nil
        }
        return (cacheModel.cardData, cacheModel.pricingData)
    }
    
    func remove(cardId: String) {
        cache.removeValue(forKey: cardId)
    }
    
    func clearExpiredCache() {
        let expiredKeys = cache.filter { $0.value.isExpired }.map { $0.key }
        expiredKeys.forEach { remove(cardId: $0) }
    }
    
    func clearAllCache() {
        cache.removeAll()
    }
}