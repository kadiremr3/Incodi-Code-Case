//
//  DetailViewController.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import UIKit
import SDWebImage

final class DetailViewController: UIViewController {
    
    // MARK: - Variables
    
    private var viewModel: DetailViewModelProtocol!
    private var attributedLinkString: NSMutableAttributedString!
    var user: GitHubUser!
    
    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureData()
    }
    
    // MARK: - UI
    
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
    
    private lazy var linkTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .link
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.font = .systemFont(ofSize: 18, weight: .medium)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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
    
    private func setupUI() {
        view.backgroundColor = ColorSet.incodiBlue
        view.addSubview(avatarImageView)
        view.addSubview(usernameLabel)
        view.addSubview(linkTextView)
        view.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 240),
            avatarImageView.heightAnchor.constraint(equalToConstant: 240),
            
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            linkTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            linkTextView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 24),
            linkTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            linkTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favoriteButton.topAnchor.constraint(equalTo: linkTextView.bottomAnchor, constant: 48),
            favoriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favoriteButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Other Methods
    private func configureData() {
        usernameLabel.text = user.login
        linkTextView.text = user.html_url
        avatarImageView.sd_setImage(
            with: URL(string: user.avatar_url),
            placeholderImage: UIImage(systemName: "person.circle.fill")
        )
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        let title = viewModel.favouritesManager.isFavourite(user) ? "Remove from Favourites".localized : "Add to Favourites".localized
        favoriteButton.setTitle(title, for: .normal)
        favoriteButton.backgroundColor = viewModel.favouritesManager.isFavourite(user) ? .systemRed : .systemOrange
    }
    
    // MARK: - Actions
    @objc private func favoriteButtonTapped() {
        viewModel.toggleFavourite(for: user)
        updateFavoriteButton()
    }
}
