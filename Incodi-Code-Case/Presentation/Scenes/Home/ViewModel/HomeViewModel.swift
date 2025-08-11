//
//  HomeViewModel.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import Foundation

final class HomeViewModel: HomeViewModelProtocol {
    
    weak var delegate: HomeViewModelDelegate?
    var homeCoordinator: HomeCoordinator!
    var favouritesManager = FavouritesManager.shared
    
    init(coordinator: HomeCoordinator!) {
        self.homeCoordinator = coordinator
    }
    
    @MainActor
    func fetchGitHubUsers(with query: String) throws {
        guard let url = URL(string: Constants.searchURL + "\(query)") else {
            throw URLError(.badURL)
        }
        
        Task {
            do {
                let fetchedUsers: SearchResponse = try await NetworkManager.shared.fetchData(with: url)
                delegate?.didFetchUsers(fetchedUsers.items)
            } catch {
                delegate?.didFailWithError(error)
            }
        }
    }
    
    func toggleFavourite(for user: GitHubUser) {
        if favouritesManager.isFavourite(user) {
            favouritesManager.removeFromFavourites(user)
        } else {
            favouritesManager.addToFavourites(user)
        }
    }
    
    func isFavourite(_ user: GitHubUser) -> Bool {
        return favouritesManager.isFavourite(user)
    }
    
    func navigateToDetail(with user: GitHubUser) {
        homeCoordinator.navigateToDetail(with: user)
    }
}
