//
//  LocationEntity+CoreDataProperties.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 24.08.24.
//
//

import Foundation
import CoreData


extension LocationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationEntity> {
        return NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var charactersOrigin: NSSet?
    @NSManaged public var charactersCurrent: NSSet?

}

// MARK: Generated accessors for charactersOrigin
extension LocationEntity {

    @objc(addCharactersOriginObject:)
    @NSManaged public func addToCharactersOrigin(_ value: CharacterEntity)

    @objc(removeCharactersOriginObject:)
    @NSManaged public func removeFromCharactersOrigin(_ value: CharacterEntity)

    @objc(addCharactersOrigin:)
    @NSManaged public func addToCharactersOrigin(_ values: NSSet)

    @objc(removeCharactersOrigin:)
    @NSManaged public func removeFromCharactersOrigin(_ values: NSSet)

}

// MARK: Generated accessors for charactersCurrent
extension LocationEntity {

    @objc(addCharactersCurrentObject:)
    @NSManaged public func addToCharactersCurrent(_ value: CharacterEntity)

    @objc(removeCharactersCurrentObject:)
    @NSManaged public func removeFromCharactersCurrent(_ value: CharacterEntity)

    @objc(addCharactersCurrent:)
    @NSManaged public func addToCharactersCurrent(_ values: NSSet)

    @objc(removeCharactersCurrent:)
    @NSManaged public func removeFromCharactersCurrent(_ values: NSSet)

}

extension LocationEntity : Identifiable {

}
