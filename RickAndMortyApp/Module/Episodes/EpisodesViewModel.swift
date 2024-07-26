//
//  EpisodesViewModel.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import Foundation
import Combine

protocol EpisodesViewModelProtocol {
    var characters: [Result] { get }
    var publisher: Published<[Result]>.Publisher { get }
    
    func getAllCharacters()
}

final class EpisodesViewModel: ObservableObject, EpisodesViewModelProtocol {

    @Published var characters: [Result] = []
    var publisher: Published<[Result]>.Publisher { $characters }
    
    @Published var searchString: String = ""
    @Published var episode: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var networkService: NetworkService
    
    init(_ dependencies: IDependencies) {
        self.networkService = dependencies.networkService
        getAllCharacters()
    }
    
    func getAllCharacters() {
        let url = EndpointCases.getAllCharacters.url
        networkService.request(url: url)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure(let error):
                    self.characters = []
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] (char: Characters) in
                guard let self = self else { return }
                self.characters = char.results
            })
            .store(in: &cancellables)
    }
    
}
