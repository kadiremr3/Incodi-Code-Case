//
//  SplashViewController.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    private var viewModel: SplashViewModelProtocol!
    
    init(viewModel: SplashViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var splashTitle: UILabel = {
        let label = UILabel()
        label.text = "Incodi Code Case"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = ColorSet.incodiBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorSet.incodiOrange
        view.addSubview(splashTitle)
        setupConstraints()
        viewModel.favouritesManager.loadFavourites()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.viewModel.navigateToHome()
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            splashTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60)
        ])
    }
    
}
