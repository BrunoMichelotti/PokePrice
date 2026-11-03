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

struct CardIdentificationResponse: Codable {
    let success: Bool
    let card: [String: Any]?
    let error: String?

    // Custom decoding to handle mixed types in card dict
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        error = try container.decodeIfPresent(String.self, forKey: .error)

        // Decode card as a generic JSON value
        if container.contains(.card) {
            let cardValue = try container.decode([String: AnyCodable].self, forKey: .card)
            card = cardValue.mapValues { $0.value }
        } else {
            card = nil
        }
    }

    enum CodingKeys: String, CodingKey {
        case success
        case card
        case error
    }
}

// Helper for decoding Any from JSON
struct AnyCodable: Codable {
    let value: Any

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
        } else if container.decodeNil() {
            value = Optional<Any>.none as Any
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable value cannot be decoded")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let intValue = value as? Int {
            try container.encode(intValue)
        } else if let doubleValue = value as? Double {
            try container.encode(doubleValue)
        } else if let stringValue = value as? String {
            try container.encode(stringValue)
        } else if let boolValue = value as? Bool {
            try container.encode(boolValue)
        } else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: container.codingPath, debugDescription: "AnyCodable value cannot be encoded"))
        }
    }
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
