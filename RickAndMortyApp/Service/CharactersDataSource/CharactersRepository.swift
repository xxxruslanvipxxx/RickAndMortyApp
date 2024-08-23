//
//  CharactersRepository.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 23.08.24.
//

import Foundation

protocol CharactersRepository {
    func getCharacters() async -> Result<[Character], CharacterError>
    func getCharacter(id: Int) async -> Result<Character?, CharacterError>
    func deleteCharacter(_ id: Int) async -> Result<Bool, CharacterError>
    func createCharacter(_ character: Character) async -> Result<Bool, CharacterError>
}
