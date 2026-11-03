//
//  APIModels.swift
//  PokePrice
//
//  Created by Bruno on 03/11/26.
//

import Foundation

// MARK: - Health Check

struct HealthResponse: Codable {
    let status: String
}

// MARK: - Card Identification

struct CardIdentificationRequest: Codable {
    let image: String
}

// Backend response for card identification
struct BackendCardIdentificationResponse: Codable {
    let success: Bool
    let card: CardInfo?
    let error: String?
}

// MARK: - Currency Conversion

struct CurrencyConversionRequest: Codable {
    let from_currency: String
    let to_currency: String
    let amount: Double
}

struct CurrencyConversionResponse: Codable {
    let success: Bool
    let result: Double?
    let error: String?
}
