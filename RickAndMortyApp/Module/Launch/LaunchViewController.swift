//
//  LaunchViewController.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 5.07.24.
//

import UIKit

class LaunchViewController: UIViewController {
    
    private lazy var logoImageView: UIImageView = {
        let image = UIImage(named: ImageName.appLogo)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var loadingImageView: UIImageView = {
        let image = UIImage(named: ImageName.loadingComponent)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        startLoadingAnimation()
    }
    
    private func setupUI() {
        
        view.backgroundColor = UIColor(named: ColorName.customBackgroundColor)
        
        // logoImageView constraints layout
        view.addSubview(logoImageView)
        
        let logoImageViewCenterX = logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        let logoImageViewTop = logoImageView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 97)
        let logoImageViewWidth = logoImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8)
        let logoImageViewHeight = logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 1/3)
        
        NSLayoutConstraint.activate([logoImageViewCenterX, logoImageViewTop, logoImageViewWidth, logoImageViewHeight])
        
        // loadingImageView constraints layout
        view.addSubview(loadingImageView)
        
        let loadingImageViewCenterX = loadingImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        let loadingImageViewTop = loadingImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        let loadingImageViewWidth = loadingImageView.widthAnchor.constraint(equalToConstant: 250)
        let loadingImageViewHeight = loadingImageView.heightAnchor.constraint(equalToConstant: 250)
        
        NSLayoutConstraint.activate([loadingImageViewCenterX, loadingImageViewTop, loadingImageViewWidth, loadingImageViewHeight])
    }
    
    func startLoadingAnimation(with duration: CFTimeInterval = 3) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = Float.infinity
        loadingImageView.layer.add(rotateAnimation, forKey: nil)
    }
    
    func stopAnimation() {
        loadingImageView.layer.removeAllAnimations()
    }
    
}
