//
//  CharactersUI.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 8.07.24.
//

import UIKit

class CharactersUI: UIViewController {
    
    //MARK: Variables
    var collectionViewHeight = NSLayoutConstraint()
    var cellSize: CGSize {
        let width = self.view.frame.size.width - 48
        let cellSize = CGSize(width: width, height: width * 1.15)
        return cellSize
    }
    
    //MARK: UI Variables
    private lazy var logoImageView: UIImageView = {
        let image = UIImage(named: ImageName.appLogo)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.accessibilityIdentifier = "searchTextField"
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
        tf.returnKeyType = .search
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
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        // UICollectionViewFlowLayout
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.minimumLineSpacing = 40
        collectionLayout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        // Cell Size
        collectionLayout.itemSize = cellSize
        // UICollectionView
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = UIColor(named: ColorName.customBackgroundColor)
        
        return collectionView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.keyboardDismissMode = .onDrag
        
        return scrollView
    }()
    
    //MARK: Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        searchTextField.delegate = self
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setupTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    //MARK: UI setup methods
    private func setupViews() {
        view.backgroundColor = UIColor(named: ColorName.customBackgroundColor)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [logoImageView, searchAndFilterVStack, collectionView].forEach { self.contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        
        //MARK: scrollView constraints
        let scrollViewTop = scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let scrollViewLeading = scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        let scrollViewTrailing = scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        let scrollViewBottom = scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([scrollViewTop, scrollViewLeading, scrollViewTrailing, scrollViewBottom])
        
        //MARK: contentView constraints
        let contentViewTop = contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor)
        let contentViewLeading = contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor)
        let contentViewTrailing = contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor)
        let contentViewBottom = contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        let contentViewWidth = contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        let contentViewHeight = contentView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        contentViewHeight.priority = .defaultLow
        
        NSLayoutConstraint.activate([contentViewTop, contentViewLeading, contentViewTrailing, contentViewBottom, contentViewWidth, contentViewHeight])
        
        //MARK: logoImageView constraints
        let logoImageViewCenterX = logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        let logoImageViewTop = logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        let logoImageViewWidth = logoImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8)
        let logoImageViewHeight = logoImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/3)
        
        NSLayoutConstraint.activate([logoImageViewCenterX, logoImageViewTop, logoImageViewWidth, logoImageViewHeight])
        
        //MARK: searchAndFilterVStack constraints
        let searchAndFilterStackTop = searchAndFilterVStack.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30)
        let searchAndFilterStackLeading = searchAndFilterVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 21)
        let searchAndFilterStackTrailing = searchAndFilterVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -21)
        
        NSLayoutConstraint.activate([searchAndFilterStackTop, searchAndFilterStackLeading, searchAndFilterStackTrailing])
        
        //MARK: searchTextField constraints
        let searchTextFieldLeading = searchTextField.leadingAnchor.constraint(equalTo: searchAndFilterVStack.leadingAnchor)
        let searchTextFieldTrailing = searchTextField.trailingAnchor.constraint(equalTo: searchAndFilterVStack.trailingAnchor)
        
        NSLayoutConstraint.activate([searchTextFieldLeading, searchTextFieldTrailing])
        
        //MARK: filtersButton constraints
        let filtersButtonLeading = filtersButton.leadingAnchor.constraint(equalTo: searchAndFilterVStack.leadingAnchor)
        let filtersButtonTrailing = filtersButton.trailingAnchor.constraint(equalTo: searchAndFilterVStack.trailingAnchor)
        
        NSLayoutConstraint.activate([filtersButtonLeading, filtersButtonTrailing])
        
        //MARK: collectionView constraints
        let collectionViewTop = collectionView.topAnchor.constraint(equalTo: searchAndFilterVStack.bottomAnchor, constant: 20)
        let collectionViewLeading = collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        let collectionViewTrailing = collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let collectionViewBottom = collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        collectionViewHeight = collectionView.heightAnchor.constraint(equalToConstant: 1000)
        collectionViewHeight.priority = .defaultHigh
        
        NSLayoutConstraint.activate([collectionViewTop, collectionViewLeading, collectionViewTrailing, collectionViewBottom, collectionViewHeight])
    }
    
    private func setupTabBar() {
        let image = UIImage(named: ImageName.homeTabBarImage)
        let selectedImage = UIImage(named: ImageName.homeTabBarImageSelected)
        self.tabBarItem.tag = 1
        self.tabBarItem = UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
    }
}

//MARK: - UITextFieldDelegate
extension CharactersUI: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}
