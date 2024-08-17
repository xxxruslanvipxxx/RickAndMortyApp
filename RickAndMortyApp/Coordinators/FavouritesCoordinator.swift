//
//  FavouritesCoordinator.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

protocol FavoritesCoordinatorProtocol: Coordinator {
    func start()
}

class FavoritesCoordinator: FavoritesCoordinatorProtocol {
    
    var finishDelegate: CoordinatorFinishDelegate?
    var rootViewController = UINavigationController()
    var type: CoordinatorType = .favorites
    var dependencies: IDependencies
    var childCoordinators = [Coordinator]()
    
    init(rootViewController: UINavigationController = UINavigationController(), dependencies: IDependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    func start() {
        let favoritesVC = FavoritesAssemblyBuilder.configure(dependencies)
        rootViewController.pushViewController(favoritesVC, animated: false)
    }
    
}
