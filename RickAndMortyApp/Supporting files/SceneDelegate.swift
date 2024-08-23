//
//  SceneDelegate.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private var coordinator: AppCoordinatorProtocol?
    private var dependencies: IDependencies = Dependencies()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        configureScene(windowScene)
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        dependencies.charactersDataSource.saveContext()
    }
    
    private func configureScene(_ windowScene: UIWindowScene) {
        let navController = UINavigationController()
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navController
        window.makeKeyAndVisible()
        
        coordinator = AppCoordinator(window: window, dependencies: dependencies, navigationController: navController)
        coordinator?.start()
        
    }

}

