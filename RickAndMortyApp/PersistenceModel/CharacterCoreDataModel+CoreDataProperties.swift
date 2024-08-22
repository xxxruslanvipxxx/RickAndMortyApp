//
//  CharacterCoreDataModel+CoreDataProperties.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 22.08.24.
//
//

import Foundation
import CoreData


extension CharacterCoreDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterCoreDataModel> {
        return NSFetchRequest<CharacterCoreDataModel>(entityName: "CharacterCoreDataModel")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var status: String?
    @NSManaged public var species: String?
    @NSManaged public var type: String?
    @NSManaged public var gender: String?
    @NSManaged public var image: String?
    @NSManaged public var episode: String?
    @NSManaged public var url: String?
    @NSManaged public var created: String?
    @NSManaged public var origin: LocationCoreDataModel?

}

extension CharacterCoreDataModel : Identifiable {

}
