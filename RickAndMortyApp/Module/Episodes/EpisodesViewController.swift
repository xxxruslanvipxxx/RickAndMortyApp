//
//  EpisodesVC.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit
import Combine

class EpisodesViewController: EpisodesUI {
    
    private let viewModel: EpisodesViewModelProtocol
    private var characters: [Result] = [] {
        didSet {
            self.collectionViewHeight.constant = (cellSize.height + 40) * CGFloat(characters.count)
            // paste here reload data?
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
    }
    
    private func binding() {
        viewModel.charactersPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] characters in
                self?.characters = characters
                self?.collectionView.reloadData()
            })
            .store(in: &cancellables)
        
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
                
        cell.configure(with: character, image: UIImage(systemName: "photo")!)
                
        viewModel.imagesPublisher
            .compactMap { $0[indexPath.row] }
            .receive(on: RunLoop.main)
            .sink { imageData in
                guard let image = UIImage(data: imageData) else { return }
                cell.updateImage(image)
            }
            .store(in: &cell.cancellables)
                
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
