//
//  ModuleContainer.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 6.07.24.
//

import UIKit

protocol ModuleContainerProtocol {
    func createLaunchView() -> UIViewController
    func createCharactersView(coordinator: CharactersCoordinatorProtocol) -> UIViewController
    func createFavouritesView() -> UIViewController
    func createDetailView(coordinator: DetailCoordinatorProtocol, with character: Character) -> UIViewController
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
    func createCharactersView(coordinator: CharactersCoordinatorProtocol) -> UIViewController {
        let vm = CharactersViewModel(dependencies)
        let vc = CharactersViewController(viewModel: vm, coordinator: coordinator)
        
        return vc
    }
}

extension ModuleContainer {
    func createDetailView(coordinator: DetailCoordinatorProtocol, with character: Character) -> UIViewController {
        let vm = DetailViewModel(character: character)
        let vc = DetailViewController(viewModel: vm, coordinator: coordinator)
        
        return vc
    }
}

extension ModuleContainer {
    func createFavouritesView() -> UIViewController {
        let vm = FavouritesViewModel()
        let vc = FavouritesViewContorller(viewModel: vm)

        return vc
    }
}
