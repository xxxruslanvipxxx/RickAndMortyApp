//
//  DetailAssemblyBuilder.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 7.08.24.
//

import Foundation
import UIKit

class DetailAssemblyBuilder{
    static func configure(_ dependencies: IDependencies, character: Result, coordinator: DetailCoordinatorProtocol) -> UIViewController {
        dependencies.moduleContainer.createDetailView(coordinator: coordinator, with: character)
    }
}
