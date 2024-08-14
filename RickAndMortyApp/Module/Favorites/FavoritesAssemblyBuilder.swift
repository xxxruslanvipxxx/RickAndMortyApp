//
//  FavoritesAssemblyBuilder.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 7.07.24.
//

import Foundation
import UIKit

class FavoritesAssemblyBuilder: AssemblyBuilder {
    static func configure(_ dependencies: IDependencies) -> UIViewController {
        dependencies.moduleContainer.createFavoritesView()
    }
}
