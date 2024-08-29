//
//  DetailViewController.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 7.08.24.
//

import UIKit
import Combine
import Photos
import PhotosUI

//MARK: - InfoType
enum InfoType: String, CaseIterable {
    case gender = "Gender"
    case status = "Status"
    case specie = "Specie"
    case origin = "Origin"
    case type = "Type"
    case location = "Location"
}

//MARK: - DetailViewController
class DetailViewController: DetailUI{
    
    //MARK: Public
    var didSendCompletionEvent: ((DetailViewController.Event) -> Void)?
    
    //MARK: Private
    private var character: Character?
    private let viewModel: DetailViewModelProtocol
    private var input: PassthroughSubject<DetailViewModel.Input, Never> = .init()
    private var cancellables: Set<AnyCancellable> = []
    private let infoTypes = InfoType.allCases
    
    //MARK: Lifecycle methods
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
    
    //MARK: - binding()
    private func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: RunLoop.main)
            .sink { [weak self] output in
                switch output {
                case .fetchCharacterImage(isLoading: let isLoading):
                    // control loading animation
                    break
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
                case .showCamera:
                    self?.showPicker(for: .camera)
                case .showPhotoLibrary:
                    self?.showPicker(for: .photoLibrary)
                }
            }
            .store(in: &cancellables)
    }
    
    //MARK: setupDelegates()
    private func setupDelegates() {
        infoTableView.dataSource = self
        infoTableView.delegate = self
    }
    
    //MARK: showActionSheet()
    private func showActionSheet() {
        let controller = UIAlertController(title: ConstantText.actionSheetTitle, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: ConstantText.actionSheetButtonCamera, style: .default) { action in
            self.input.send(.changePhoto(sourceType: .camera))
        }
        let galleryAction = UIAlertAction(title: ConstantText.actionSheetButtonGallery, style: .default) { action in
            self.input.send(.changePhoto(sourceType: .photoLibrary))
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        controller.addAction(cameraAction)
        controller.addAction(galleryAction)
        controller.addAction(cancelAction)
        present(controller, animated: true)
        
    }
    
    //MARK: showPicker()
    private func showPicker(for sourceType: DetailViewModel.PhotoSourceType) {
        switch sourceType {
        case .camera:
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.delegate = self
            vc.allowsEditing = true
            
            present(vc, animated: true)
        case .photoLibrary:
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.mode = .default
            config.filter = .images
            config.selectionLimit = 1
            let vc = PHPickerViewController(configuration: config)
            vc.delegate = self
            
            present(vc, animated: true)
        }
    }
    
    private func setupButtonAction() {
        photoButton.addTarget(self, action: #selector(photoButtonPressed), for: .touchUpInside)
    }
    
    @objc
    private func photoButtonPressed() {
        showActionSheet()
    }

}

//MARK: - PHPickerViewControllerDelegate
extension DetailViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.roundedImageView.image = image
                    }
                }
            }
        }
        
    }
    
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let key = UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")
        if let image = info[key] as? UIImage {
            roundedImageView.image = image
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}

//MARK: - UITableViewDataSource
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

//MARK: - UITableViewDelegate
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
