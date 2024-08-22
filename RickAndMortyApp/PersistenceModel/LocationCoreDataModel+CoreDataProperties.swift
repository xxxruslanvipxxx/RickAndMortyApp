//
//  LocationCoreDataModel+CoreDataProperties.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 22.08.24.
//
//

import Foundation
import CoreData


extension LocationCoreDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationCoreDataModel> {
        return NSFetchRequest<LocationCoreDataModel>(entityName: "LocationCoreDataModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var character: NSSet?

}

// MARK: Generated accessors for character
extension LocationCoreDataModel {

    @objc(addCharacterObject:)
    @NSManaged public func addToCharacter(_ value: CharacterCoreDataModel)

    @objc(removeCharacterObject:)
    @NSManaged public func removeFromCharacter(_ value: CharacterCoreDataModel)

    @objc(addCharacter:)
    @NSManaged public func addToCharacter(_ values: NSSet)

    @objc(removeCharacter:)
    @NSManaged public func removeFromCharacter(_ values: NSSet)

}

extension LocationCoreDataModel : Identifiable {

}
