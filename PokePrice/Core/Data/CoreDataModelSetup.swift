//
//  CoreDataModelSetup.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import Foundation
import CoreData

class CoreDataModelSetup {
    
    static func createManagedObjectModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        
        // Create CachedCard entity
        let cachedCardEntity = NSEntityDescription()
        cachedCardEntity.name = "CachedCard"
        cachedCardEntity.managedObjectClassName = "CachedCard"
        
        // CachedCard attributes
        cachedCardEntity.properties = [
            createAttribute(name: "cardId", type: .stringAttributeType, isOptional: false),
            createAttribute(name: "name", type: .stringAttributeType, isOptional: false),
            createAttribute(name: "setName", type: .stringAttributeType, isOptional: false),
            createAttribute(name: "setCode", type: .stringAttributeType, isOptional: false),
            createAttribute(name: "cardNumber", type: .stringAttributeType, isOptional: false),
            createAttribute(name: "rarity", type: .stringAttributeType, isOptional: false),
            createAttribute(name: "condition", type: .stringAttributeType, isOptional: true),
            createAttribute(name: "language", type: .stringAttributeType, isOptional: true),
            createAttribute(name: "imageUrl", type: .stringAttributeType, isOptional: true),
            createAttribute(name: "createdAt", type: .dateAttributeType, isOptional: false),
            createAttribute(name: "expiresAt", type: .dateAttributeType, isOptional: false)
        ]
        
        // Create CachedPricing entity
        let cachedPricingEntity = NSEntityDescription()
        cachedPricingEntity.name = "CachedPricing"
        cachedPricingEntity.managedObjectClassName = "CachedPricing"
        
        // CachedPricing attributes
        cachedPricingEntity.properties = [
            createAttribute(name: "pricingId", type: .stringAttributeType, isOptional: false),
            createAttribute(name: "cardId", type: .stringAttributeType, isOptional: false),
            createAttribute(name: "usdMarketPrice", type: .doubleAttributeType, isOptional: false, defaultValue: 0.0),
            createAttribute(name: "usdLowPrice", type: .doubleAttributeType, isOptional: false, defaultValue: 0.0),
            createAttribute(name: "usdMidPrice", type: .doubleAttributeType, isOptional: false, defaultValue: 0.0),
            createAttribute(name: "usdHighPrice", type: .doubleAttributeType, isOptional: false, defaultValue: 0.0),
            createAttribute(name: "usdSource", type: .stringAttributeType, isOptional: false, defaultValue: ""),
            createAttribute(name: "eurTrendPrice", type: .doubleAttributeType, isOptional: false, defaultValue: 0.0),
            createAttribute(name: "eurAvgPrice", type: .doubleAttributeType, isOptional: false, defaultValue: 0.0),
            createAttribute(name: "eurLowPrice", type: .doubleAttributeType, isOptional: false, defaultValue: 0.0),
            createAttribute(name: "eurSource", type: .stringAttributeType, isOptional: false, defaultValue: ""),
            createAttribute(name: "brlMinPrice", type: .doubleAttributeType, isOptional: false, defaultValue: 0.0),
            createAttribute(name: "brlAvgPrice", type: .doubleAttributeType, isOptional: false, defaultValue: 0.0),
            createAttribute(name: "brlMaxPrice", type: .doubleAttributeType, isOptional: false, defaultValue: 0.0),
            createAttribute(name: "brlSource", type: .stringAttributeType, isOptional: false, defaultValue: ""),
            createAttribute(name: "lastUpdated", type: .dateAttributeType, isOptional: false),
            createAttribute(name: "currency", type: .stringAttributeType, isOptional: false),
            createAttribute(name: "expiresAt", type: .dateAttributeType, isOptional: false)
        ]
        
        // Create ScanHistory entity
        let scanHistoryEntity = NSEntityDescription()
        scanHistoryEntity.name = "ScanHistory"
        scanHistoryEntity.managedObjectClassName = "ScanHistory"
        
        // ScanHistory attributes
        scanHistoryEntity.properties = [
            createAttribute(name: "historyId", type: .stringAttributeType, isOptional: false),
            createAttribute(name: "cardId", type: .stringAttributeType, isOptional: false),
            createAttribute(name: "cardName", type: .stringAttributeType, isOptional: false),
            createAttribute(name: "setName", type: .stringAttributeType, isOptional: false),
            createAttribute(name: "setImageUrl", type: .stringAttributeType, isOptional: true),
            createAttribute(name: "brlPrice", type: .doubleAttributeType, isOptional: false, defaultValue: 0.0),
            createAttribute(name: "usdPrice", type: .doubleAttributeType, isOptional: false, defaultValue: 0.0),
            createAttribute(name: "eurPrice", type: .doubleAttributeType, isOptional: false, defaultValue: 0.0),
            createAttribute(name: "scanDate", type: .dateAttributeType, isOptional: false),
            createAttribute(name: "imageData", type: .binaryDataAttributeType, isOptional: true)
        ]
        
        // Add entities to model
        model.entities = [cachedCardEntity, cachedPricingEntity, scanHistoryEntity]
        
        return model
    }
    
    private static func createAttribute(name: String, type: NSAttributeType, isOptional: Bool, defaultValue: Any? = nil) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = type
        attribute.isOptional = isOptional
        if let defaultValue = defaultValue {
            attribute.defaultValue = defaultValue
        }
        return attribute
    }
}
