//
//  DetailUI.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 8.08.24.
//

import Foundation
import UIKit

class DetailUI: UIViewController {
    
    //MARK: UI Variables
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.keyboardDismissMode = .onDrag
        
        return scrollView
    }()
    
    lazy var roundedImageView: UIImageView = {
        let defaultImage = UIImage(systemName: ImageName.systemPlaceholder)
        let imageView = UIImageView(image: defaultImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .yellow
        
        return imageView
    }()
    
    private lazy var roundedImageBackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var photoButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: ImageName.camera)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = UIColor(named: ColorName.mainDark)
        label.text = "Rick Sanchez"
        
        return label
    }()
    
    private lazy var informationsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ConstantText.informationsLabel
        label.textColor = .gray
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    lazy var infoTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: InfoTableViewCell.identifier)
        tableView.backgroundColor = .orange
        
        return tableView
    }()
    
    //MARK: Lifecicle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        roundViews()
    }
    
    //MARK: Setup UI
    private func setupViews() {
        view.backgroundColor = UIColor(named: ColorName.customBackgroundColor)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        roundedImageBackView.addSubview(roundedImageView)
        let contentViewSubviews = [roundedImageBackView, photoButton, nameLabel, informationsLabel, infoTableView]
        contentViewSubviews.forEach { contentView.addSubview($0) }
    }
    
    private func roundViews() {
        roundedImageBackView.layoutIfNeeded()
        roundedImageView.layoutIfNeeded()
        
        let backViewRadius = roundedImageBackView.frame.size.width / 2
        let imageViewRadius = roundedImageView.frame.size.width / 2
        
        roundedImageBackView.layer.cornerRadius = backViewRadius
        roundedImageView.layer.cornerRadius = imageViewRadius
        
    }
    
    //MARK: Setup constraints
    private func setupConstraints() {
        
        //MARK: scrollView constraints
        let scrollViewTop = scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let scrollViewLeading = scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        let scrollViewTrailing = scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        let scrollViewBottom = scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([scrollViewTop, scrollViewLeading, scrollViewTrailing, scrollViewBottom])
        
        //MARK: contentView constraints
        let contentViewTop = contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor)
        let contentViewBottom = contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        let contentViewLeading = contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor)
        let contentViewTrailing = contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor)
        let contentViewWidth = contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        let contentViewHeight = contentView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        contentViewHeight.priority = UILayoutPriority(rawValue: 250)
        
        NSLayoutConstraint.activate([contentViewTop, contentViewBottom, contentViewLeading, contentViewTrailing, contentViewWidth, contentViewHeight])
        
        //MARK: roundedImageBackView constraints
        let roundedImageBackViewCenterX = roundedImageBackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        let roundedImageBackViewWidth = roundedImageBackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4)
        let roundedImageBackViewHeight = roundedImageBackView.heightAnchor.constraint(equalTo: roundedImageBackView.widthAnchor)
        let roundedImageBackViewTop = roundedImageBackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40)
        
        NSLayoutConstraint.activate([roundedImageBackViewCenterX, roundedImageBackViewWidth, roundedImageBackViewHeight, roundedImageBackViewTop])
        
        //MARK: roundedImageView constraints
        let roundedImageViewCenterX = roundedImageView.centerXAnchor.constraint(equalTo: roundedImageBackView.centerXAnchor)
        let roundedImageViewCenterY = roundedImageView.centerYAnchor.constraint(equalTo: roundedImageBackView.centerYAnchor)
        let roundedImageViewWidth = roundedImageView.widthAnchor.constraint(equalTo: roundedImageBackView.widthAnchor, multiplier: 0.94)
        let roundedImageViewHeight = roundedImageView.heightAnchor.constraint(equalTo: roundedImageBackView.heightAnchor, multiplier: 0.94)
        
        NSLayoutConstraint.activate([roundedImageViewCenterX, roundedImageViewCenterY, roundedImageViewWidth, roundedImageViewHeight])
        
        //MARK: photoButton constraints
        let photoButtonLeading = photoButton.leftAnchor.constraint(equalTo: roundedImageBackView.rightAnchor, constant: 5)
        let photoButtonCenterY = photoButton.centerYAnchor.constraint(equalTo: roundedImageBackView.centerYAnchor)
        let photoButtonWidth = photoButton.widthAnchor.constraint(equalToConstant: 32)
        let photoButtonHeight = photoButton.heightAnchor.constraint(equalToConstant: 32)
        
        NSLayoutConstraint.activate([photoButtonLeading, photoButtonCenterY, photoButtonWidth, photoButtonHeight])
        
        //MARK: nameLabel constraints
        let nameLabelTop = nameLabel.topAnchor.constraint(equalTo: roundedImageBackView.bottomAnchor, constant: 40)
        let nameLabelCenterX = nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        
        NSLayoutConstraint.activate([nameLabelTop, nameLabelCenterX])
        
        //MARK: informationsLabel constraints
        let informationsLabelTop = informationsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 25)
        let informationsLabelLeading = informationsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        
        NSLayoutConstraint.activate([informationsLabelTop, informationsLabelLeading])
        
        //MARK: infoTableView constraints
        let infoTableViewTop = infoTableView.topAnchor.constraint(equalTo: informationsLabel.bottomAnchor, constant: 25)
        let infoTableViewLeading = infoTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26)
        let infoTableViewTrailing = infoTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26)
        let infoTableViewBottom = infoTableView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -25)
        let infoTableViewHeight = infoTableView.heightAnchor.constraint(equalToConstant: 360)
        
        NSLayoutConstraint.activate([infoTableViewTop, infoTableViewLeading, infoTableViewTrailing, infoTableViewBottom, infoTableViewHeight])
    }
    
    //MARK: Setup navigation bar
    private func setupNavigationBar() {
        let logoImageView = UIImageView(image: UIImage(named: ImageName.logoBlack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoImageView)
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        let imageView = UIImageView(image: UIImage(systemName: ImageName.systemArrowBackward))
        imageView.tintColor = .black
        
        let label = UILabel()
        label.text = ConstantText.goBackButton
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        
        let stack = UIStackView(arrangedSubviews: [imageView, label])
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        stack.addGestureRecognizer(tapGestureRecognizer)
        stack.axis = .horizontal
        stack.spacing = 8
        
        let buttonItem = UIBarButtonItem(customView: stack)
        
        navigationItem.leftBarButtonItem = buttonItem
    }
    
    @objc
    private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
}
