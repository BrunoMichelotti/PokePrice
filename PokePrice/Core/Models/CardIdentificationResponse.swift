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
}