//
//  FavoritesUI.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 21.08.24.
//

import UIKit

//MARK: - FavoritesUI
class FavoritesUI: UIViewController {
    
    //MARK: Variables
    var collectionViewHeight = NSLayoutConstraint()
    var cellSize: CGSize {
        let width = self.view.frame.size.width - 48
        let cellSize = CGSize(width: width, height: width * 1.15)
        return cellSize
    }
    
    //MARK: UI Variables
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.keyboardDismissMode = .onDrag
        
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var favoritesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ConstantText.favoritesLabelText
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        
        return label
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
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = UIColor(named: ColorName.customBackgroundColor)
        
        return collectionView
    }()
    
    //MARK: Lifecycle methods
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setupTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavigationBar()
        setupConstraints()
    }
    
    //MARK: UI Setup
    private func setupViews() {
        view.backgroundColor = UIColor(named: ColorName.customBackgroundColor)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [favoritesLabel, collectionView].forEach { contentView.addSubview($0) }
    }
    
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
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
        
        //MARK: favoritesLabel constraints
        let favoritesLabelTop = favoritesLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        let favoritesLabelLeading = favoritesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        let favoritesLabelTrailing = favoritesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        
        NSLayoutConstraint.activate([favoritesLabelTop, favoritesLabelLeading, favoritesLabelTrailing])
        
        //MARK: collectionView constraints
        let collectionViewTop = collectionView.topAnchor.constraint(equalTo: favoritesLabel.bottomAnchor, constant: 20)
        let collectionViewLeading = collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        let collectionViewTrailing = collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let collectionViewBottom = collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        collectionViewHeight = collectionView.heightAnchor.constraint(equalToConstant: 1000)
        collectionViewHeight.priority = .defaultHigh
        
        NSLayoutConstraint.activate([collectionViewTop, collectionViewLeading, collectionViewTrailing, collectionViewBottom, collectionViewHeight])
    }
    
    private func setupTabBar() {
        let image = UIImage(named: ImageName.favouritesTabBarImage)
        let selectedImage = UIImage(named: ImageName.favouritesTabBarImageSelected)
        self.tabBarItem.tag = 1
        self.tabBarItem = UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
    }
    
}
