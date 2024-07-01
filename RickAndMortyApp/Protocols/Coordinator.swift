//
//  Coordinator.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

protocol Coordinator {
    func start()
    var childCoordinators: [Coordinator] { get set }
}
