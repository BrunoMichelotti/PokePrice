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

struct CardInfo: Codable {
    let id: String
    let name: String
    let setName: String
    let setCode: String
    let cardNumber: String
    let rarity: String
    let condition: String?
    let language: String?
    let imageUrl: String?
}