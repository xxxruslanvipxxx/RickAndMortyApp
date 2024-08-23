//
//  FavoritesVC.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit
import Combine

class FavoritesViewContorller: FavoritesUI {
    
    private var viewModel: FavoritesViewModelProtocol
    private var input: PassthroughSubject<FavoritesViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private var characters: [Character] = []
    private var dependencies: IDependencies
    
    init(viewModel: FavoritesViewModelProtocol, dependencies: IDependencies) {
        self.viewModel = viewModel
        self.dependencies = dependencies
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

//MARK: - UICollectionViewDataSource
extension FavoritesViewContorller: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier, for: indexPath) as? CharacterCell else {
            fatalError("Failed to dequeue CharacterCell")
        }
        
        let character = characters[indexPath.row]
        let viewModel = CharacterCellViewModel(character: character, dependencies: dependencies)
        
        cell.tag = character.id
        cell.configure(viewModel: viewModel)
        
        return cell
    }
    
    
}

//MARK: - UICollectionViewDelegate
extension FavoritesViewContorller: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = characters[indexPath.row]
        print("Go to \(character.name)")
//        if let didSendCompletionEvent = didSendCompletionEvent {
//            didSendCompletionEvent(.goToDetail(character))
//        }
    }
    
}
