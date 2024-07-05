//
//  AppCoordinator.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    
}

final class AppCoordinator: AppCoordinatorProtocol {
    
    var navigationController: UINavigationController
    var type: CoordinatorType { .app }
    var childCoordinators = [Coordinator]()
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func start() {
        showLauncFlow()
    }
    
    func showLauncFlow() {
        let launchCoordinator = LaunchCoordinator(navigationController)
        launchCoordinator.start()
        childCoordinators.append(launchCoordinator)
    }
    
    
}


