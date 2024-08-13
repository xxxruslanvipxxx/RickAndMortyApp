//
//  DetailViewModel.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 7.08.24.
//

import Foundation
import Combine

protocol DetailViewModelProtocol {
    var character: Character { get }
    var characterPublished: Published<Character> { get }
    var characterPublisher: Published<Character>.Publisher { get }
}

class DetailViewModel: ObservableObject, DetailViewModelProtocol {
    
    @Published var character: Character
    var characterPublished: Published<Character> { _character }
    var characterPublisher: Published<Character>.Publisher { $character }
    
    // later inject dependencies
    init(character: Character) {
        self.character = character
    }
    
}
