//
//  Network Service.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 13.07.24.
//

import Foundation
import Combine

protocol NetworkService {
    func request<T: Decodable>(for type: T.Type, url: String) -> AnyPublisher<T, NetworkError>
    func loadImageData(for character: Character) -> AnyPublisher<Data?, Never>
}

struct NetworkServiceImpl: NetworkService {
    
    private let imageCacheService: IImageCacheService
    
    init(_ dependencies: IDependencies) {
        self.imageCacheService = dependencies.imageCacheService
    }
    
    func request<T : Decodable>(for type: T.Type, url: String) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: url) else {
            return Fail(error: NetworkError.urlValidationError(url: url)).eraseToAnyPublisher()
        }
        
        let urlRequest = URLRequest(url: url)
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) -> Data in
                if let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) {
                    return data
                } else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                    throw NetworkError.serverError(statusCode: statusCode, reason: nil, retryAfter: nil)
                }
            }
            .decode(type: type, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if error is DecodingError {
                    return NetworkError.decodingError
                } else if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.unclassifiedError(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func loadImageData(for character: Character) -> AnyPublisher<Data?, Never> {
        let id = "\(character.id)"
        
        if let imageData = imageCacheService.getImage(forKey: id) {
            return Just(imageData).eraseToAnyPublisher()
        } else {
            guard let url = URL(string: character.image) else { return Just(nil).eraseToAnyPublisher() }
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { data, _ in
                    self.imageCacheService.setImage(data, forKey: id)
                    return data
                }
                .catch { _ in Just(nil) }
                .eraseToAnyPublisher()
        }
    }
    
}

final class NetworkServiceMock: NetworkService {
    
    var character: CharactersResult? = CharactersResult(info: Info(count: 1, pages: 1, next: nil, prev: nil), results: [])
    var episode: Episode? = Episode(id: 1, name: "Test", airDate: "", episode: "", characters: [], url: "", created: "")
    
    func request<T>(for type: T.Type, url: String) -> AnyPublisher<T, NetworkError> where T : Decodable {
        if type is CharactersResult.Type {
            guard let character = character as? T else { return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher() }
            return Just(character)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        } else if type is Episode.Type {
            guard let episode = episode as? T else { return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher() }
            return Just(episode)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        return Empty().eraseToAnyPublisher()
    }
    
    func loadImageData(for character: Character) -> AnyPublisher<Data?, Never> {
        guard let url = URL(string: character.image) else { return Just(nil).eraseToAnyPublisher() }
        let data = Data()
        print(url)
        return Just(data).eraseToAnyPublisher()
    }
    
}
