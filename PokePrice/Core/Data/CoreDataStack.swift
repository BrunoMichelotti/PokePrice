//
//  CoreDataStack.swift
//  PokePrice
//
//  Created by Bruno on 10/09/26.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let model = CoreDataModelSetup.createManagedObjectModel()
        let container = NSPersistentContainer(name: "PokePriceDataModel", managedObjectModel: model)
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data store failed to load: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    func saveContext(_ context: NSManagedObjectContext? = nil) {
        let context = context ?? viewContext
        
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Failed to save Core Data context: \(error.localizedDescription)")
        }
    }
    
    func clearAllData() {
        let entities = persistentContainer.managedObjectModel.entities
        
        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try viewContext.execute(deleteRequest)
            } catch {
                print("Failed to clear entity \(entity.name!): \(error.localizedDescription)")
            }
        }
        
        saveContext()
    }
}
