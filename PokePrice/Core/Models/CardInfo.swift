//
//  CardInfo.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import Foundation

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
