//
//  CoreDataManager.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 2.10.23.
//

import Foundation
import CoreData

/// Provides interaction with Core Data. Singleton.
final class CoreDataManager {

    /// Shared **PersistenceManager** instance.
    static let shared = CoreDataManager()
    private init() { }

    /// CoreData model name placeholder. Change for your model name
    let modelName = "PokeData"

    // Initializes once for given modelName
    @available(iOS, deprecated: 10.0)
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        do {
            return try NSPersistentStoreCoordinator.coordinator(for: modelName)
        } catch {
            print("CoreData: Unresolved error \(error)")
        }
        return nil
    }()

    @available(iOS, deprecated: 10.0)
    private lazy var managedObjectContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
    }()

    // iOS 10+
    @available(iOS 10.0, *)
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        if #available(iOS 10.0, *) {
            return persistentContainer.viewContext
        } else {
            return managedObjectContext
        }
    }

    enum SaveStatus: String {
        case saved      = "Context has been saved successfully"
        case rolledBack = "Changes have been rolled back"
        case noChanges  = "Context has no changes"
    }
}

extension CoreDataManager {
    /// Tries to save changes if there are some. Rolls back if an error has occurred.
    @discardableResult
    func save() -> SaveStatus {
        if context.hasChanges {
            do {
                try context.save()
                return .saved
            } catch {
                context.rollback()
                return .rolledBack
            }
        }
        return .noChanges
    }
    
    /// Retuns a possibly filtered array of [Entity] or empty array if error occured
    func fetch<Entity: NSManagedObject>(_ type: Entity.Type, using predicate: NSPredicate? = nil) -> [Entity] {
        do {
            return try fetchEntities(of: type, using: predicate)
        } catch {
            return emptyArray(of: type)
        }
    }

    /// Returns a possibly filtered array of [Entity] or throws
    func fetchEntities<Entity: NSManagedObject>(of type: Entity.Type, using predicate: NSPredicate? = nil) throws -> [Entity] {
        let request = fetchRequest(for: type)
        request.predicate = predicate
        return try context.fetch(request)
    }

    /// Returns fetchRequest for Entity
    private func fetchRequest<Entity: NSManagedObject>(for type: Entity.Type) -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: String(describing: type))
    }

    /// Returns an empty array of type [Entity]
    private func emptyArray<Entity: NSManagedObject>(of type: Entity.Type) -> [Entity] {
        print("Can't retrieve [\(type)] objects. Returning empty array.")
        return [Entity]()
    }

    /// Creates Entity in context for further manipulation and saving
    func create<Entity: NSManagedObject>(_ type: Entity.Type) -> Entity {
        if #available(iOS 10.0, *) {
            return Entity(context: context)
        } else {
            let description = NSEntityDescription.entity(forEntityName: String(describing: type), in: context)!
            return Entity(entity: description, insertInto: context)
        }
    }

    /// Tries to clear all records with given Entity type
    func clearEntities<Entity: NSManagedObject>(of type: Entity.Type) {
        let request = fetchRequest(for: type)
        request.includesPropertyValues = false

        do {
            if #available(iOS 9.0, *) {
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
                try context.execute(batchDeleteRequest)
            } else {
                try context.fetch(request).forEach { context.delete($0) }
            }
            print(save())
        } catch {
            assertionFailure("ERROR")
        }
    }
}

@available(iOS, deprecated: 10.0)
extension NSPersistentStoreCoordinator {

    public enum CoordinatorError: Error {
        case modelFileNotFound
        case modelCreationError
        case storePathNotFound
    }

    /// Returns coordinator for given model name or throws. SQLite store is added to it.
    static func coordinator(for name: String) throws -> NSPersistentStoreCoordinator? {
        guard let modelURL = Bundle.main.url(forResource: name, withExtension: "momd") else {
            throw CoordinatorError.modelFileNotFound
        }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            throw CoordinatorError.modelCreationError
        }
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            throw CoordinatorError.storePathNotFound
        }

        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        do {
            let url = documents.appendingPathComponent("\(name).sqlite")
            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            throw error
        }
        return coordinator
    }
}
