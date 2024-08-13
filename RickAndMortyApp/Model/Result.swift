//
//  Character.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 18.07.24.
//

import Foundation

// MARK: - Result
struct Result: Decodable {
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

enum Status: String, Decodable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
