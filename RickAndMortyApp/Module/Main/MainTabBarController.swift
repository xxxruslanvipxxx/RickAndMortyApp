//
//  MainTabBarController.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 7.07.24.
//

import UIKit

//MARK: - MainTabBarController
class MainTabBarController: UITabBarController {

    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarShadows()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = (view.window?.windowScene?.screen.bounds.height ?? 800) * 0.10
        setTabBarHeight(height: height)
    }
    
    //MARK: Setup UI
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
