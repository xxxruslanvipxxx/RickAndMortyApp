//
//  CharactersAssemblyBuilder.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 7.07.24.
//

import Foundation
import UIKit

class CharactersAssemblyBuilder {
    static func configure(_ dependencies: IDependencies, coordinator: CharactersCoordinatorProtocol) -> UIViewController { // todo: coordinator dont needed
        dependencies.moduleContainer.createCharactersView(coordinator: coordinator)
    }
}
