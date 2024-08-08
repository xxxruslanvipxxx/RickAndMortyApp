//
//  FavouritesVC.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

class FavouritesViewContorller: UIViewController {
    
    public var viewModel: FavouritesViewModelProtocol

    init(viewModel: FavouritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setupTabBar()
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
        let image = UIImage(named: ImageName.favouritesTabBarImage)
        let selectedImage = UIImage(named: ImageName.favouritesTabBarImageSelected)
        self.tabBarItem.tag = 1
        self.tabBarItem = UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
    }

}
