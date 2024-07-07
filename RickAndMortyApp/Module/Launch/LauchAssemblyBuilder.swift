//
//  AssemblyBuilderImpl.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 1.07.24.
//

import Foundation
import UIKit

class LauchAssemblyBuilder: AssemblyBuilder {
    static func configure(_ dependencies: IDependencies) -> UIViewController {
        dependencies.moduleContainer.createLaunchView()
    }
}
