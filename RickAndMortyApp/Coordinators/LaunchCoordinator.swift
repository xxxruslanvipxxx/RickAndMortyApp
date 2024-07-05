//
//  LaunchCoordinator.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

protocol LaunchCoordinatorProtocol: Coordinator {
    
}

class LaunchCoordinator: LaunchCoordinatorProtocol {
    
    var navigationController: UINavigationController
    var type: CoordinatorType { .launch }
    var childCoordinators = [Coordinator]()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    private func showLaunchViewController() {
//        let launchViewController = LauchAssemblyBuilder.configure(<#T##dependencies: any IDependencies##any IDependencies#>)
    }
    
}

