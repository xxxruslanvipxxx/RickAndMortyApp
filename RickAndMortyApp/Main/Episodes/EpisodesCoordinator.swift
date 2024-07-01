//
//  EpisodesCoordinator.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

class EpisodesCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var rootViewController = UINavigationController()
    
    lazy var episodesVC: EpisodesViewController = {
        let vc = AssemblyBuilderImpl.createEpisodesModule()
        vc.tabBarItem.image = UIImage(systemName: "house")
        return vc
    }()
    
    func start() {
        rootViewController.setViewControllers([episodesVC], animated: false)
    }
    
}
