//
//  EpisodesVC.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

class EpisodesViewController: UIViewController {
    
    public var viewModel: EpisodesViewModelProtocol
    
    init(viewModel: EpisodesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setupTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var logoImageView: UIImageView = {
        let image = UIImage(named: "appLogo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        view.backgroundColor = UIColor(named: "customBackgroundColor")
        view.backgroundColor = .green
        setupSubviews()
    }

    private func setupSubviews() {
        
        view.addSubview(logoImageView)
        
        let logoImageViewCenterX = logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        let logoImageViewTop = logoImageView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 97)
        let logoImageViewWidth = logoImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8)
        let logoImageViewHeight = logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 1/3)
        
        NSLayoutConstraint.activate([logoImageViewCenterX, logoImageViewTop, logoImageViewWidth, logoImageViewHeight])
        
    }
    
    private func setupTabBar() {
        let image = UIImage(named: ImageName.homeTabBarImage)
        let selectedImage = UIImage(named: ImageName.homeTabBarImageSelected)
        self.tabBarItem.tag = 1
        self.tabBarItem = UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
    }
    
}
