//
//  ManagedObjectModels.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import Foundation
import CoreData

// MARK: - CachedCard
@objc(CachedCard)
public class CachedCard: NSManagedObject {
    
    @NSManaged public var cardId: String
    @NSManaged public var name: String
    @NSManaged public var setName: String
    @NSManaged public var setCode: String
    @NSManaged public var cardNumber: String
    @NSManaged public var rarity: String
    @NSManaged public var condition: String?
    @NSManaged public var language: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var createdAt: Date
    @NSManaged public var expiresAt: Date
    
    var isExpired: Bool {
        return Date() > expiresAt
    }
    
    func toCardInfo() -> CardInfo {
        return CardInfo(
            id: cardId,
            name: name,
            setName: setName,
            setCode: setCode,
            cardNumber: cardNumber,
            rarity: rarity,
            condition: condition,
            language: language,
            imageUrl: imageUrl
        )
    }
    
    static func from(cardInfo: CardInfo, expiryInterval: TimeInterval = 24 * 60 * 60) -> CachedCard {
        let cachedCard = CachedCard()
        cachedCard.cardId = cardInfo.id
        cachedCard.name = cardInfo.name
        cachedCard.setName = cardInfo.setName
        cachedCard.setCode = cardInfo.setCode
        cachedCard.cardNumber = cardInfo.cardNumber
        cachedCard.rarity = cardInfo.rarity
        cachedCard.condition = cardInfo.condition
        cachedCard.language = cardInfo.language
        cachedCard.imageUrl = cardInfo.imageUrl
        cachedCard.createdAt = Date()
        cachedCard.expiresAt = Date().addingTimeInterval(expiryInterval)
        return cachedCard
    }
}

// MARK: - CachedPricing
@objc(CachedPricing)
public class CachedPricing: NSManagedObject {
    
    @NSManaged public var pricingId: String
    @NSManaged public var cardId: String
    @NSManaged public var usdMarketPrice: Double
    @NSManaged public var usdLowPrice: Double
    @NSManaged public var usdMidPrice: Double
    @NSManaged public var usdHighPrice: Double
    @NSManaged public var usdSource: String
    @NSManaged public var eurTrendPrice: Double
    @NSManaged public var eurAvgPrice: Double
    @NSManaged public var eurLowPrice: Double
    @NSManaged public var eurSource: String
    @NSManaged public var brlMinPrice: Double
    @NSManaged public var brlAvgPrice: Double
    @NSManaged public var brlMaxPrice: Double
    @NSManaged public var brlSource: String
    @NSManaged public var lastUpdated: Date
    @NSManaged public var currency: String
    @NSManaged public var expiresAt: Date
    
    var isExpired: Bool {
        return Date() > expiresAt
    }
    
    func toPricingData() -> PricingData {
        return PricingData(
            cardId: cardId,
            usdPrice: USDPrice(
                marketPrice: usdMarketPrice > 0 ? usdMarketPrice : nil,
                lowPrice: usdLowPrice > 0 ? usdLowPrice : nil,
                midPrice: usdMidPrice > 0 ? usdMidPrice : nil,
                highPrice: usdHighPrice > 0 ? usdHighPrice : nil,
                source: usdSource,
                currency: "USD"
            ),
            eurPrice: EURPrice(
                trendPrice: eurTrendPrice > 0 ? eurTrendPrice : nil,
                avgPrice: eurAvgPrice > 0 ? eurAvgPrice : nil,
                lowPrice: eurLowPrice > 0 ? eurLowPrice : nil,
                source: eurSource,
                currency: "EUR"
            ),
            brlPrice: BRLPrice(
                minPrice: brlMinPrice > 0 ? brlMinPrice : nil,
                avgPrice: brlAvgPrice > 0 ? brlAvgPrice : nil,
                maxPrice: brlMaxPrice > 0 ? brlMaxPrice : nil,
                source: brlSource,
                currency: "BRL"
            ),
            lastUpdated: lastUpdated,
            currency: currency
        )
    }
    
    static func from(pricingData: PricingData, expiryInterval: TimeInterval = 24 * 60 * 60) -> CachedPricing {
        let cachedPricing = CachedPricing()
        cachedPricing.pricingId = UUID().uuidString
        cachedPricing.cardId = pricingData.cardId
        cachedPricing.usdMarketPrice = pricingData.usdPrice?.marketPrice ?? 0
        cachedPricing.usdLowPrice = pricingData.usdPrice?.lowPrice ?? 0
        cachedPricing.usdMidPrice = pricingData.usdPrice?.midPrice ?? 0
        cachedPricing.usdHighPrice = pricingData.usdPrice?.highPrice ?? 0
        cachedPricing.usdSource = pricingData.usdPrice?.source ?? ""
        cachedPricing.eurTrendPrice = pricingData.eurPrice?.trendPrice ?? 0
        cachedPricing.eurAvgPrice = pricingData.eurPrice?.avgPrice ?? 0
        cachedPricing.eurLowPrice = pricingData.eurPrice?.lowPrice ?? 0
        cachedPricing.eurSource = pricingData.eurPrice?.source ?? ""
        cachedPricing.brlMinPrice = pricingData.brlPrice?.minPrice ?? 0
        cachedPricing.brlAvgPrice = pricingData.brlPrice?.avgPrice ?? 0
        cachedPricing.brlMaxPrice = pricingData.brlPrice?.maxPrice ?? 0
        cachedPricing.brlSource = pricingData.brlPrice?.source ?? ""
        cachedPricing.lastUpdated = pricingData.lastUpdated
        cachedPricing.currency = pricingData.currency
        cachedPricing.expiresAt = Date().addingTimeInterval(expiryInterval)
        return cachedPricing
    }
}

// MARK: - ScanHistory
@objc(ScanHistory)
public class ScanHistory: NSManagedObject {
    
    @NSManaged public var historyId: String
    @NSManaged public var cardId: String
    @NSManaged public var cardName: String
    @NSManaged public var setName: String
    @NSManaged public var setImageUrl: String?
    @NSManaged public var brlPrice: Double
    @NSManaged public var usdPrice: Double
    @NSManaged public var eurPrice: Double
    @NSManaged public var scanDate: Date
    @NSManaged public var imageData: Data?
    
    func toHistoryItem() -> HistoryItem {
        return HistoryItem(
            historyId: historyId,
            cardId: cardId,
            cardName: cardName,
            setName: setName,
            setImageUrl: setImageUrl,
            brlPrice: brlPrice > 0 ? brlPrice : nil,
            usdPrice: usdPrice > 0 ? usdPrice : nil,
            eurPrice: eurPrice > 0 ? eurPrice : nil,
            scanDate: scanDate,
            imageData: imageData
        )
    }
    
    static func from(historyItem: HistoryItem) -> ScanHistory {
        let scanHistory = ScanHistory()
        scanHistory.historyId = historyItem.historyId
        scanHistory.cardId = historyItem.cardId
        scanHistory.cardName = historyItem.cardName
        scanHistory.setName = historyItem.setName
        scanHistory.setImageUrl = historyItem.setImageUrl
        scanHistory.brlPrice = historyItem.brlPrice ?? 0
        scanHistory.usdPrice = historyItem.usdPrice ?? 0
        scanHistory.eurPrice = historyItem.eurPrice ?? 0
        scanHistory.scanDate = historyItem.scanDate
        scanHistory.imageData = historyItem.imageData
        return scanHistory
    }
}

// MARK: - HistoryItem Model
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
