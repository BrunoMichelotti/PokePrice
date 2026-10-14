//
//  PricingData.swift
//  PokePrice
//
//  Created by Bruno on 23/08/26.
//

import Foundation

struct PricingData: Codable {
    let cardId: String
    let usdPrice: USDPrice?
    let eurPrice: EURPrice?
    let brlPrice: BRLPrice?
    let lastUpdated: Date
    let currency: String
}

struct USDPrice: Codable {
    let marketPrice: Double?
    let lowPrice: Double?
    let midPrice: Double?
    let highPrice: Double?
    let source: String // TCGPlayer
    let currency: String
}

struct EURPrice: Codable {
    let trendPrice: Double?
    let avgPrice: Double?
    let lowPrice: Double?
    let source: String // CardMarket
    let currency: String
}

struct BRLPrice: Codable {
    let minPrice: Double?
    let avgPrice: Double?
    let maxPrice: Double?
    let source: String // LigaPokemon
    let currency: String
}

struct CurrencyConversion: Codable {
    let from: String
    let to: String
    let rate: Double
    let lastUpdated: Date
}