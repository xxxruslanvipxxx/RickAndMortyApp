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
    
    private let coordinator: DetailCoordinatorProtocol
    private let viewModel: DetailViewModelProtocol
    private let infoTypes = InfoType.allCases
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: DetailViewModelProtocol, coordinator: DetailCoordinatorProtocol) {
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
    }
    
    private func binding() {
        viewModel.characterPublisher
            .map { character in
                character.name
            }
            .sink(receiveValue: { name in
                self.nameLabel.text = name
            })
            .store(in: &cancellables)
    }
    
    private func setupDelegates() {
        infoTableView.dataSource = self
        infoTableView.delegate = self
    }

}

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        infoTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as? InfoTableViewCell else { fatalError("Failed to dequeue CharacterCell")
        }
        let infoType = infoTypes[indexPath.row]
        let character = viewModel.character
        cell.configure(with: character, infoType: infoType)
        
        return cell
    }
    
}


extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
}
