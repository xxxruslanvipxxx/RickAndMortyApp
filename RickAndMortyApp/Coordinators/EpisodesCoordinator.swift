//
//  EpisodesCoordinator.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

protocol EpisodesCoordinatorProtocol: Coordinator {
    func start()
}

class EpisodesCoordinator: EpisodesCoordinatorProtocol {
    
    var rootViewController = UINavigationController()
    var type: CoordinatorType = .episodes
    var dependencies: IDependencies
    var childCoordinators = [Coordinator]()
    
    init(rootViewController: UINavigationController = UINavigationController(), dependencies: IDependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    func start() {
        let episodesVC = EpisodesAssemblyBuilder.configure(dependencies)
        rootViewController.pushViewController(episodesVC, animated: false)
    }
    
}
