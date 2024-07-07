//
//  FavouritesVC.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

class FavouritesViewContorller: UIViewController {
    
    public var viewModel: FavouritesViewModel

    init(viewModel: FavouritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        setupTabBar()
    }

    private func setupTabBar() {
        self.tabBarItem = UITabBarItem(title: "Fav", image: UIImage(named: ImageName.favouritesTabBarImage), tag: 1)
    }

}
