//
//  AppCoordinator.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    
    var childCoordinators = [Coordinator]()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
        let launchCoordinator = MainCoordinator()
        let launchVC = launchCoordinator.rootViewController
        
        launchCoordinator.start()
        
        self.childCoordinators.append(launchCoordinator)
        
        window.rootViewController = launchVC

    }
    
}


