//
//  EpisodeCell.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 10.07.24.
//

import UIKit

class CharacterCell: UICollectionViewCell {
    
    static let identifier = "episodesCell"
    
    //MARK: Variables
    
    var isFavourite: Bool = false {
        didSet {
            if isFavourite{
                let image = UIImage(named: ImageName.heartFilled)
                heartButton.setImage(image, for: .normal)
            } else {
                let image = UIImage(named: ImageName.heart)
                heartButton.setImage(image, for: .normal)
            }
            print(isFavourite)
        }
    }
    
    //MARK: UI Variables
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: ImageName.systemQuestionmark)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .yellow
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var characterNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Rick Sanchez"
        label.textAlignment = .natural
        label.font = UIFont(name: "Roboto", size: 20)
//        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return label
    }()
    
    private lazy var monitorPlayImageView: UIImageView = {
        let image = UIImage(named: ImageName.monitorPlay)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
//        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return imageView
    }()
    
    private lazy var episodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pilot | S01E01"
        label.textAlignment = .left
        label.font = UIFont(name: "Inter", size: 16)
//        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private lazy var heartButton: UIButton = {
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
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    private lazy var episodeAndFavouritesStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [monitorPlayImageView, episodeLabel, heartButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        
        return stackView
    }()
    
    private lazy var finalStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, episodeBackgroundView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        
        return stackView
    }()
    
    //MARK: prepareForReuse()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // nil to image and ather ui props
        imageView.image = nil
    }
    
    //MARK: configure()
    
    // config method (later need to pass person model here)
    public func configure(with image: UIImage?) {
        self.imageView.image = image
        setupUI()
    }
    
    //MARK: Objc methods
    
    @objc
    private func heartButtonPressed() {
        isFavourite.toggle()
    }
    
    
    //MARK: UI Methods
    
    private func setupUI() {
        self.backgroundColor = .systemBlue
        
        self.contentView.addSubview(finalStack)
        episodeBackgroundView.addSubview(episodeAndFavouritesStack)
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        
        //MARK: episodeAndFavouritesStack constraints
        let episodeAndFavouritesStackTop = episodeAndFavouritesStack.topAnchor.constraint(equalTo: episodeBackgroundView.topAnchor)
        let episodeAndFavouritesStackLeading = episodeAndFavouritesStack.leadingAnchor.constraint(equalTo: episodeBackgroundView.leadingAnchor)
        let episodeAndFavouritesStackTrailing = episodeAndFavouritesStack.trailingAnchor.constraint(equalTo: episodeBackgroundView.trailingAnchor)
        let episodeAndFavouritesStackBottom = episodeAndFavouritesStack.bottomAnchor.constraint(equalTo: episodeBackgroundView.bottomAnchor)
        
        NSLayoutConstraint.activate([episodeAndFavouritesStackTop,
                                     episodeAndFavouritesStackLeading,
                                     episodeAndFavouritesStackTrailing,
                                     episodeAndFavouritesStackBottom])
        
        //MARK: finalStack constraints
        let finalStackTop = finalStack.topAnchor.constraint(equalTo: contentView.topAnchor)
        let finalStackLeading = finalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        let finalStackTrailing = finalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let finalStackBottom = finalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        NSLayoutConstraint.activate([finalStackTop,
                                     finalStackLeading,
                                     finalStackTrailing,
                                     finalStackBottom])
        
        //MARK: imageView constraints
        let imageViewWidth = imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        let imageViewHeight = imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75)
       
        NSLayoutConstraint.activate([imageViewWidth,
                                     imageViewHeight])
        
        //MARK: episodeBackgroundView constraints
        let episodeBackgroundViewWidth = episodeBackgroundView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        let episodeBackgroundViewHeight = episodeBackgroundView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2)
        
        NSLayoutConstraint.activate([episodeBackgroundViewWidth])
        
        //MARK: characterNameLabel constraints
//        let characterNameLabelHeight = characterNameLabel.heightAnchor.constraint(equalToConstant: 50)
//        let characterNameLabelWidth = characterNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        
//        NSLayoutConstraint.activate([characterNameLabelWidth])
        
//        let episodeBackgroundViewHeight = episodeBackgroundView.heightAnchor.constraint(equalToConstant: 70)
//        NSLayoutConstraint.activate([episodeBackgroundViewHeight])

    }
    
}
