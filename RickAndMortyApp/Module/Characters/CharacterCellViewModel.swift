//
//  CharacterCellViewModel.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 14.08.24.
//

import Foundation
import Combine

//MARK: - CharacterCellViewModelProtocol
protocol CharacterCellViewModelProtocol {
    func transform(input: AnyPublisher<CharacterCellViewModel.Input, Never>) -> AnyPublisher<CharacterCellViewModel.Output, Never>
}

//MARK: - CharacterCellViewModel
final class CharacterCellViewModel: CharacterCellViewModelProtocol {
    
    //MARK: Private variables
    private var character: Character
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    private var networkService: NetworkService
    private var charactersRepository: CharactersRepository
    
    //MARK: Input
    enum Input {
        case configureCell
        case favoriteButtonPressed(isFavorite: Bool)
        case updateInFavoriteStatus
    }
    
    //MARK: Output
    enum Output {
        case configureImage(with: Data)
        case configureName(with: String)
        case configureEpisode(with: String)
        case configureIsFavorite(with: Bool)
    }
    
    //MARK: init
    init(character: Character, dependencies: IDependencies) {
        self.networkService = dependencies.networkService
        self.charactersRepository = dependencies.charactersRepository
        self.character = character
    }
    
    //MARK: func transform()
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            guard let self else { return }
            switch input {
            case .configureCell:
                self.getImage()
                self.getEpisodeString()
                self.getName()
                self.checkIfInFavorites()
            case .favoriteButtonPressed(isFavorite: let isFavourite):
                self.character.isFavorite = isFavourite
                if isFavourite {
                    self.addToFavorites()
                } else {
                    self.removeFromFavorites()
                }
            case .updateInFavoriteStatus:
                self.checkIfInFavorites()
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
}

//MARK: - Private methods
private extension CharacterCellViewModel {
    
    func getImage() {
        networkService.loadImageData(for: character)
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { [weak self] data in
                self?.output.send(.configureImage(with: data))
            }
            .store(in: &cancellables)
    }
    
    func getName() {
        Just(character.name)
            .sink { name in
                self.output.send(.configureName(with: name))
            }
            .store(in: &cancellables)
    }
    
    func getEpisodeString() {
        guard let firstEpisode = character.episode.first else { return }
        networkService.request(for: Episode.self, url: firstEpisode)
            .map { episode in
                episode.name + ConstantText.verticalBar + episode.episode
            }
            .sink { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print("Episode load error: \(error)")
                }
            } receiveValue: { [weak self] episodeString in
                self?.output.send(.configureEpisode(with: episodeString))
            }
            .store(in: &cancellables)
    }
    
    func addToFavorites() {
        Task {
            let result = await charactersRepository.createCharacter(character)
            switch result {
            case .success(_):
                print("Character created successfully")
            case .failure(let error):
                print("Creation of character failure: \(error.localizedDescription)")
            }
        }
    }
    
    func removeFromFavorites() {
        Task {
            let result = await charactersRepository.deleteCharacter(character.id)
            switch result {
            case .success(_):
                print("Character deleted successfully")
            case .failure(let error):
                print("Character delete failure: \(error.localizedDescription)")
            }
        }
    }
    
    func checkIfInFavorites() {
        Task {
            let result = await charactersRepository.getCharacter(id: character.id)
            switch result {
            case .success(let character):
                output.send(.configureIsFavorite(with: character?.isFavorite ?? false))
            case .failure(_):
                output.send(.configureIsFavorite(with: false))
            }
        }
    }
}
