//
//  EpisodesViewModel.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import Foundation
import Combine

protocol EpisodesViewModelProtocol {
    func transform( input: AnyPublisher<EpisodesViewModel.Input, Never>) -> AnyPublisher<EpisodesViewModel.Output, Never>
}

final class EpisodesViewModel: ObservableObject, EpisodesViewModelProtocol {

    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables: Set<AnyCancellable> = []
    private var networkService: NetworkService
    
    init(_ dependencies: IDependencies) {
        self.networkService = dependencies.networkService
    }
    
    enum Input {
        case viewDidLoad
        case paginationRequest(nextPageUrl: String?)
    }
    
    enum Output {
        case loadBaseCharacters(isLoading: Bool)
        case fetchBaseCharactersSucceed(characters: [Character], nextPageUrl: String?)
        
        case loadNextPage(isLoading: Bool)
        case fetchNextPageDidSucceed(characters: [Character], nextPageUrl: String?)
        
        case fetchDidFail(error: NetworkError)
    }
    
    func transform( input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { input in
            switch input {
            case .viewDidLoad:
                self.fetchBaseCharacters()
            case .paginationRequest(nextPageUrl: let url):
                guard let url = url else { return }
                self.fetchNextPage(with: url)
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    func fetchBaseCharacters() {
        output.send(.loadBaseCharacters(isLoading: true))
        
        let url = EndpointCases.getBaseData.url
        networkService.request(for: Result.self, url: url)
            .sink { error in
                switch error {
                case .finished:
                    self.output.send(.loadBaseCharacters(isLoading: false))
                case .failure(let error):
                    self.output.send(.fetchDidFail(error: error))
                }
            } receiveValue: { result in
                let characters = result.results
                let nextPage = result.info.next
                self.output.send(.fetchBaseCharactersSucceed(characters: characters, nextPageUrl: nextPage))
            }
            .store(in: &cancellables)

    }
    
    func fetchNextPage(with url: String) {
        output.send(.loadNextPage(isLoading: true))
        
        networkService.request(for: Result.self, url: url)
            .sink { error in
                switch error {
                case .finished:
                    self.output.send(.loadNextPage(isLoading: false))
                case .failure(let error):
                    self.output.send(.fetchDidFail(error: error))
                }
            } receiveValue: { result in
                let characters = result.results
                let nextPage = result.info.next
                self.output.send(.fetchNextPageDidSucceed(characters: characters, nextPageUrl: nextPage))
            }
            .store(in: &cancellables)

    }
    
    
}
