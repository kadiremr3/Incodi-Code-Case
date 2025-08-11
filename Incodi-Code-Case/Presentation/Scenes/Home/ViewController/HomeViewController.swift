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
    private var isLoading: Bool = false
    
    private var viewModel: HomeViewModelProtocol!
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneUI()
        viewModel.delegate = self
        addViews()
        setupConstraints()
        setupSearchWithDebounce()
    }
    
    // MARK: - Views
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorSet.incodiBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var searchView: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = String(localized: "Search GitHub users...")
        searchBar.delegate = self
        searchBar.backgroundColor = .clear
        searchBar.barTintColor = .clear
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.borderStyle = .none
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        searchBar.searchTextField.textColor = .label
        
        let searchIcon = UIImage(systemName: "magnifyingglass")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        searchBar.setImage(searchIcon, for: .search, state: .normal)
        
        return searchBar
    }()
    
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
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 32, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: Constants.GitHubUserCell, bundle: nil), forCellWithReuseIdentifier: Constants.GitHubUserCell)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        return collectionView
    }()
    
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 64, weight: .light)
        iconImageView.image = UIImage(systemName: "person.2.fill", withConfiguration: config)
        iconImageView.tintColor = ColorSet.incodiOrange
        iconImageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = "No Users Found"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        let messageLabel = UILabel()
        messageLabel.text = "Try searching for a different username"
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        messageLabel.textColor = .lightGray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 64),
            iconImageView.widthAnchor.constraint(equalToConstant: 64),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -90),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -32)
        ])
        
        return view
    }()
    
    private lazy var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorSet.incodiBlue.withAlphaComponent(0.9)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = ColorSet.incodiOrange
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Searching..."
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityIndicator)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 12)
        ])
        
        return view
    }()
    
    // MARK: - UI Setup
    
    private func setupSceneUI() {
        view.backgroundColor = ColorSet.incodiBlue
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    private func addViews() {
        view.addSubview(headerView)
        headerView.addSubview(searchContainerView)
        searchContainerView.addSubview(searchView)
        
        view.addSubview(collectionView)
        view.addSubview(emptyStateView)
        view.addSubview(loadingView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 140),
            
            searchContainerView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            searchContainerView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            searchContainerView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -24),
            searchContainerView.heightAnchor.constraint(equalToConstant: 48),
            
            searchView.topAnchor.constraint(equalTo: searchContainerView.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 8),
            searchView.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -8),
            searchView.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            
            emptyStateView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSearchWithDebounce() {
        cancellable = searchText
            .debounce(for: .seconds(0.8), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { [weak self] query in
                self?.performSearch(query: query)
            })
    }
    
    // MARK: - Actions
    
    private func performSearch(query: String) {
        guard !query.isEmpty else { return }
        
        isLoading = true
        loadingView.isHidden = false
        emptyStateView.isHidden = true
        
        do {
            try viewModel.fetchGitHubUsers(with: query)
        } catch {
            print("Fetch error: \(error)")
            handleSearchError()
        }
    }
    
    private func handleSearchError() {
        isLoading = false
        loadingView.isHidden = true
        
        if searchArray.isEmpty {
            emptyStateView.isHidden = false
        }
    }
    
    @objc private func refreshData() {
        guard let searchText = searchView.text, !searchText.isEmpty else {
            collectionView.refreshControl?.endRefreshing()
            return
        }
        
        searchArray.removeAll()
        collectionView.reloadData()
        performSearch(query: searchText)
    }
}

// MARK: - Extensions

extension HomeViewController: HomeViewModelDelegate {
    func didFetchUsers(_ users: [GitHubUser]) {
        isLoading = false
        loadingView.isHidden = true
        collectionView.refreshControl?.endRefreshing()
        
        searchArray.append(contentsOf: users)
        emptyStateView.isHidden = !searchArray.isEmpty
        
        DispatchQueue.main.async() { [weak self] in
         guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
    
    func didFailWithError(_ error: any Error) {
        isLoading = false
        loadingView.isHidden = true
        collectionView.refreshControl?.endRefreshing()
        
        if searchArray.isEmpty && !isSearchTextEmpty {
            emptyStateView.isHidden = false
        }
        
        showErrorToast()
    }
    
    private func showErrorToast() {
        let alertController = UIAlertController(title: "Search Error", message: "Failed to fetch users. Please try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchArray.removeAll()
            collectionView.reloadData()
            emptyStateView.isHidden = true
            isSearchTextEmpty = true
        } else {
            isSearchTextEmpty = false
            if !isLoading {
                searchArray.removeAll()
                collectionView.reloadData()
            }
            self.searchText.send(searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.GitHubUserCell, for: indexPath) as! GitHubUserCollectionViewCell
        let user = searchArray[indexPath.row]
        cell.delegate = self
        cell.configure(
            with: user,
            isFavourite: viewModel.isFavourite(user)
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let user = searchArray[indexPath.row]
        viewModel.navigateToDetail(with: user)
    }
}

extension HomeViewController: GitHubUserCellDelegate {
    func gitHubUserCellDidTapFavourite(
        _ cell: GitHubUserCollectionViewCell,
        for user: GitHubUser
    ) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        viewModel.toggleFavourite(for: user)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
                self.collectionView.reloadItems(at: [indexPath])
        }
        
    }
}
