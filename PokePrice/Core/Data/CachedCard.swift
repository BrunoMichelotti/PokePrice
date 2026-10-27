//
//  CachedCard.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import Foundation
import CoreData

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
        return expiresAt < Date()
    }

    convenience init?(context: NSManagedObjectContext, cardInfo: CardInfo, expiryInterval: TimeInterval) {
        guard let entity = NSEntityDescription.entity(forEntityName: "CachedCard", in: context) else {
            return nil
        }

        self.init(entity: entity, insertInto: context)

        self.cardId = cardInfo.id
        self.name = cardInfo.name
        self.setName = cardInfo.setName
        self.setCode = cardInfo.setCode
        self.cardNumber = cardInfo.cardNumber
        self.rarity = cardInfo.rarity
        self.condition = cardInfo.condition
        self.language = cardInfo.language
        self.imageUrl = cardInfo.imageUrl
        self.createdAt = Date()
        self.expiresAt = Date().addingTimeInterval(expiryInterval)
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
}
