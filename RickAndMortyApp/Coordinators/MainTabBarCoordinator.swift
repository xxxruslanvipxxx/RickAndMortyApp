//
//  MainTabBarCoordinator.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 7.07.24.
//

import UIKit

protocol MainTabBarCoordinatorProtocol: Coordinator {
    func start()
}

class MainTabBarCoordinator: MainTabBarCoordinatorProtocol {
    
    var finishDelegate: (any CoordinatorFinishDelegate)?
    var rootViewController: UITabBarController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorType = .main
    var dependencies: IDependencies
    
    init(rootViewController: UITabBarController, dependencies: IDependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    func start() {
        let episodesCoordinator = CharactersCoordinator(dependencies: dependencies)
        episodesCoordinator.finishDelegate = self
        childCoordinators.append(episodesCoordinator)
        episodesCoordinator.start()
        
        let favoritesCoordinator = FavoritesCoordinator(dependencies: dependencies)
        favoritesCoordinator.finishDelegate = self
        childCoordinators.append(favoritesCoordinator)
        favoritesCoordinator.start()
        
        rootViewController.viewControllers = [episodesCoordinator.rootViewController, favoritesCoordinator.rootViewController]
    }
    
}

extension MainTabBarCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
    }
    
}
