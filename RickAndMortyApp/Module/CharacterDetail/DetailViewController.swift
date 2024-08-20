//
//  DetailViewController.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 7.08.24.
//

import UIKit
import Combine

enum InfoType: String, CaseIterable {
    case gender = "Gender"
    case status = "Status"
    case specie = "Specie"
    case origin = "Origin"
    case type = "Type"
    case location = "Location"
}

class DetailViewController: DetailUI{
    
    private var character: Character?
    private let viewModel: DetailViewModelProtocol
    private var input: PassthroughSubject<DetailViewModel.Input, Never> = .init()
    private var cancellables: Set<AnyCancellable> = []
    private let infoTypes = InfoType.allCases
    var didSendCompletionEvent: ((DetailViewController.Event) -> Void)?
    
    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupButtonAction()
        binding()
        input.send(.viewDidLoad)
    }
    
    private func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: RunLoop.main)
            .sink { [weak self] output in
                switch output {
                case .fetchCharacterImage(isLoading: let isLoading):
                    if isLoading {
                        // start animating
                    } else {
                        // stop animating
                    }
                case .updateCharacterInfo(character: let character):
                    self?.character = character
                    self?.nameLabel.text = character.name
                    self?.infoTableView.reloadData()
                case .updateImage(imageData: let imageData):
                    let image = UIImage(data: imageData)
                    self?.roundedImageView.image = image
                case .fetchDidFail(error: let error):
                    let image = UIImage(named: ImageName.systemQuestionmark)
                    self?.roundedImageView.image = image
                    print(error.localizedDescription)
                }
            }
            .store(in: &cancellables)
        
    }
    
    private func setupButtonAction() {
        photoButton.addTarget(self, action: #selector(photoButtonPressed), for: .touchUpInside)
    }
    
    private func setupDelegates() {
        infoTableView.dataSource = self
        infoTableView.delegate = self
    }
    
    @objc
    private func photoButtonPressed() {
        input.send(.photoButtonPressed)
    }

}

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        infoTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as? InfoTableViewCell else { fatalError("Failed to dequeue CharacterCell")
        }
        guard let character = character else { return cell }
        
        let infoType = infoTypes[indexPath.row]
        cell.configure(with: character, infoType: infoType)
        
        return cell
    }
    
}

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
}

//MARK: - DetailViewController.Event
extension DetailViewController {
    enum Event {
        case goToPhotoScreen
    }
}
