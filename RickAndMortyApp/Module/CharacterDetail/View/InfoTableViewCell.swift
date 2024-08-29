//
//  InfoTableViewCell.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 10.08.24.
//

import UIKit

//MARK: - InfoTableViewCell
class InfoTableViewCell: UITableViewCell {

    static let identifier = "infoTableCell"
    
    //MARK: Internal Variables
    var infoTypeString: String?
    var infoString: String?
    
    //MARK: UI Variables
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [infoTypeLabel, infoLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        
        return stackView
    }()
    
    private lazy var infoTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor(named: ColorName.mainDark)
        label.textAlignment = .left
        label.text = infoTypeString
        
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .left
        label.text = infoString
        
        return label
    }()
    
    //MARK: configure()
    public func configure(with character: Character, infoType: InfoType) {
        self.infoTypeString = infoType.rawValue
        switch infoType {
        case .gender:
            self.infoString = character.gender.rawValue
        case .status:
            self.infoString = character.status.rawValue
        case .specie:
            self.infoString = character.species
        case .origin:
            self.infoString = character.origin.name
        case .type:
            self.infoString = character.type != "" ? character.type : "Unknown"
        case .location:
            self.infoString = character.location.name
        }
        setupUI()
    }
    
    //MARK: UI Methods
    private func setupUI() {
        self.backgroundColor = UIColor(named: ColorName.customBackgroundColor)
        
        self.contentView.addSubview(stackView)
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        
        //MARK: finalStack constraints
        let stackViewTop = stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
        let stackViewLeading = stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        let stackViewTrailing = stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        let stackViewBottom = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        
        NSLayoutConstraint.activate([stackViewTop, stackViewLeading, stackViewTrailing, stackViewBottom])

    }
    
}
