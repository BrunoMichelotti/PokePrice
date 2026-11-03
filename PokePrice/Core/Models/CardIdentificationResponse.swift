//
//  CardIdentificationResponse.swift
//  PokePrice
//
//  Created by Bruno on 23/08/26.
//

import Foundation

struct CardIdentificationResponse: Codable {
    let success: Bool
    let card: CardInfo?
    let error: String?
    let confidence: Double?
    let imageUrl: String?

    // Custom init to handle missing fields from backend
    init(success: Bool, card: CardInfo?, error: String?, confidence: Double? = nil, imageUrl: String? = nil) {
        self.success = success
        self.card = card
        self.error = error
        self.confidence = confidence
        self.imageUrl = imageUrl
    }
}