//
//  ScanHistory.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import Foundation
import CoreData

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
    
    // Convenience initializer for creating from HistoryItem
    convenience init?(context: NSManagedObjectContext, historyItem: HistoryItem) {
        guard let entity = NSEntityDescription.entity(forEntityName: "ScanHistory", in: context) else {
            return nil
        }
        
        self.init(entity: entity, insertInto: context)
        
        self.historyId = historyItem.historyId
        self.cardId = historyItem.cardId
        self.cardName = historyItem.cardName
        self.setName = historyItem.setName
        self.setImageUrl = historyItem.setImageUrl
        self.brlPrice = historyItem.brlPrice ?? 0.0
        self.usdPrice = historyItem.usdPrice ?? 0.0
        self.eurPrice = historyItem.eurPrice ?? 0.0
        self.scanDate = historyItem.scanDate
        self.imageData = historyItem.imageData
    }
}
