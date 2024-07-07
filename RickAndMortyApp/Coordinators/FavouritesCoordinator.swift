//
//  FavouritesCoordinator.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

protocol FavouritesCoordinatorProtocol: Coordinator {
    func start()
}

class FavouritesCoordinator: FavouritesCoordinatorProtocol {
    
    var rootViewController = UINavigationController()
    var type: CoordinatorType = .favourites
    var dependencies: IDependencies
    var childCoordinators = [Coordinator]()
    
    init(rootViewController: UINavigationController = UINavigationController(), dependencies: IDependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    func start() {
        let favouritesVC = FavouritesAssemblyBuilder.configure(dependencies)
        rootViewController.pushViewController(favouritesVC, animated: false)
    }
    
}
