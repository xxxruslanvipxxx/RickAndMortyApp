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
    private var viewModel: CharacterCellViewModelProtocol?
    private var input: PassthroughSubject<CharacterCellViewModel.Input, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    private var shadowLayer: CAShapeLayer!
    
    var isFavorite: Bool = false {
        didSet {
            if isFavorite{
                let image = UIImage(named: ImageName.heartFilled)
                addToFavoriteButton.setImage(image, for: .normal)
            } else {
                let image = UIImage(named: ImageName.heart)
                addToFavoriteButton.setImage(image, for: .normal)
            }
        }
    }
    
    //MARK: UI Variables
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: ImageName.systemPlaceholder)
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
        imageView.contentMode = .scaleAspectFit
        
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
    
    private lazy var addToFavoriteButton: UIButton = {
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
    
    private lazy var imageAndEpisodeStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [monitorPlayImageView, episodeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.distribution = .fill
        
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
        imageView.image = UIImage(systemName: ImageName.systemPlaceholder)
        characterNameLabel.text = nil
        cancellables.removeAll()
    }
    
    //MARK: configure()

    public func configure(viewModel: CharacterCellViewModelProtocol) {
        self.viewModel = viewModel
        binding()
        input.send(.configureCell)
        setupUI()
    }
    
    private func binding() {
        guard let output = viewModel?.transform(input: input.eraseToAnyPublisher()) else {
            print("cell binding error")
            return
        }
        
        output
            .receive(on: RunLoop.main)
            .sink { [weak self] output in
            switch output {
            case .configureImage(with: let data):
                guard let data = data, let image = UIImage(data: data) else {
                    self?.imageView.image = UIImage(named: ImageName.systemPlaceholder)
                    return
                }
                self?.imageView.image = image
            case .configureEpisode(with: let episode):
                self?.episodeLabel.text = episode
            case .configureName(with: let name):
                self?.characterNameLabel.text = name
            case .configureIsFavorite(with: let isFavorite):
                self?.isFavorite = isFavorite
            }
        }
        .store(in: &cancellables)
    }
    
    //MARK: Objc methods
    
    @objc
    private func heartButtonPressed(sender: UIButton) {
        isFavorite.toggle()
        input.send(.favoriteButtonPressed(isFavorite: isFavorite))
        addBounceAnimation(view: sender)
    }
    
    
    //MARK: UI Methods
    
    private func setupUI() {
        self.backgroundColor = UIColor(named: ColorName.customBackgroundColor)
        
        self.contentView.addSubview(finalStack)
        episodeBackgroundView.addSubview(imageAndEpisodeStack)
        episodeBackgroundView.addSubview(addToFavoriteButton)
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
        
        //MARK: characterNameLabel constraints
        let characterNameLabelLeading = characterNameLabel.leadingAnchor.constraint(equalTo: finalStack.leadingAnchor, constant: 16)
        let characterNameLabelTrailing = characterNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        
        NSLayoutConstraint.activate([characterNameLabelLeading, characterNameLabelTrailing])
        
        //MARK: episodeBackgroundView constraints
        let episodeBackgroundViewWidth = episodeBackgroundView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        let episodeBackgroundViewHeight = episodeBackgroundView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2)
        
        NSLayoutConstraint.activate([episodeBackgroundViewWidth, episodeBackgroundViewHeight])
        
        //MARK: imageAndEpisodeStack constraints
        let imageAndEpisodeStackTop = imageAndEpisodeStack.topAnchor.constraint(equalTo: episodeBackgroundView.topAnchor)
        let imageAndEpisodeStackLeading = imageAndEpisodeStack.leadingAnchor.constraint(equalTo: episodeBackgroundView.leadingAnchor, constant: 18)
//        let imageAndEpisodeStackTrailing = imageAndEpisodeStack.trailingAnchor.constraint(equalTo: addToFavoriteButton.leadingAnchor, constant: -18)
        let imageAndEpisodeStackBottom = imageAndEpisodeStack.bottomAnchor.constraint(equalTo: episodeBackgroundView.bottomAnchor)
        let imageAndEpisodeStackWidth = imageAndEpisodeStack.widthAnchor.constraint(equalTo: episodeBackgroundView.widthAnchor, multiplier: 0.75)
        
        NSLayoutConstraint.activate([imageAndEpisodeStackTop, imageAndEpisodeStackLeading, imageAndEpisodeStackWidth, imageAndEpisodeStackBottom])
        
        //MARK: addToFavoriteButton constraints
        let addToFavoriteButtonTrailing = addToFavoriteButton.trailingAnchor.constraint(equalTo: episodeBackgroundView.trailingAnchor, constant: -20)
        let addToFavoriteButtonTop = addToFavoriteButton.topAnchor.constraint(equalTo: episodeBackgroundView.topAnchor, constant: 18)
        let addToFavoriteButtonBottom = addToFavoriteButton.bottomAnchor.constraint(equalTo: episodeBackgroundView.bottomAnchor, constant: -18)
        
        NSLayoutConstraint.activate([addToFavoriteButtonTrailing, addToFavoriteButtonTop, addToFavoriteButtonBottom])
        
        //MARK: monitorPlayImageView constraints
        let monitorPlayImageViewWidth = monitorPlayImageView.widthAnchor.constraint(equalToConstant: 40)
        let monitorPlayImageViewHeight = monitorPlayImageView.heightAnchor.constraint(equalToConstant: 40)
        
        NSLayoutConstraint.activate([monitorPlayImageViewWidth, monitorPlayImageViewHeight])
        
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


//MARK: - Animations
extension CharacterCell {
    private func addBounceAnimation(view: UIView) {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {
            view.transform = CGAffineTransform.init(scaleX: 0.92, y: 0.92)
        }) { _ in
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: .curveEaseIn) {
                view.transform = CGAffineTransform.identity
            }
        }
    }
}
