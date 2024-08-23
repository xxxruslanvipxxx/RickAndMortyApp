//
//  CharacterEntity+CoreDataProperties.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 23.08.24.
//
//

import Foundation
import CoreData


extension CharacterEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterEntity> {
        return NSFetchRequest<CharacterEntity>(entityName: "CharacterEntity")
    }

    @NSManaged public var created: String
    @NSManaged public var episode: String
    @NSManaged public var gender: String
    @NSManaged public var id: Int64
    @NSManaged public var image: String
    @NSManaged public var name: String
    @NSManaged public var species: String
    @NSManaged public var status: String
    @NSManaged public var type: String
    @NSManaged public var url: String
    @NSManaged public var isFavorite: Bool
    @NSManaged public var originLocation: LocationEntity
    @NSManaged public var currentLocation: LocationEntity

}

extension CharacterEntity : Identifiable {

}
