//
//  CharacterRepositoryImpl.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 23.08.24.
//

import Foundation

class CharacterRepositoryImpl: CharactersRepository {
    
    var dataSource: CharactersDataSource
    
    init(dataSource: CharactersDataSource) {
        self.dataSource = dataSource
    }
    
    func getCharacters() async -> Result<[Character], CharacterError> {
        do {
            let characters =  try await dataSource.getAll()
            return .success(characters)
        } catch {
            return .failure(.fetchError)
        }
    }
    
    func getCharacter(id: Int) async -> Result<Character?, CharacterError> {
        do {
            let character = try await dataSource.getById(id)
            return .success(character)
        } catch {
            return .failure(.fetchError)
        }
    }
    
    func deleteCharacter(_ id: Int) async -> Result<Bool, CharacterError> {
        do {
            try await dataSource.delete(id)
            return .success(true)
        } catch {
            return .failure(.deleteError)
        }
    }
    
    func createCharacter(_ character: Character) async -> Result<Bool, CharacterError> {
        do {
            try await dataSource.create(character: character)
            return .success(true)
        } catch {
            return .failure(.createError)
        }
    }
    
}
