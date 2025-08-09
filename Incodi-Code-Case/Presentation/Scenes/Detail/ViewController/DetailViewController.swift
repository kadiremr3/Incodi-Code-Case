//
//  DetailViewController.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import UIKit
import SDWebImage

final class DetailViewController: UIViewController {
    
    private var viewModel: DetailViewModelProtocol!
    var user: GitHubUser!
    
    // MARK: - Properties
    private var isFavorite = false
    
    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 60
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 20
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = ColorSet.incodiBlue
        
        view.addSubview(avatarImageView)
        view.addSubview(usernameLabel)
        view.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 240),
            avatarImageView.heightAnchor.constraint(equalToConstant: 240),
            
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favoriteButton.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 40),
            favoriteButton.widthAnchor.constraint(equalToConstant: 180),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureData() {
        usernameLabel.text = user.login
        
        avatarImageView.sd_setImage(
            with: URL(string: user.avatar_url),
            placeholderImage: UIImage(systemName: "person.circle.fill")
        )
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        let title = isFavorite ? "Remove from Favorites" : "Add to Favorites"
        favoriteButton.setTitle(title, for: .normal)
        favoriteButton.backgroundColor = isFavorite ? .systemRed : .systemOrange
    }
    
    // MARK: - Actions
    @objc private func favoriteButtonTapped() {
        isFavorite.toggle()
        updateFavoriteButton()
    }
}
