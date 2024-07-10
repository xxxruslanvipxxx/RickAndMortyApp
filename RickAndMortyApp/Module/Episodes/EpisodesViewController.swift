//
//  EpisodesVC.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit

class EpisodesViewController: EpisodesUI {
    
    public var viewModel: EpisodesViewModelProtocol
    
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
    }
    
    private func setupDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
}

extension EpisodesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeCell.identifier, for: indexPath) as? EpisodeCell else {
            fatalError("Failed to dequeue EpisodeCell")
        }
        let image = UIImage(systemName: "sun.max.fill")
        cell.configure(with: image)
        
        return cell
    }
    
    
}

extension EpisodesViewController: UICollectionViewDelegate {
    
}

//extension EpisodesViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = self.view.frame.size.width
//        let cellSize = CGSize(width: width, height: width * 1.1)
//        
//        return cellSize
//    }
//}
