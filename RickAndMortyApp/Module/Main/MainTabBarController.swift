//
//  MainTabBarController.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 7.07.24.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        tabBar.backgroundColor = .white
        tabBar.layer.shadowOffset = CGSize(width: -8, height: 0)
        tabBar.layer.shadowRadius = 8
        tabBar.layer.shadowOpacity = 0.5
    }

}
