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
        showFavorites()
    }
    
    func showFavorites() {
        let favoritesVC = FavoritesAssemblyBuilder.configure(dependencies)
        if let favoritesVC = favoritesVC as? FavoritesViewContorller {
            favoritesVC.didSendCompletionEvent = { [weak self] event in
                switch event {
                case .goToDetail(let character):
                    self?.finish()
                    self?.showDetail(for: character)
                }
            }
        }
        rootViewController.pushViewController(favoritesVC, animated: true)
    }
    
    func showDetail(for character: Character) {
        let detailCoordinator = DetailCoordinator(rootViewController: rootViewController, character: character, dependencies: dependencies)
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
    }
    
}
