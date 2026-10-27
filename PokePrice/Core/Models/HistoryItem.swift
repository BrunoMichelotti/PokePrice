//
//  HistoryItem.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import Foundation

struct HistoryItem {
    let historyId: String
    let cardId: String
    let cardName: String
    let setName: String
    let setImageUrl: String?
    let brlPrice: Double?
    let usdPrice: Double?
    let eurPrice: Double?
    let scanDate: Date
    let imageData: Data?
}
