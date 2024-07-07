//
//  Coordinator.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

enum CoordinatorType {
    case app, launch, main, episodes, favourites
}

protocol Coordinator: AnyObject {
//    var rootViewController: UINavigationController {get set}
    var childCoordinators: [Coordinator] { get set }
    var type: CoordinatorType {get}
     var dependencies: IDependencies {get set}
    func start()
    func finish()
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
    }
}
