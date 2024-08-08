//
//  DetailUI.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 8.08.24.
//

import Foundation
import UIKit

class DetailUI: UIViewController {
    
    private lazy var roundedImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var roundedImageBackView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var photoButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var informationsLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var infoTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    //MARK: Lifecicle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
    }
    
    //MARK: Setup navigation bar
    private func setupNavigationBar() {
        let logoImageView = UIImageView(image: UIImage(named: ImageName.logoBlack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoImageView)
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        let imageView = UIImageView(image: UIImage(systemName: "arrow.backward"))
        imageView.tintColor = .black
        let label = UILabel()
        label.text = "GO BACK"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        let stack = UIStackView(arrangedSubviews: [imageView, label])
        stack.axis = .horizontal
        stack.spacing = 8
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        stack.addGestureRecognizer(tapGestureRecognizer)
        let buttonItem = UIBarButtonItem(customView: stack)

        navigationItem.leftBarButtonItem = buttonItem
    }
    
    @objc
    private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Setup UI
    private func setupViews() {
        view.backgroundColor = UIColor(named: ColorName.customBackgroundColor)
    }
    
}
