//
//  BaseViewModel.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 12.08.2025.
//

class BaseViewModel: BaseViewModelProtocol {
    
    public var favouritesManager = FavouritesManager.shared
    
    func toggleFavourite(for user: GitHubUser) {
        if favouritesManager.isFavourite(user) {
            favouritesManager.removeFromFavourites(user)
        } else {
            favouritesManager.addToFavourites(user)
        }
    }
}
