//
//  EpisodeCell.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 10.07.24.
//

import UIKit

class EpisodeCell: UICollectionViewCell {
    
    static let identifier = "episodesCell"
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "questionmark")
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .yellow
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // nil to image and ather ui props
        imageView.image = nil
    }
    
    public func configure(with image: UIImage?) {
        self.imageView.image = image
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = .systemBlue
        
        self.addSubview(imageView)
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        // imageView constraints
        let imageViewTop = imageView.topAnchor.constraint(equalTo: self.topAnchor)
        let imageViewLeading = imageView.leftAnchor.constraint(equalTo: self.leftAnchor)
        let imageViewTrailing = imageView.rightAnchor.constraint(equalTo: self.rightAnchor)
        let imageViewHeight = imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75)
        
        NSLayoutConstraint.activate([imageViewTop, imageViewLeading, imageViewTrailing, imageViewHeight])
    }
    
}
