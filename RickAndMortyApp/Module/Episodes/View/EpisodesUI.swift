//
//  EpisodesUI.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 8.07.24.
//

import UIKit

class EpisodesUI: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setupTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var logoImageView: UIImageView = {
        let image = UIImage(named: "appLogo")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        // Add color to placeholder text
        tf.attributedPlaceholder = NSAttributedString(string: ConstantText.searchTextFieldPlaceholder,
                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        tf.font = .systemFont(ofSize: 18)
        tf.autocorrectionType = .no
        tf.clearButtonMode = .whileEditing
        // Border customization
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 8
        // Set leading image
        let image = UIImage(named: ImageName.leadingTextView)
        let imageView = UIImageView(frame: CGRect(x: 10, y: 8, width: 24, height: 24))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        // View for leading image paddings
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.addSubview(imageView)
        
        tf.leftViewMode = .always
        tf.leftView = view
        
        return tf
    }()
    
    private lazy var filtersButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: ImageName.filterButtonImage)
        button.setBackgroundImage(image, for: .normal)
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 1
        
        return button
    }()
    
    private lazy var searchAndFilterVStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchTextField, filtersButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    var contentHeight: CGFloat = 2000
    
    var contentSize: CGSize {
        CGSize(width: view.frame.width, height: contentHeight)
    }
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        // UICollectionViewFlowLayout
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.minimumLineSpacing = 40
        // Cell Size
        let width = self.view.frame.size.width
        let cellSize = CGSize(width: width, height: width * 1.1)
        collectionLayout.itemSize = cellSize
        // UICollectionView
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.keyboardDismissMode = .onDrag
        
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
        
    private func setupViews() {
        view.backgroundColor = UIColor(named: ColorName.customBackgroundColor)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [logoImageView, searchAndFilterVStack, collectionView].forEach { self.contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        
        // scrollView constraints
        let scrollViewTop = scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let scrollViewLeading = scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        let scrollViewTrailing = scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        let scrollViewBottom = scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([scrollViewTop, scrollViewLeading, scrollViewTrailing, scrollViewBottom])
        
        // contentView constraints
        let contentViewTop = contentView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        let contentViewLeading = contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        let contentViewTrailing = contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        let contentViewBottom = contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        
        NSLayoutConstraint.activate([contentViewTop, contentViewLeading, contentViewTrailing, contentViewBottom])
        
        // logoImageView constraints
        let logoImageViewCenterX = logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        let logoImageViewTop = logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        let logoImageViewWidth = logoImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8)
        let logoImageViewHeight = logoImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/3)
        
        NSLayoutConstraint.activate([logoImageViewCenterX, logoImageViewTop, logoImageViewWidth, logoImageViewHeight])
        
        // searchAndFilterVStack constraints
        let searchAndFilterStackTop = searchAndFilterVStack.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30)
        let searchAndFilterStackLeading = searchAndFilterVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 21)
        let searchAndFilterStackTrailing = searchAndFilterVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -21)
        
        NSLayoutConstraint.activate([searchAndFilterStackTop, searchAndFilterStackLeading, searchAndFilterStackTrailing])
        
        // searchTextField constraints
        let searchTextFieldLeading = searchTextField.leadingAnchor.constraint(equalTo: searchAndFilterVStack.leadingAnchor)
        let searchTextFieldTrailing = searchTextField.trailingAnchor.constraint(equalTo: searchAndFilterVStack.trailingAnchor)
        
        NSLayoutConstraint.activate([searchTextFieldLeading, searchTextFieldTrailing])
        
        // filtersButton constraints
        let filtersButtonLeading = filtersButton.leadingAnchor.constraint(equalTo: searchAndFilterVStack.leadingAnchor)
        let filtersButtonTrailing = filtersButton.trailingAnchor.constraint(equalTo: searchAndFilterVStack.trailingAnchor)
        
        NSLayoutConstraint.activate([filtersButtonLeading, filtersButtonTrailing])
        
        // collectionView constraints
        let collectionViewTop = collectionView.topAnchor.constraint(equalTo: searchAndFilterVStack.bottomAnchor, constant: 20)
        let collectionViewLeading = collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 21)
        let collectionViewTrailing = collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -21)
        let collectionViewBottom = collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        let collectionViewHeight = collectionView.heightAnchor.constraint(equalToConstant: contentHeight)
        
        
        NSLayoutConstraint.activate([collectionViewTop, collectionViewLeading, collectionViewTrailing, collectionViewBottom, collectionViewHeight])
    }
    
    private func setupTabBar() {
        let image = UIImage(named: ImageName.homeTabBarImage)
        let selectedImage = UIImage(named: ImageName.homeTabBarImageSelected)
        self.tabBarItem.tag = 1
        self.tabBarItem = UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
    }
}
