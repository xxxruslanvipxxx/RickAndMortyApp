//
//  CharacterDataSourceImpl.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 23.08.24.
//

import Foundation
import CoreData

class CharactersDataSourceImpl: CharactersDataSource {
    
    // MARK: Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
//        if let url = persistentContainer.persistentStoreCoordinator.persistentStores.first?.url {
//            print(url)
//        }
        return persistentContainer.viewContext
    }()
    
    func create(character: Character) throws {
        let characterEntity = CharacterEntity(context: viewContext)
        characterEntity.convert(from: character)
        saveContext()
    }
    
    func getAll() throws -> [Character] {
        let request = CharacterEntity.fetchRequest()
        return try viewContext.fetch(request).map { characterEntity in
            Character(entity: characterEntity)
        }
    }
    
    func getById(_ id: Int) throws -> Character? {
        guard let characterEntity = try getEntityById(id) else { return nil }
        return Character(entity: characterEntity)
    }
    
    func update(id: Int, character: Character) throws {
        guard let characterEntity = try getEntityById(id) else { return }
        characterEntity.isFavorite = character.isFavorite
        saveContext()
    }
    
    func delete(_ id: Int) throws {
        guard let characterEntity = try getEntityById(id) else { return }
        viewContext.delete(characterEntity)
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            fatalError("Error: \(error.localizedDescription)")
        }
    }
    
    private func getEntityById(_ id: Int) throws -> CharacterEntity? {
        let request = CharacterEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %@", String(id))
        let characterEntity = try viewContext.fetch(request).first
        return characterEntity
    }
    
    // MARK: Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
