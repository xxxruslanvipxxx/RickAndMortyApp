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
    
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var tabBarController: UITabBarController = MainTabBarController()
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

    }
    
    func showLaunchFlow() {
        let launchCoordinator = LaunchCoordinator(navigationController, dependencies: dependencies)
        launchCoordinator.finishDelegate = self
        launchCoordinator.start()
        childCoordinators.append(launchCoordinator)
    }
    
    func showMainFlow() {
        let mainTabCoordinator = MainTabBarCoordinator(rootViewController: tabBarController, dependencies: dependencies)
        mainTabCoordinator.finishDelegate = self
        window.rootViewController = mainTabCoordinator.rootViewController
        mainTabCoordinator.start()
        childCoordinators.append(mainTabCoordinator)
    }
    
}

extension AppCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type}
        switch childCoordinator.type {
        case .launch:
            showMainFlow()
        case .app, .main, .characters, .favorites, .detail:
            break
        }
    }
    
}
