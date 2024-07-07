//
//  MainTabBarCoordinator.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 7.07.24.
//

import Foundation
import UIKit

protocol MainTabBarCoordinatorProtocol: Coordinator {
    func start()
}

class MainTabBarCoordinator: MainTabBarCoordinatorProtocol {

    var rootViewController: UITabBarController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorType = .main
    var dependencies: IDependencies
    
    init(rootViewController: UITabBarController, dependencies: IDependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    func start() {
        let episodesVC = EpisodesAssemblyBuilder.configure(dependencies)
        let favouritesVC = FavouritesAssemblyBuilder.configure(dependencies)
        rootViewController.tabBar.items?[0].image = UIImage(named: ImageName.homeTabBarImage)
        rootViewController.tabBar.items?[1].image = UIImage(named: ImageName.favouritesTabBarImage)
        rootViewController.setViewControllers([episodesVC, favouritesVC], animated: true)
    }
    
}
