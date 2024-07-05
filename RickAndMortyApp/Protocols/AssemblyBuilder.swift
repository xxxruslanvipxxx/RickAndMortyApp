//
//  AssemblyBuilderProtocol.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 1.07.24.
//

import Foundation
import UIKit

protocol AssemblyBuilder {
    static func configure(_ dependencies: IDependencies) -> UIViewController
}
