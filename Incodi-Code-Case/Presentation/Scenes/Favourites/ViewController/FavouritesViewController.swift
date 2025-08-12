//
//  FavouritesViewController.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import UIKit

final class FavouritesViewController: UIViewController {

    private var favourites: [GitHubUser] = []
    private let favouritesManager = FavouritesManager.shared

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 120, height: 180)
        flowLayout.minimumLineSpacing = 4
        flowLayout.minimumInteritemSpacing = 4
        flowLayout.sectionInset = .zero
        flowLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: Constants.GitHubUserCell, bundle: nil),
                                 forCellWithReuseIdentifier: Constants.GitHubUserCell)
        return collectionView
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorSet.incodiBlack
        setupCollectionView()
        loadFavourites()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavourites()
    }

    // MARK: - UI
    private func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Other Methods
    private func loadFavourites() {
        favourites = favouritesManager.favourites
        collectionView.reloadData()
    }
}

// MARK: - Extensions

extension FavouritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favourites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.GitHubUserCell,
            for: indexPath
        ) as! GitHubUserCollectionViewCell
        
        let user = favourites[indexPath.row]
        cell.delegate = self
        cell.configure(with: user, isFavourite: true)
        return cell
    }
}

extension FavouritesViewController: GitHubUserCellDelegate {
    func gitHubUserCellDidTapFavourite(_ cell: GitHubUserCollectionViewCell, for user: GitHubUser) {
        let alert = UIAlertController(
            title: "Remove from Favourites".localized.capitalized,
            message: "Remove [PARAM] from favourites?".localized.replacingOccurrences(of: "[PARAM]", with: user.login),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok".localized, style: .destructive, handler: { [weak self] _ in
            guard let self else { return }
            self.favouritesManager.removeFromFavourites(user)
            self.loadFavourites()
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
