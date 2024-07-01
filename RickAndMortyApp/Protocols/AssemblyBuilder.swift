//
//  AssemblyBuilderProtocol.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 1.07.24.
//

import Foundation
import UIKit

protocol AssemblyBuilder {
    static func createEpisodesModule() -> EpisodesViewController
    static func createFavouritesModule() -> FavouritesViewContorller
}
