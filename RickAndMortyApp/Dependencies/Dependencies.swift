//
//  Dependencies.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 5.07.24.
//

import Foundation

protocol IDependencies {
    var moduleContainer: ModuleContainer {get}
    var networkService: NetworkService {get}
    var charactersDataSource: CharactersDataSource {get}
    var charactersRepository: CharactersRepository {get}
    var imageCacheService: IImageCacheService {get}
}

final class Dependencies: IDependencies {
    lazy var moduleContainer: ModuleContainer = ModuleContainer(self)
    lazy var imageCacheService: IImageCacheService = ImageCacheService()
    lazy var networkService: NetworkService = NetworkServiceImpl(self)
    lazy var charactersDataSource: CharactersDataSource = CharactersDataSourceImpl()
    lazy var charactersRepository: CharactersRepository = CharactersRepositoryImpl(self)
}

final class DependenciesMock: IDependencies {
    lazy var moduleContainer: ModuleContainer = ModuleContainer(self)
    lazy var networkService: NetworkService = NetworkServiceMock()
    lazy var charactersDataSource: CharactersDataSource = CharactersDataSourceImpl()
    lazy var charactersRepository: CharactersRepository = CharactersRepositoryImpl(self)
    lazy var imageCacheService: IImageCacheService = ImageCacheService()
}
    
