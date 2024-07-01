//
//  LaunchCoordinator.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var rootViewController = UITabBarController()
    
    func start() {
        
        let episodesCoordinator = EpisodesCoordinator()
        episodesCoordinator.start()
        
        let favouritesCoordinator = FavouritesCoordinator()
        favouritesCoordinator.start()
        
        childCoordinators = [episodesCoordinator, favouritesCoordinator]
        
        rootViewController.setViewControllers([episodesCoordinator.rootViewController, favouritesCoordinator.rootViewController], animated: true)
        rootViewController.tabBar.backgroundColor = UIColor(named: "customBackgroundColor")
        rootViewController.tabBar.layer.shadowOffset = CGSize(width: 0, height: -3)
        rootViewController.tabBar.layer.shadowRadius = 5
        rootViewController.tabBar.layer.shadowOpacity = 0.3
        rootViewController.tabBar.layer.shadowColor = UIColor.black.cgColor
    }
    
    private func setupTabBar(with: [UIViewController]) {
        
    }
    
}

