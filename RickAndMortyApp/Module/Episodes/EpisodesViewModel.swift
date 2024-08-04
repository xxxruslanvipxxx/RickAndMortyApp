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
    var charactersPublisher: Published<[Result]>.Publisher { get }
    
    var images: [Data?] { get }
    var imagesPublisher: Published<[Data?]>.Publisher { get }
    
    func getAllCharacters(by page: Int)
}

final class EpisodesViewModel: ObservableObject, EpisodesViewModelProtocol {

    @Published var characters: [Result] = []
    var charactersPublisher: Published<[Result]>.Publisher { $characters }
    
    @Published var images: [Data?] = []
    var imagesPublisher: Published<[Data?]>.Publisher { $images }
    
    @Published var searchString: String = ""
    @Published var episode: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var networkService: NetworkService
    
    init(_ dependencies: IDependencies) {
        self.networkService = dependencies.networkService
        binding()
        getAllCharacters()
    }
    
    func getImages(characters: [Result]) {
        
    }
    
    func getAllCharacters(by page: Int = 1) {
        let url = EndpointCases.getAllCharacters(page).url
        networkService.request(for: Characters.self, url: url)
            .sink(receiveCompletion: { value in
                switch value {
                case .failure(let error):
                    print("Error fetching characters: \(error.localizedDescription)")
                case .finished:
                    print("Characters fetched succesfully")
                }
            }, receiveValue: { [weak self] (char: Characters) in
                guard let self = self else { return }
                self.characters = char.results
            })
            .store(in: &cancellables)
    }
    
    private func binding() {
        $characters
            .flatMap { characters in
                self.networkService.loadImagesData(for: characters)
            }
            .assign(to: \.images, on: self)
            .store(in: &cancellables)
    }
    
}
