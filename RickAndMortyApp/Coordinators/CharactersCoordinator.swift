//
//  CharactersCoordinator.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

protocol CharactersCoordinatorProtocol: Coordinator {
    func start()
    func showDetail(for character: Character)
}

class CharactersCoordinator: CharactersCoordinatorProtocol {
    
    var finishDelegate: CoordinatorFinishDelegate?
    var rootViewController = UINavigationController()
    var type: CoordinatorType = .characters
    var dependencies: IDependencies
    var childCoordinators = [Coordinator]()
    
    init(rootViewController: UINavigationController = UINavigationController(), dependencies: IDependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    func start() {
        let episodesVC = CharactersAssemblyBuilder.configure(dependencies, coordinator: self)
        rootViewController.pushViewController(episodesVC, animated: false)
    }
    
    func showDetail(for character: Character) {
        let detailCoordinator = DetailCoordinator(rootViewController: rootViewController, character: character, dependencies: dependencies)
        detailCoordinator.start()
    }
    
}
