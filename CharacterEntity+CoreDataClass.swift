//
//  CharacterEntity+CoreDataClass.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 23.08.24.
//
//

import Foundation
import CoreData

@objc(CharacterEntity)
public class CharacterEntity: NSManagedObject {
    
    func convert(from character: Character) {
        guard let context = self.managedObjectContext else { return }
        self.id = Int64(character.id)
        self.name = character.name
        self.status = character.status.rawValue
        self.species = character.species
        self.type =  character.type
        self.gender =  character.gender.rawValue
        let originLocation = LocationEntity(context: context)
        originLocation.name = character.origin.name
        originLocation.url = character.origin.url
        self.originLocation = originLocation
        let currentLocation = LocationEntity(context: context)
        currentLocation.name = character.location.name
        currentLocation.url = character.location.url
        self.currentLocation = currentLocation
        self.image = character.image
        self.episode = character.episode[0]
        self.url = character.url
        self.created = character.created
        self.isFavorite = character.isFavorite
    }
    
}
