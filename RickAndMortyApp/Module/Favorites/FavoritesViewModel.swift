//
//  FavoritesViewModel.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import Foundation
import Combine

//MARK: - FavoritesViewModelProtocol
protocol FavoritesViewModelProtocol {
    func transform(_ input: AnyPublisher<FavoritesViewModel.Input, Never>) -> AnyPublisher<FavoritesViewModel.Output, Never>
}

//MARK: - FavoritesViewModel
class FavoritesViewModel: FavoritesViewModelProtocol {
    
    //MARK: Private variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables: Set<AnyCancellable> = []
    private var charactersRepository: CharactersRepository
    
    //MARK: init()
    init(_ dependencies: IDependencies) {
        self.charactersRepository = dependencies.charactersRepository
    }
    
    //MARK: Input
    enum Input {
        case fetchFavorites
    }
    
    //MARK: Output
    enum Output {
        case fetchCompleted(isCompleted: Bool)
        case favoritesFetched(characters: [Character])
    }
    
    //MARK: func transform()
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
    
}

//MARK: - Private methods
private extension FavoritesViewModel {
    func fetchCharacters() async -> [Character] {
        
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
