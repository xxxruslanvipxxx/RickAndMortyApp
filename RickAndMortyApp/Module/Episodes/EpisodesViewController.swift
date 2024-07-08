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
        let cell = UICollectionViewCell()
        cell.backgroundColor = .red
        
        return cell
    }
    
    
}

extension EpisodesViewController: UICollectionViewDelegate {
    
}
