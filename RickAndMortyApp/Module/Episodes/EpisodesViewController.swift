//
//  EpisodesVC.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit
import Combine
import UIScrollView_InfiniteScroll

class EpisodesViewController: EpisodesUI {
    
    private let viewModel: EpisodesViewModelProtocol
    private var characters: [Result] = [] {
        didSet {
            self.collectionViewHeight.constant = (cellSize.height + 40) * CGFloat(characters.count)
            self.collectionView.reloadData()
        }
    }
    
    private var images: [UIImage?] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: EpisodesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        binding()
        viewModel.getAllCharacters(by: 1)
    }
    
    private func binding() {
        viewModel.charactersPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] characters in
                guard let self else { return }
                self.characters = characters
                self.images = Array(repeating: nil, count: characters.count)
            })
            .store(in: &cancellables)
        
        viewModel.imagesPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] imageDataArray in
                guard let self = self else { return }
                
                // Обновляем массив изображений
                for (index, imageData) in imageDataArray.enumerated() where index < self.images.count {
                    self.images[index] = imageData.flatMap { UIImage(data: $0) }
                }
                
                // Обновляем только видимые ячейки
                self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            }
            .store(in: &cancellables)
        
        // Setup infiniteScroll binding
        scrollView.infiniteScrollDirection = .vertical
        scrollView.addInfiniteScroll { [weak self] collection in
            guard let self else { return }
            self.viewModel.loadNextPage()
            
            self.scrollView.finishInfiniteScroll()
        }
    }
    
    private func setupDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
}

//MARK: - UICollectionViewDataSource
extension EpisodesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier, for: indexPath) as? CharacterCell else {
            fatalError("Failed to dequeue CharacterCell")
        }
        
        let character = characters[indexPath.row]
          
        cell.configure(with: character, image: UIImage(systemName: ImageName.systemPlaceholder)!)
        
        // Устанавливаем изображение, если оно уже загружено
        if indexPath.row < images.count, let image = images[indexPath.row] {
            cell.updateImage(image)
        }
        
        return cell
    }
    
    
}

//MARK: - UICollectionViewDelegate
extension EpisodesViewController: UICollectionViewDelegate {}

//extension EpisodesViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = self.view.frame.size.width
//        let cellSize = CGSize(width: width, height: width * 1.1)
//        
//        return cellSize
//    }
//}
