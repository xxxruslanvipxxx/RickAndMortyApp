//
//  LaunchCoordinator.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

protocol LaunchCoordinatorProtocol: Coordinator {
    func start()
}

class LaunchCoordinator: LaunchCoordinatorProtocol {
    
    var finishDelegate: CoordinatorFinishDelegate?
    var rootViewController: UINavigationController
    var type: CoordinatorType { .launch }
    var childCoordinators = [Coordinator]()
    var dependencies: IDependencies
    
    init(_ navigationController: UINavigationController, dependencies: IDependencies) {
        self.rootViewController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        showLaunchViewController()
    }
    
    private func showLaunchViewController() {
        let launchViewController = LauchAssemblyBuilder.configure(dependencies)
        if let launchViewController = launchViewController as? LaunchViewController {
            launchViewController.didSendCompletionEvent = { [weak self] event in
                switch event {
                case .launchComplete:
                    self?.finish()
                }
            }
        }
        
        rootViewController.show(launchViewController, sender: self)
    }
    
}

