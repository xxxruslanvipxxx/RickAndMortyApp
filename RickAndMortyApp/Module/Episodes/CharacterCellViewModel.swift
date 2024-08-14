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
    
    var imageURL: String
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
    
    private var networkService: NetworkServiceImpl = .init()
    
    init(character: Character) {
        self.imageURL = character.image
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
                isFavourite ? print("\(self.name) in favorites") : print("\(self.name) not in favorites") 
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    func getImage() {
        networkService.loadImageData(from: imageURL)
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
    
}
