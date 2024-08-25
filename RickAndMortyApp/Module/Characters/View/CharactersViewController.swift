//
//  CharactersViewController.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 30.06.24.
//

import UIKit
import Combine
import UIScrollView_InfiniteScroll

class CharactersViewController: CharactersUI {
    
    var didSendCompletionEvent: ((CharactersViewController.Event) -> Void)?
    private let viewModel: CharactersViewModelProtocol
    private var dependencies: IDependencies
    private var input: PassthroughSubject<CharactersViewModel.Input, Never> = .init()
    private var nextPageUrl: String?
    private var cancellables = Set<AnyCancellable>()
    private var characters: [Character] = [] {
        didSet {
            self.collectionViewHeight.constant = (cellSize.height + 40) * CGFloat(characters.count)
            self.collectionView.reloadData()
        }
    }
    
    init(viewModel: CharactersViewModelProtocol, dependencies: IDependencies) {
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
        hideKeyboardOnTap()
        input.send(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    private func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: RunLoop.main)
            .sink { [weak self] output in
                switch output {
                case .loadBaseCharacters(isLoading: _):
                    break
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
                case .loadCharactersByName(isLoading: _):
                    break
                case .fetchCharactersByNameSucceed(characters: let characters, nextPageUrl: let nextPageUrl):
                    self?.characters = characters
                    self?.nextPageUrl = nextPageUrl
                }
            }
            .store(in: &cancellables)
        
        // Setup infiniteScroll binding
        scrollView.infiniteScrollDirection = .vertical
        scrollView.addInfiniteScroll { [weak self] collection in
            self?.input.send(.paginationRequest(nextPageUrl: self?.nextPageUrl))
        }
        
        // Setup textField binding
        searchTextField.textPublisher
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .removeDuplicates()
            .compactMap{ $0 }
            .sink { [weak self] searchString in
                self?.input.send(.searchRequest(searchString: searchString))
            }
            .store(in: &cancellables)
    }
    
    private func setupDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
}

//MARK: - Setup hiding keyboard on tap
extension CharactersViewController {
    private func hideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    @objc
    private func hideKeyboard() {
        self.view.endEditing(true)
    }
}

//MARK: - UICollectionViewDataSource
extension CharactersViewController: UICollectionViewDataSource {
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
extension CharactersViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = characters[indexPath.row]
        if let didSendCompletionEvent = didSendCompletionEvent {
            didSendCompletionEvent(.goToDetail(character))
        }
    }
    
}

//MARK: - CharactersViewController.Event
extension CharactersViewController {
    enum Event {
        case goToDetail(Character)
    }
}

//MARK: - UITextField Publisher
extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text  ?? "" }
            .eraseToAnyPublisher()
    }
}
