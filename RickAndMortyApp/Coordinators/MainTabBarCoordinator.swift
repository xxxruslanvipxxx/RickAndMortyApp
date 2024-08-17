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
    
    var finishDelegate: CoordinatorFinishDelegate?
    var rootViewController: UITabBarController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorType = .main
    var dependencies: IDependencies
    
    init(rootViewController: UITabBarController, dependencies: IDependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    func start() {
        let charactersCoordinator = CharactersCoordinator(dependencies: dependencies)
        charactersCoordinator.finishDelegate = self
        childCoordinators.append(charactersCoordinator)
        charactersCoordinator.start()
        
        let favoritesCoordinator = FavoritesCoordinator(dependencies: dependencies)
        favoritesCoordinator.finishDelegate = self
        childCoordinators.append(favoritesCoordinator)
        favoritesCoordinator.start()
        
        rootViewController.viewControllers = [charactersCoordinator.rootViewController, favoritesCoordinator.rootViewController]
    }
    
}

extension MainTabBarCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
    }
    
}
