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
    
    weak private var coordinator: EpisodesCoordinatorProtocol?
    private let viewModel: EpisodesViewModelProtocol
    private var input: PassthroughSubject<EpisodesViewModel.Input, Never> = .init()
    private var nextPageUrl: String?
    private var cancellables = Set<AnyCancellable>()
    private var characters: [Character] = [] {
        didSet {
            self.collectionViewHeight.constant = (cellSize.height + 40) * CGFloat(characters.count)
            self.collectionView.reloadData()
        }
    }
    
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
        input.send(.viewDidLoad)
    }
    
    private func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: RunLoop.main)
            .sink { [weak self] output in
                switch output {
                case .loadBaseCharacters(isLoading: let isLoading):
                    if isLoading {
                        // loading animation here (activity indicator of skeletons)
                    } else {
                        // stop animation
                    }
                case .fetchBaseCharactersSucceed(characters: let characters, nextPageUrl: let nextPageUrl):
                    self?.characters = characters
                    self?.nextPageUrl = nextPageUrl
                case .loadNextPage(isLoading: let isLoading):
                    if isLoading {
                        // start infinite scroll
                    } else {
                        self?.scrollView.finishInfiniteScroll()
                    }
                case .fetchNextPageDidSucceed(characters: let characters, nextPageUrl: let nextPageUrl):
                    self?.characters.append(contentsOf: characters)
                    self?.nextPageUrl = nextPageUrl
                case .fetchDidFail(error: let error):
                    print(error.localizedDescription)
                }
            }
            .store(in: &cancellables)
        
        // Setup infiniteScroll binding
        scrollView.infiniteScrollDirection = .vertical
        scrollView.addInfiniteScroll { [weak self] collection in
            self?.input.send(.paginationRequest(nextPageUrl: self?.nextPageUrl))
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
        
        return cell
    }
    
    
}

//MARK: - UICollectionViewDelegate
extension EpisodesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = characters[indexPath.row]
        print("Go to detail of \(character.name)")
        coordinator?.showDetail(for: character)
    }
    
}
