//
//  Dependencies.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 5.07.24.
//

import Foundation

protocol IDependencies {
    var moduleContainer: ModuleContainer {get}
}

final class Dependencies: IDependencies {
    lazy var moduleContainer: ModuleContainer = ModuleContainer(self)
}
