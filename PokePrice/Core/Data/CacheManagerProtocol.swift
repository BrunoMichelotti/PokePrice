//
//  CacheManagerProtocol.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import Foundation

protocol CacheManagerProtocol {
    func set(cardId: String, cardData: CardIdentificationResponse, pricingData: PricingData)
    func get(cardId: String) -> (CardIdentificationResponse, PricingData)?
    func remove(cardId: String)
    func clearExpiredCache()
    func clearAllCache()
}

extension CacheManager: CacheManagerProtocol {}
