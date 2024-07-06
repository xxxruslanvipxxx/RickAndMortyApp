//
//  AppCoordinator.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    func start()
    func showLauncFlow()
}

final class AppCoordinator: AppCoordinatorProtocol {
    
    var navigationController: UINavigationController
    var type: CoordinatorType { .app }
    var childCoordinators = [Coordinator]()
    var dependencies: IDependencies
    
    required init(_ navigationController: UINavigationController, dependencies: IDependencies) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
        self.dependencies = dependencies
    }
    
    func start() {
        showLauncFlow()
    }
    
    func showLauncFlow() {
        let launchCoordinator = LaunchCoordinator(navigationController, dependencies: dependencies)
        launchCoordinator.start()
        childCoordinators.append(launchCoordinator)
    }
    
    
}


