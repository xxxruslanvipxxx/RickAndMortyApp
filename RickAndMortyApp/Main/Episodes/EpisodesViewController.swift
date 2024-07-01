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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var logoImage: UIImageView = {
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
    }

    private func setupSubviews() {
        
        view.addSubview(logoImage)
        
    }
    
}
