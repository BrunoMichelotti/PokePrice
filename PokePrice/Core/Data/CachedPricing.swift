//
//  CachedPricing.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import Foundation
import CoreData

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
        return expiresAt < Date()
    }

    convenience init?(context: NSManagedObjectContext, pricingData: PricingData, expiryInterval: TimeInterval) {
        guard let entity = NSEntityDescription.entity(forEntityName: "CachedPricing", in: context) else {
            return nil
        }

        self.init(entity: entity, insertInto: context)

        self.pricingId = UUID().uuidString
        self.cardId = pricingData.cardId
        self.usdMarketPrice = pricingData.usdPrice?.marketPrice ?? 0
        self.usdLowPrice = pricingData.usdPrice?.lowPrice ?? 0
        self.usdMidPrice = pricingData.usdPrice?.midPrice ?? 0
        self.usdHighPrice = pricingData.usdPrice?.highPrice ?? 0
        self.usdSource = pricingData.usdPrice?.source ?? ""
        self.eurTrendPrice = pricingData.eurPrice?.trendPrice ?? 0
        self.eurAvgPrice = pricingData.eurPrice?.avgPrice ?? 0
        self.eurLowPrice = pricingData.eurPrice?.lowPrice ?? 0
        self.eurSource = pricingData.eurPrice?.source ?? ""
        self.brlMinPrice = pricingData.brlPrice?.minPrice ?? 0
        self.brlAvgPrice = pricingData.brlPrice?.avgPrice ?? 0
        self.brlMaxPrice = pricingData.brlPrice?.maxPrice ?? 0
        self.brlSource = pricingData.brlPrice?.source ?? ""
        self.lastUpdated = pricingData.lastUpdated
        self.currency = pricingData.currency
        self.expiresAt = Date().addingTimeInterval(expiryInterval)
    }

    func toPricingData() -> PricingData {
        return PricingData(
            cardId: cardId,
            usdPrice: USDPrice(
                marketPrice: usdMarketPrice,
                lowPrice: usdLowPrice,
                midPrice: usdMidPrice,
                highPrice: usdHighPrice,
                source: usdSource,
                currency: "USD"
            ),
            eurPrice: EURPrice(
                trendPrice: eurTrendPrice,
                avgPrice: eurAvgPrice,
                lowPrice: eurLowPrice,
                source: eurSource,
                currency: "EUR"
            ),
            brlPrice: BRLPrice(
                minPrice: brlMinPrice,
                avgPrice: brlAvgPrice,
                maxPrice: brlMaxPrice,
                source: brlSource,
                currency: "BRL"
            ),
            lastUpdated: lastUpdated,
            currency: currency
        )
    }
}
