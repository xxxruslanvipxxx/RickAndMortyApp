//
//  CharacterCellViewModel.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 14.08.24.
//

import Foundation
import Combine

protocol CharacterCellViewModelProtocol {
    func transform(input: AnyPublisher<CharacterCellViewModel.Input, Never>) -> AnyPublisher<CharacterCellViewModel.Output, Never>
}

final class CharacterCellViewModel: CharacterCellViewModelProtocol {
    
    var character: Character
    var name: String
    var episodesURL: [String]
    
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    enum Input {
        case configureCell
        case favoriteButtonPressed(isFavorite: Bool)
    }
    
    enum Output {
        case configureImage(with: Data?)
        case configureName(with: String)
        case configureEpisode(with: String)
    }
    
    private var networkService: NetworkService
    private var charactersRepository: CharactersRepository
    
    init(character: Character, dependencies: IDependencies) {
        self.networkService = dependencies.networkService
        self.charactersRepository = dependencies.charactersRepository
        self.character = character
        self.name = character.name
        self.episodesURL = character.episode
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { input in
            switch input {
            case .configureCell:
                self.getImage()
                self.getEpisodeString()
                self.getName()
            case .favoriteButtonPressed(isFavorite: let isFavourite):
//                isFavourite ? print("\(self.name) in favorites") : print("\(self.name) not in favorites")
                if isFavourite {
                    print("\(self.name) in favorites")
                    self.addToFavorites()
                } else {
                    print("\(self.name) not in favorites")
                    self.removeFromFavorites()
                }
                
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    func getImage() {
        networkService.loadImageData(for: character)
            .sink { [weak self] data in
                self?.output.send(.configureImage(with: data))
            }
            .store(in: &cancellables)
    }
    
    func getName() {
        Just(name)
            .sink { name in
                self.output.send(.configureName(with: name))
            }
            .store(in: &cancellables)
    }
    
    func getEpisodeString() {
        guard let firstEpisode = episodesURL.first else { return }
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
    
}
