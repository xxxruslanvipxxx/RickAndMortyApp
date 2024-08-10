//
//  EpisodeCell.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 10.07.24.
//

import UIKit
import Combine

class CharacterCell: UICollectionViewCell {
    
    static let identifier = "episodesCell"
    
    //MARK: Variables
    
    private var shadowLayer: CAShapeLayer!
    
    var isFavourite: Bool = false {
        didSet {
            if isFavourite{
                let image = UIImage(named: ImageName.heartFilled)
                addToFavouriteButton.setImage(image, for: .normal)
            } else {
                let image = UIImage(named: ImageName.heart)
                addToFavouriteButton.setImage(image, for: .normal)
            }
            print(isFavourite)
        }
    }
    
    //MARK: UI Variables
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: ImageName.systemQuestionmark)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var characterNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private lazy var monitorPlayImageView: UIImageView = {
        let image = UIImage(named: ImageName.monitorPlay)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .right
        
        return imageView
    }()
    
    private lazy var episodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pilot | S01E01"
        label.textAlignment = .left
        label.font = UIFont(name: "Inter", size: 16)
        
        return label
    }()
    
    private lazy var addToFavouriteButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: ImageName.heart)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(heartButtonPressed) , for: .touchUpInside)
        
        return button
    }()
    
    private lazy var episodeBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(_colorLiteralRed: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    private lazy var episodeAndFavouritesStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [monitorPlayImageView, episodeLabel, addToFavouriteButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        
        return stackView
    }()
    
    private lazy var finalStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, characterNameLabel, episodeBackgroundView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        
        return stackView
    }()
    
    //MARK: prepareForReuse()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // nil image and other ui props
        imageView.image = UIImage(systemName: ImageName.systemPlaceholder)
    }
    
    //MARK: configure()

    public func configure(with character: Result, image: UIImage) {
        self.imageView.image = image
        self.characterNameLabel.text = character.name
//        self.episodeLabel.text = character.
        setupUI()
    }
    
    func updateImage(_ image: UIImage) {
        self.imageView.image = image
    }
    
    //MARK: Objc methods
    
    @objc
    private func heartButtonPressed() {
        isFavourite.toggle()
    }
    
    
    //MARK: UI Methods
    
    private func setupUI() {
        self.backgroundColor = UIColor(named: ColorName.customBackgroundColor)
        
        self.contentView.addSubview(finalStack)
        episodeBackgroundView.addSubview(episodeAndFavouritesStack)
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        
        //MARK: finalStack constraints
        let finalStackTop = finalStack.topAnchor.constraint(equalTo: contentView.topAnchor)
        let finalStackLeading = finalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        let finalStackTrailing = finalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let finalStackBottom = finalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        NSLayoutConstraint.activate([finalStackTop, finalStackLeading, finalStackTrailing, finalStackBottom])
        
        //MARK: imageView constraints
        let imageViewWidth = imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        let imageViewHeight = imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.65)
        
        NSLayoutConstraint.activate([imageViewWidth, imageViewHeight])
        
        //MARK: episodeBackgroundView constraints
        let episodeBackgroundViewWidth = episodeBackgroundView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        let episodeBackgroundViewHeight = episodeBackgroundView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2)
        
        NSLayoutConstraint.activate([episodeBackgroundViewWidth, episodeBackgroundViewHeight])
        
        //MARK: episodeAndFavouritesStack constraints
        let episodeAndFavouritesStackTop = episodeAndFavouritesStack.topAnchor.constraint(equalTo: episodeBackgroundView.topAnchor)
        let episodeAndFavouritesStackLeading = episodeAndFavouritesStack.leadingAnchor.constraint(equalTo: episodeBackgroundView.leadingAnchor)
        let episodeAndFavouritesStackTrailing = episodeAndFavouritesStack.trailingAnchor.constraint(equalTo: episodeBackgroundView.trailingAnchor)
        let episodeAndFavouritesStackBottom = episodeAndFavouritesStack.bottomAnchor.constraint(equalTo: episodeBackgroundView.bottomAnchor)
        
        NSLayoutConstraint.activate([episodeAndFavouritesStackTop, episodeAndFavouritesStackLeading, episodeAndFavouritesStackTrailing, episodeAndFavouritesStackBottom])
        
        //MARK: characterNameLabel constraints
        let characterNameLabelLeading = characterNameLabel.leadingAnchor.constraint(equalTo: finalStack.leadingAnchor, constant: 16)
        let characterNameLabelTrailing = characterNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        
        NSLayoutConstraint.activate([characterNameLabelLeading, characterNameLabelTrailing])
        
//        //MARK: monitorPlayImageView constraints
//        let monitorPlayImageViewWidth = monitorPlayImageView.widthAnchor.constraint(equalToConstant: 26)
//        let monitorPlayImageViewHeight = monitorPlayImageView.heightAnchor.constraint(equalToConstant: 26)
//        
//        NSLayoutConstraint.activate([monitorPlayImageViewWidth, monitorPlayImageViewHeight])

    }
    
}

//MARK: - Setup shadows
extension CharacterCell {
    
    override func layoutSubviews() {
            super.layoutSubviews()

            if shadowLayer == nil {
                shadowLayer = CAShapeLayer()
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 4).cgPath
                
                shadowLayer.fillColor = UIColor.white.cgColor

                shadowLayer.shadowColor = UIColor.darkGray.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: 0, height: 2.0)
                shadowLayer.shadowOpacity = 0.7
                shadowLayer.shadowRadius = 3

                layer.insertSublayer(shadowLayer, at: 0)
            }
        }
    
}
