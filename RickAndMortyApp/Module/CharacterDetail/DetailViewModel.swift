//
//  DetailViewModel.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 7.08.24.
//

import Foundation
import Combine

protocol DetailViewModelProtocol {
    var character: Result { get }
    var characterPublished: Published<Result> { get }
    var characterPublisher: Published<Result>.Publisher { get }
}

class DetailViewModel: ObservableObject, DetailViewModelProtocol {
    
    @Published var character: Result
    var characterPublished: Published<Result> { _character }
    var characterPublisher: Published<Result>.Publisher { $character }
    
    // later inject dependencies
    init(character: Result) {
        self.character = character
    }
    
}
