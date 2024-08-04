//
//  Character.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 18.07.24.
//

import Foundation

// MARK: - Character
struct Characters: Decodable {
    let info: Info
    let results: [Result]
}

// MARK: - Info
struct Info: Decodable {
    let count, pages: Int
    let next, prev: String?
}

// MARK: - Result
struct Result: Decodable, Identifiable {
    let id: Int
    let name: String
    let status: Status
    let species: Species
    let type: String
    let gender: Gender
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

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

enum Species: String, Decodable {
    case alien = "Alien"
    case human = "Human"
    case humanoid = "Humanoid"
    case mythologicalCreature = "Mythological Creature"
    case poopybutthole = "Poopybutthole"
    case unknown = "unknown"
}

enum Status: String, Decodable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
