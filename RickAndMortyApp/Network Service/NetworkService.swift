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
}

struct NetworkServiceImpl: NetworkService {

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
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
}
