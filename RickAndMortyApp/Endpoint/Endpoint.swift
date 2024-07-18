//
//  Endpoint.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 13.07.24.
//

import Foundation

protocol Endpoint {
    var baseURL: String {get}
    var path: String {get}
    var headers: [String: Any]? { get }
    var body: [String: Any]? { get }
}

extension Endpoint {
    var url: String {
        baseURL + path
    }
}

enum EndpointCases: Endpoint {
    
    var baseURL: String {
        switch self {
        case .getAllCharacters:
            return "\(API.baseURL)"
        }
    }
    
    var path: String{
        switch self {
        case .getAllCharacters:
            return "\(API.characterPath)"
        }
    }
    
    var headers: [String : Any]? {
        switch self {
        case .getAllCharacters:
            return [:]
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .getAllCharacters:
            return [:]
        }
    }
    
    case getAllCharacters
}
