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
        setupTabBarShadows()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTabBarHeight(height: 90)
    }
    
    private func setupTabBarShadows() {
        tabBar.backgroundColor = .white
        tabBar.layer.shadowOffset = CGSize(width: -8, height: 0)
        tabBar.layer.shadowRadius = 8
        tabBar.layer.shadowOpacity = 0.5
    }
    
    private func setTabBarHeight(height: Double) {
        tabBar.frame.size.height = height
        tabBar.frame.origin.y = view.frame.height - height
    }

}
