//
//  FavouritesCoordinator.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

class FavouritesCoordinator {
    
    var childCoordinators = [Coordinator]()
    var rootViewController = UINavigationController()
    
    lazy var favouritesVC: FavouritesViewContorller = {
        let vc = FavouritesViewContorller()
        vc.tabBarItem.image = UIImage(systemName: "heart")
        return vc
    }()
    
    func start() {
        rootViewController.setViewControllers([favouritesVC], animated: false)
    }
    
}
