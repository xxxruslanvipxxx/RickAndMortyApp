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
    
    var images: [Int: Data?] { get }
    var imagesPublisher: Published<[Int: Data?]>.Publisher { get }
    
    var currentPage: Int {get set}
    
    func loadNextPage()
    func getAllCharacters(page: Int)
}

final class EpisodesViewModel: ObservableObject, EpisodesViewModelProtocol {

    @Published var characters: [Result] = []
    var charactersPublisher: Published<[Result]>.Publisher { $characters }
    
    @Published var images: [Int: Data?] = [:]
    var imagesPublisher: Published<[Int: Data?]>.Publisher { $images }
    
    @Published var searchString: String = ""
    @Published var episode: String?
    
    var currentPage: Int = 1
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var networkService: NetworkService
    
    init(_ dependencies: IDependencies) {
        self.networkService = dependencies.networkService
        binding()
       
    }
    
    public func getAllCharacters(page: Int = 1) {
        let url = EndpointCases.getAllCharacters(page).url
        networkService.request(for: Characters.self, url: url)
            .sink(receiveCompletion: { value in
                switch value {
                case .failure(let error):
                    print("Error fetching characters: \(error.localizedDescription)")
                case .finished:
                    print("Characters fetched succesfully")
                }
            }, receiveValue: { [weak self] (fetchedChar: Characters) in
                guard let self = self else { return }
                self.characters.append(contentsOf: fetchedChar.results)
            })
            .store(in: &cancellables)
    }
    
    public func loadNextPage() {
        currentPage += 1
        getAllCharacters(page: currentPage)
    }
    
    private func binding() {
        $characters
            .receive(on: RunLoop.main)
            .map { characters in
                // Фильтруем только новых персонажей, для которых еще нет загруженных изображений
                characters.filter { self.images[$0.id] == nil }
            }
            .filter { !$0.isEmpty } // Если нет новых персонажей, пропускаем загрузку
            .flatMap { newCharacters in
                self.networkService.loadImagesData(for: newCharacters)
                    .map { zip(newCharacters.map { $0.id }, $0) }
                    .map { Dictionary(uniqueKeysWithValues: $0) }
            }
            .map { newImages in
                self.images.merging(newImages) { (_, new) in new }
            }
            .assign(to: \.images, on: self)
            .store(in: &cancellables)
    }
    
}
