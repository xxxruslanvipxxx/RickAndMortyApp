//
//  FavoritesVC.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit
import Combine

//MARK: - FavoritesViewContorller
class FavoritesViewContorller: FavoritesUI {
    
    //MARK: Internal var's
    var didSendCompletionEvent: ((FavoritesViewContorller.Event) -> Void)?
    
    //MARK: Private var's
    private var viewModel: FavoritesViewModelProtocol
    private var input: PassthroughSubject<FavoritesViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private var characters: [Character] = [] {
        didSet {
            self.collectionViewHeight.constant = (cellSize.height + 40) * CGFloat(characters.count)
            self.collectionView.reloadData()
        }
    }
    private var dependencies: IDependencies
    
    //MARK: Lifecycle methods
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
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        input.send(.fetchFavorites)
    }
    
    //MARK: binding()
    private func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: RunLoop.main)
            .sink { [weak self] output in
                switch output {
                case .fetchCompleted(isCompleted:_):
                    break
                case .favoritesFetched(characters: let characters):
                    self?.characters = characters
                    self?.collectionView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    //MARK: setupDelegates()
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
        if let didSendCompletionEvent = didSendCompletionEvent {
            didSendCompletionEvent(.goToDetail(character))
        }
    }
    
}

//MARK: - CharactersViewController.Event
extension FavoritesViewContorller {
    enum Event {
        case goToDetail(Character)
    }
}
