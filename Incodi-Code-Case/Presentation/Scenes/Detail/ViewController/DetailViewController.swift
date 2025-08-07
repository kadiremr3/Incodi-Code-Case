//
//  DetailViewController.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import UIKit

final class DetailViewController: UIViewController {
    private var viewModel: DetailViewModelProtocol!
    
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
