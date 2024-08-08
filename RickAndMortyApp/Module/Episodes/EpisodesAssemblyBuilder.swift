//
//  EpisodesAssemblyBuilder.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 7.07.24.
//

import Foundation
import UIKit

class EpisodesAssemblyBuilder {
    static func configure(_ dependencies: IDependencies, coordinator: EpisodesCoordinatorProtocol) -> UIViewController {
        dependencies.moduleContainer.createEpisodesView(coordinator: coordinator)
    }
}
