//
//  DetailViewModel.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 7.08.24.
//

import Foundation
import Combine

protocol DetailViewModelProtocol {
    
}

class DetailViewModel: ObservableObject, DetailViewModelProtocol {
    
    private var character: Result

    // later inject dependencies
    init(character: Result) {
        self.character = character
    }
    
}
