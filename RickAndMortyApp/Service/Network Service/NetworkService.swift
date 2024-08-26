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
    
    private let cache: NSCache<NSString, NSData> = .init()
    
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
    
    // Функция для загрузки данных изображения по URL
    func loadImageData(for character: Character) -> AnyPublisher<Data?, Never> {
        let id = NSString(string: "\(character.id)")
        
        if let imageData = cache.object(forKey: id) as? Data {
            return Just(imageData).eraseToAnyPublisher()
        } else {
            guard let url = URL(string: character.image) else { return Just(nil).eraseToAnyPublisher() }
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { data, _ in
                    self.cache.setObject(NSData(data: data), forKey: id)
                    return data
                }
                .catch { _ in Just(nil) }
                .eraseToAnyPublisher()
        }
    }
    
}
