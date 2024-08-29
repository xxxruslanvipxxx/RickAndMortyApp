//
//  Character.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 18.07.24.
//

import Foundation

// MARK: - Result
struct CharactersResult: Decodable {
    let info: Info
    let results: [Character]
}

// MARK: - Info
struct Info: Decodable {
    let count, pages: Int
    let next, prev: String?
}

// MARK: - Character
struct Character: Decodable, Identifiable {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, name, status, species, type, gender, origin, location, image, episode, url, created
    }
}

extension Character {
    init(entity: CharacterEntity) {
        self.id = Int(entity.id)
        self.name = entity.name!
        self.status = Status(rawValue: entity.status!) ?? Status.unknown
        self.species = entity.species!
        self.type = entity.type!
        self.gender = Gender(rawValue: entity.gender!) ?? Gender.unknown
        self.origin = Location(name: entity.originLocation!.name!, url: entity.originLocation!.url!)
        self.location = Location(name: entity.currentLocation!.name!, url: entity.currentLocation!.url!)
        self.image = entity.image!
        self.episode = [entity.episode!]
        self.url = entity.url!
        self.created = entity.created!
        self.isFavorite = entity.isFavorite
    }
}

//MARK: - Gender enum
enum Gender: String, Decodable {
    case female = "Female"
    case genderless = "Genderless"
    case male = "Male"
    case unknown = "unknown"
}

// MARK: - Location
struct Location: Decodable {
    let name: String
    let url: String
}

//MARK: - Status enum
enum Status: String, Decodable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
