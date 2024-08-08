//
//  DetailAssemblyBuilder.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 7.08.24.
//

import Foundation
import UIKit

class DetailAssemblyBuilder: AssemblyBuilder {
    static func configure(_ dependencies: IDependencies) -> UIViewController {
        dependencies.moduleContainer.createDetailView()
    }
}
