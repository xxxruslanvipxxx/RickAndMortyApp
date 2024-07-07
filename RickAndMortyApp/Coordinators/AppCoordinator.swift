//
//  AppCoordinator.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    func start()
    func showLaunchFlow()
    func showMainFlow()
}

final class AppCoordinator: AppCoordinatorProtocol {
    
    var navigationController: UINavigationController
    var tabBarController: UITabBarController = UITabBarController()
    var window: UIWindow
    var type: CoordinatorType { .app }
    var childCoordinators = [Coordinator]()
    var dependencies: IDependencies
    
    required init(window: UIWindow, dependencies: IDependencies, navigationController: UINavigationController) {
        navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.window = window
    }
    
    func start() {
        showLaunchFlow()
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
            self.showMainFlow()
        }
    }
    
    func showLaunchFlow() {
        let launchCoordinator = LaunchCoordinator(navigationController, dependencies: dependencies)
        launchCoordinator.start()
        childCoordinators.append(launchCoordinator)
    }
    
    func showMainFlow() {
        let mainTabCoordinator = MainTabBarCoordinator(rootViewController: tabBarController, dependencies: dependencies)
        window.rootViewController = mainTabCoordinator.rootViewController
        mainTabCoordinator.start()
    }
    
}


