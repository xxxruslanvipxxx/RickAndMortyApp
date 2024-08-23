//
//  CharactersDataSource.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 23.08.24.
//

import Foundation

protocol CharactersDataSource {
    func getAll() async throws -> [Character]
    func getById(_ id: Int) async throws -> Character?
    func delete(_ id: Int) async throws -> ()
    func create(character: Character) async throws -> ()
    func update(id: Int, character: Character) async throws -> ()
    func saveContext()
}
