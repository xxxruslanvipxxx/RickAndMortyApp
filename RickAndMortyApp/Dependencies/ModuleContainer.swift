//
//  ModuleContainer.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 6.07.24.
//

import Foundation
import UIKit

protocol ModuleContainerProtocol {
    func createLaunchView() -> UIViewController
    func createEpisodesView() -> UIViewController
    func createFavouritesView() -> UIViewController
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
    func createEpisodesView() -> UIViewController {
        let vm = EpisodesViewModel()
        let vc = EpisodesViewController(viewModel: vm)
        
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
