//
//  FavouritesManager.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 10.08.2025.
//

import Foundation
import Combine

protocol FavouritesManagerProtocol {
    var favourites: [GitHubUser] { get }
    func loadFavourites()
    func addToFavourites(_ user: GitHubUser)
    func removeFromFavourites(_ user: GitHubUser)
}

public final class FavouritesManager: FavouritesManagerProtocol {
    static let shared = FavouritesManager()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    private let favouritesKey = "FavoriteUsers"
    
    @Published private(set) var favourites: [GitHubUser] = []
    
    func loadFavourites() {
        if let data = userDefaults.data(forKey: favouritesKey),
           let users = try? JSONDecoder().decode([GitHubUser].self, from: data) {
            self.favourites = users
        }
    }
    
    func addToFavourites(_ user: GitHubUser) {
        guard !favourites.contains(where: { $0.id == user.id }) else { return }
        favourites.append(user)
        saveFavourites()
    }
    
    func removeFromFavourites(_ user: GitHubUser) {
        favourites.removeAll { $0.id == user.id }
        saveFavourites()
    }

    func isFavourite(_ user: GitHubUser) -> Bool {
        return favourites.contains(where: { $0.id == user.id })
    }
    
    private func saveFavourites() {
        if let data = try? JSONEncoder().encode(favourites) {
            userDefaults.set(data, forKey: favouritesKey)
        }
    }
}
