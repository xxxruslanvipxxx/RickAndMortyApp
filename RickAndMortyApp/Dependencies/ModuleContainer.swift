//
//  ModuleContainer.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 6.07.24.
//

import UIKit

protocol ModuleContainerProtocol {
    func createLaunchView() -> UIViewController
    func createCharactersView() -> UIViewController
    func createFavoritesView() -> UIViewController
    func createDetailView(with character: Character) -> UIViewController
}

final class ModuleContainer: ModuleContainerProtocol {
    private let dependencies: IDependencies
    required init(_ dependencies: IDependencies) {
        self.dependencies = dependencies
    }
}

extension ModuleContainer {
    func createLaunchView() -> UIViewController {
        let launchVC = LaunchViewController()
        return launchVC
    }
}

extension ModuleContainer {
    func createCharactersView() -> UIViewController {
        let vm = CharactersViewModel(dependencies)
        let vc = CharactersViewController(viewModel: vm)
        
        return vc
    }
}

extension ModuleContainer {
    func createDetailView(with character: Character) -> UIViewController {
        let vm = DetailViewModel(character: character)
        let vc = DetailViewController(viewModel: vm)
        
        return vc
    }
}

extension ModuleContainer {
    func createFavoritesView() -> UIViewController {
        let vm = FavoritesViewModel()
        let vc = FavoritesViewContorller(viewModel: vm)

        return vc
    }
}
