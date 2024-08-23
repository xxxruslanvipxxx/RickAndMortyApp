//
//  CharactersError.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 23.08.24.
//

import Foundation

enum CharacterError: Error {
    case dataSourceError, createError, deleteError, updateError, fetchError
}
