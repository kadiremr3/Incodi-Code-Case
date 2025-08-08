//
//  HomeViewController.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    
    // MARK: - Variables
    
    private var searchText = PassthroughSubject<String, Never>()
    private var cancellable: AnyCancellable?
    
    private var searchArray: [GitHubUser] = []
    private var isSearchTextEmpty: Bool = true
    
    private var viewModel: HomeViewModelProtocol!
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
    
    private lazy var searchView: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = String(localized: "Dashboard.SearchText")
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 90, height: 180)
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: Constants.GitHubUserCell, bundle: nil), forCellWithReuseIdentifier: Constants.GitHubUserCell)
        return collectionView
    }()
    
    private lazy var collectionViewErrorMessageLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "Dashboard.ResultNotFound")
        label.textColor = .lightGray
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .orange
        indicator.frame(forAlignmentRect: CGRect(x: view.frame.width / 2,
                                                 y: view.frame.height / 2,
                                                 width: 50,
                                                 height: 50))
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneUI()
        viewModel.delegate = self
        addViews()
        setupConstraints()
        setupSearchWithDebounce()
    }
    
    // MARK: - UI
    
    private func setupSceneUI() {
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func addViews() {
        view.addSubview(searchView)
        view.addSubview(collectionView)
        view.addSubview(collectionViewErrorMessageLabel)
        view.addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchView.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            
            collectionViewErrorMessageLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            collectionViewErrorMessageLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: -30),
            
            activityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
    }
    
    // MARK: - Other Methods
    
    private func setupSearchWithDebounce() {
        cancellable = searchText
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { [weak self] query in
                self?.activityIndicator.startAnimating()
                do {
                    try self?.viewModel.fetchGitHubUsers(with: query)
                } catch {
                    print("Fetch error: \(error)")
                }
            })
    }
}

// MARK: - Extensions

extension HomeViewController: HomeViewModelDelegate {
    func didFetchUsers(_ users: [GitHubUser]) {
        self.collectionView.reloadData()
        self.collectionViewErrorMessageLabel.isHidden = true
        self.activityIndicator.stopAnimating()
        self.searchArray.append(contentsOf: users)
    }
    
    func didFailWithError(_ error: any Error) {
        self.collectionView.reloadData()
        self.activityIndicator.stopAnimating()
        if self.searchArray.count == 0 || !self.isSearchTextEmpty {
            self.collectionViewErrorMessageLabel.isHidden = false
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        if searchText == "" {
            self.searchArray = []
            self.collectionView.reloadData()
            self.collectionViewErrorMessageLabel.isHidden = true
            self.isSearchTextEmpty = true
        } else {
            self.searchText.send(searchText)
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return self.searchArray.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.GitHubUserCell, for: indexPath) as! GitHubUserCollectionViewCell
        let user = searchArray[indexPath.row]
        cell.configure(
            name: user.login,
            avatarURL: URL(string: user.avatar_url),
            isFavourite: true
        )
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        self.viewModel.navigateToDetail()
    }
}
