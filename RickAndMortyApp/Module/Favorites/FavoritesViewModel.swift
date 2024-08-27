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
    private var charactersRepository: CharactersRepository
    
    init(_ dependencies: IDependencies) {
        self.charactersRepository = dependencies.charactersRepository
    }
    
    enum Input {
        case fetchFavorites
    }
    
    enum Output {
        case fetchCompleted(isCompleted: Bool)
        case favoritesFetched(characters: [Character])
    }
    
    func transform(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output.send(.fetchCompleted(isCompleted: false))
        
        input.sink { [weak self] input in
            switch input {
            case .fetchFavorites:
                guard let self else { return }
                Task {
                    let characters = await self.fetchCharacters()
                    self.output.send(.favoritesFetched(characters: characters))
                }
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchCharacters() async -> [Character] {
        
        let results = await charactersRepository.getCharacters()
        switch results {
        case .success(let characters):
            return characters
        case .failure(let error):
            print(error.localizedDescription)
            return []
        }
    }
    
}
