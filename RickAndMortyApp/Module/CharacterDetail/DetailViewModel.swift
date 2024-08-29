//
//  DetailViewModel.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 7.08.24.
//

import Foundation
import Combine

//MARK: - DetailViewModelProtocol
protocol DetailViewModelProtocol {
    func transform(input: AnyPublisher<DetailViewModel.Input, Never>) -> AnyPublisher<DetailViewModel.Output, Never>
}

//MARK: - DetailViewModel
class DetailViewModel: DetailViewModelProtocol {
    
    //MARK: Private variables
    private var character: Character
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables: Set<AnyCancellable> = []
    private var networkService: NetworkService
    
    //MARK: PhotoSourceType
    enum PhotoSourceType {
        case camera
        case photoLibrary
    }
    
    //MARK: Input
    enum Input {
        case viewDidLoad
        case changePhoto(sourceType: PhotoSourceType)
    }
    
    //MARK: Output
    enum Output {
        case fetchCharacterImage(isLoading: Bool)
        case updateCharacterInfo(character: Character)
        case updateImage(imageData: Data)
        case showCamera
        case showPhotoLibrary
        case fetchDidFail(error: NetworkError)
    }
    
    //MARK: init()
    init(_ dependencies: IDependencies, character: Character) {
        self.character = character
        self.networkService = dependencies.networkService
    }
    
    //MARK: func transform()
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { input in
            switch input {
            case .viewDidLoad:
                self.updateCharacterInfo()
                self.downloadImage()
            case .changePhoto(sourceType: let type):
                switch type {
                case .camera:
                    self.changePhotoWithCamera()
                case .photoLibrary:
                    self.changePhotoWithPhotoLibrary()
                }
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
}

//MARK: - Private methods
private extension DetailViewModel {
    func updateCharacterInfo() {
        output.send(.updateCharacterInfo(character: character))
    }
    
    func downloadImage() {
        output.send(.fetchCharacterImage(isLoading: true))
        
        networkService.loadImageData(for: character)
            .sink { data in
                guard let data = data else {
                    return self.output.send(.fetchDidFail(error: .imageFetchError))
                }
                self.output.send(.fetchCharacterImage(isLoading: false))
                self.output.send(.updateImage(imageData: data))
            }
            .store(in: &cancellables)
    }
    
    func changePhotoWithCamera() {
        output.send(.showCamera)
    }
    
    func changePhotoWithPhotoLibrary() {
        output.send(.showPhotoLibrary)
    }
}
