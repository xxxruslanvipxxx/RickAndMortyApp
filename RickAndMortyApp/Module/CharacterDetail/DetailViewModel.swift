//
//  DetailViewModel.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 7.08.24.
//

import Foundation
import Combine

protocol DetailViewModelProtocol {
    func transform(input: AnyPublisher<DetailViewModel.Input, Never>) -> AnyPublisher<DetailViewModel.Output, Never>
}

class DetailViewModel: ObservableObject, DetailViewModelProtocol {
    
    private var character: Character
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables: Set<AnyCancellable> = []
    private var networkService: NetworkService
    
    enum Input {
        case viewDidLoad
        case photoButtonPressed
    }
    
    enum Output {
        case fetchCharacterImage(isLoading: Bool)
        case updateCharacterInfo(character: Character)
        case updateImage(imageData: Data)
        
        case fetchDidFail(error: NetworkError)
    }
    
    init(_ dependencies: IDependencies, character: Character) {
        self.character = character
        self.networkService = dependencies.networkService
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { input in
            switch input {
            case .viewDidLoad:
                self.updateCharacterInfo()
                self.downloadImage()
            case .photoButtonPressed:
                /// WORK IN PROGRESS
                self.photoButtonPressed()
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func updateCharacterInfo() {
        output.send(.updateCharacterInfo(character: character))
    }
    
    private func downloadImage() {
        output.send(.fetchCharacterImage(isLoading: true))
        
        let imageURL = character.image
        
        networkService.loadImageData(from: imageURL)
            .sink { data in
                guard let data = data else {
                    return self.output.send(.fetchDidFail(error: .imageFetchError))
                }
                self.output.send(.fetchCharacterImage(isLoading: false))
                self.output.send(.updateImage(imageData: data))
            }
            .store(in: &cancellables)
    }
    
    private func photoButtonPressed() {
        print("photoButtonPressed")
    }
    
}
