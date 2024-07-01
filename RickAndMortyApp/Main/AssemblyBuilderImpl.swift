//
//  AssemblyBuilderImpl.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 1.07.24.
//

import Foundation
import UIKit

class AssemblyBuilderImpl: AssemblyBuilder {
    
    static func createEpisodesModule() -> EpisodesViewController {
        let viewModel = EpisodesViewModel()
        let viewController = EpisodesViewController(viewModel: viewModel)
        // network service later
        return viewController
    }
    
    static func createFavouritesModule() -> FavouritesViewContorller {
        
        return FavouritesViewContorller()
    }
    
    
}
