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
    
    private let coordinator: EpisodesCoordinatorProtocol
    private let viewModel: EpisodesViewModelProtocol
    private var characters: [Result] = [] {
        didSet {
            self.collectionViewHeight.constant = (cellSize.height + 40) * CGFloat(characters.count)
            self.collectionView.reloadData()
        }
    }
    
    private var images: [Int: UIImage] = [:]
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: EpisodesViewModelProtocol, coordinator: EpisodesCoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        binding()
        viewModel.getAllCharacters(page: 1)
    }
    
    private func binding() {
        // Characters loaded binding
        viewModel.charactersPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] characters in
                guard let self else { return }
                self.characters = characters
            })
            .store(in: &cancellables)
        
        // Images loaded binding
        viewModel.imagesPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] imageDataDict in
                guard let self = self else { return }
                
                for (key, imageData) in imageDataDict {
                    if let data = imageData, let image = UIImage(data: data) {
                        self.images[key] = image
                    } else {
                        self.images[key] = nil
                    }
                }

                self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            }
            .store(in: &cancellables)
        
        // Character selected binding
        viewModel.characterSelected.sink { result in
            self.coordinator.showDetail(for: result)
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
        
        cell.tag = character.id
        cell.configure(with: character, image: UIImage(systemName: ImageName.systemPlaceholder)!)
        
        if let image = images[character.id], cell.tag == character.id {
            cell.updateImage(image)
        }
        
        return cell
    }
    
    
}

//MARK: - UICollectionViewDelegate
extension EpisodesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = characters[indexPath.row]
        print("Go to detail of \(character.name)")
        self.viewModel.characterSelected.send(character)
    }
    
}
