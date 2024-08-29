//
//  CharactersViewModel.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import Foundation
import Combine

//MARK: - CharactersViewModelProtocol
protocol CharactersViewModelProtocol {
    func transform( input: AnyPublisher<CharactersViewModel.Input, Never>) -> AnyPublisher<CharactersViewModel.Output, Never>
}

//MARK: - CharactersViewModel
final class CharactersViewModel: CharactersViewModelProtocol {

    //MARK: Private variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables: Set<AnyCancellable> = []
    private var networkService: NetworkService
    
    //MARK: init()
    init(_ dependencies: IDependencies) {
        self.networkService = dependencies.networkService
    }
    
    //MARK: Input
    enum Input {
        case viewDidLoad
        case paginationRequest(nextPageUrl: String?)
        case searchRequest(searchString: String)
    }
    
    //MARK: Output
    enum Output {
        case loadBaseCharacters(isLoading: Bool)
        case fetchBaseCharactersSucceed(characters: [Character], nextPageUrl: String?)
        
        case loadNextPage(isLoading: Bool)
        case fetchNextPageDidSucceed(characters: [Character], nextPageUrl: String?)
        
        case loadCharactersByName(isLoading: Bool)
        case fetchCharactersByNameSucceed(characters: [Character], nextPageUrl: String?)
        
        case fetchDidFail(error: NetworkError)
    }
    
    //MARK: func transform()
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            switch input {
            case .viewDidLoad:
                self?.fetchBaseCharacters()
            case .paginationRequest(nextPageUrl: let url):
                guard let url = url else { 
                    self?.output.send(.loadNextPage(isLoading: false))
                    return
                }
                self?.fetchNextPage(with: url)
            case .searchRequest(searchString: let searchString):
                guard searchString.count > 0 else {
                    self?.fetchBaseCharacters()
                    return
                }
                self?.fetchCharactersByName(name: searchString)
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
}

//MARK: - Private methods
private extension CharactersViewModel {
    
    func fetchBaseCharacters() {
        output.send(.loadBaseCharacters(isLoading: true))
        
        let url = EndpointCases.getBaseData.url
        networkService.request(for: CharactersResult.self, url: url)
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                switch result {
                case .finished:
                    self?.output.send(.loadBaseCharacters(isLoading: false))
                case .failure(let error):
                    self?.output.send(.fetchDidFail(error: error))
                }
            } receiveValue: { result in
                let characters = result.results
                let nextPage = result.info.next
                // paste mapper later
                self.output.send(.fetchBaseCharactersSucceed(characters: characters, nextPageUrl: nextPage))
            }
            .store(in: &cancellables)

    }
    
    func fetchCharactersByName(name: String) {
        let url = EndpointCases.getCharactersByName(name).url
        
        networkService.request(for: CharactersResult.self, url: url)
            .receive(on: RunLoop.main)
            .sink { error in
                switch error {
                case .finished:
                    self.output.send(.loadCharactersByName(isLoading: false))
                case .failure(let error):
                    self.output.send(.fetchDidFail(error: error))
                }
            } receiveValue: { [weak self] result in
                let characters = result.results
                let nextPage = result.info.next
                self?.output.send(.fetchCharactersByNameSucceed(characters: characters, nextPageUrl: nextPage))
            }
            .store(in: &cancellables)
    }
    
    func fetchNextPage(with url: String) {
        output.send(.loadNextPage(isLoading: true))
        
        networkService.request(for: CharactersResult.self, url: url)
            .receive(on: RunLoop.main)
            .sink { error in
                switch error {
                case .finished:
                    self.output.send(.loadNextPage(isLoading: false))
                case .failure(let error):
                    self.output.send(.fetchDidFail(error: error))
                }
            } receiveValue: { [weak self] result in
                let characters = result.results
                let nextPage = result.info.next
                self?.output.send(.fetchNextPageDidSucceed(characters: characters, nextPageUrl: nextPage))
            }
            .store(in: &cancellables)
    }
    
}
