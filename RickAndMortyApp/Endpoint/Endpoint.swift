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
        case .getBaseData:
            return "\(API.baseURL)"
        case .getCharactersByName(_):
            return "\(API.baseURL)"
        }
    }
    
    var path: String{
        switch self {
        case .getBaseData:
            return "\(API.characterPath)"
        case .getCharactersByName(let string):
            return API.characterPath + API.nameFilterPath + string
        }
    }
    
    var headers: [String : Any]? {
        switch self {
        case .getBaseData:
            return [:]
        case .getCharactersByName(_):
            return [:]
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .getBaseData:
            return [:]
        case .getCharactersByName(_):
            return [:]
        }
    }
    
    case getBaseData
    case getCharactersByName(String)
}
