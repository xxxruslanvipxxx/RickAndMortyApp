//
//  CharactersCoordinator.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

protocol CharactersCoordinatorProtocol: Coordinator {
    func start()
    func showDetail(for character: Character)
}

class CharactersCoordinator: CharactersCoordinatorProtocol {
    
    var finishDelegate: CoordinatorFinishDelegate?
    var rootViewController = UINavigationController()
    var type: CoordinatorType = .characters
    var dependencies: IDependencies
    var childCoordinators = [Coordinator]()
    
    init(rootViewController: UINavigationController = UINavigationController(), dependencies: IDependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    func start() {
        showCharacters()
    }
    
    func showCharacters() {
        let charactersVC = CharactersAssemblyBuilder.configure(dependencies)
        if let charactersVC = charactersVC as? CharactersViewController {
            charactersVC.didSendCompletionEvent = { [weak self] event in
                switch event {
                case .goToDetail(let character):
                    self?.finish()
                    self?.showDetail(for: character)
                }
            }
        }
        rootViewController.pushViewController(charactersVC, animated: false)
    }
    
    func showDetail(for character: Character) {
        let detailCoordinator = DetailCoordinator(rootViewController: rootViewController, character: character, dependencies: dependencies)
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
    }
    
}
