//
//  DetailViewController.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 7.08.24.
//

import UIKit

class DetailViewController: DetailUI {
    
    let viewModel: DetailViewModelProtocol
    
    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
