//
//  FavoritesViewModel.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import Foundation
import Combine

protocol FavoritesViewModelProtocol {
    func transform(_ input: AnyPublisher<FavoritesViewModel.Input, Never>) -> AnyPublisher<FavoritesViewModel.Output, Never>
}

class FavoritesViewModel: ObservableObject, FavoritesViewModelProtocol {
    
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables: Set<AnyCancellable> = []
    
    init(_ dependencies: IDependencies) {
        
    }
    
    enum Input {
        case viewDidLoad
        case updateCells
    }
    
    enum Output {
        case fetchCompleted(isCompleted: Bool)
        case favoritesFetched(character: Character)
    }
    
    func transform(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output.send(.fetchCompleted(isCompleted: false))
        
        input.sink { [weak self] input in
            switch input {
            case .viewDidLoad:
                self?.fetchCharacters()
            case .updateCells:
                break
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchCharacters() {
        // fetch from CoreData
    }
    
}
