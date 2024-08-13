//
//  DetailCoordinator.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 8.08.24.
//

import UIKit

protocol DetailCoordinatorProtocol: Coordinator {
    func start()
}

class DetailCoordinator: DetailCoordinatorProtocol {
    
    var rootViewController: UINavigationController
    var type: CoordinatorType = .episodes
    var dependencies: IDependencies
    var childCoordinators = [Coordinator]()
    var character: Character
    
    init(rootViewController: UINavigationController = UINavigationController(), character: Character, dependencies: IDependencies) {
        self.rootViewController = rootViewController
        self.character = character
        self.dependencies = dependencies
    }
    
    func start() {
        let detailVC = DetailAssemblyBuilder.configure(dependencies, character: character, coordinator: self)
        rootViewController.pushViewController(detailVC, animated: true)
    }

}