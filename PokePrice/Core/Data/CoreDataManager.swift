//
//  CoreDataManager.swift
//  PokePrice
//
//  Created by Bruno on 23/08/26.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private let coreDataStack: CoreDataStack
    
    private init() {
        self.coreDataStack = CoreDataStack.shared
    }
    
    var context: NSManagedObjectContext {
        return coreDataStack.viewContext
    }
    
    func save() {
        coreDataStack.saveContext()
    }
    
    // MARK: - Scan History Operations (Legacy API - Deprecated)
    
    func saveScanHistory(cardId: String, cardName: String, setName: String, setImageUrl: String?, brlPrice: Double, usdPrice: Double, eurPrice: Double, imageData: Data?) {
        let historyItem = HistoryItem(
            historyId: UUID().uuidString,
            cardId: cardId,
            cardName: cardName,
            setName: setName,
            setImageUrl: setImageUrl,
            brlPrice: brlPrice > 0 ? brlPrice : nil,
            usdPrice: usdPrice > 0 ? usdPrice : nil,
            eurPrice: eurPrice > 0 ? eurPrice : nil,
            scanDate: Date(),
            imageData: imageData
        )
        
        coreDataStack.backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            let context = self.coreDataStack.backgroundContext
            let scanHistory = ScanHistory.from(historyItem: historyItem)
            context.insert(scanHistory)
            try? context.save()
        }
    }
    
    func fetchScanHistory() -> [Any] {
        // Legacy method - returns empty for now
        // Use CoreDataRepository.getHistory() instead
        return []
    }
    
    func deleteScanHistory(_ scanHistory: Any) {
        // Legacy method - no-op
        // Use CoreDataRepository.deleteHistoryItem() instead
    }
    
    func clearScanHistory() {
        coreDataStack.backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            let context = self.coreDataStack.backgroundContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ScanHistory")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try? context.execute(deleteRequest)
            try? context.save()
        }
    }
}