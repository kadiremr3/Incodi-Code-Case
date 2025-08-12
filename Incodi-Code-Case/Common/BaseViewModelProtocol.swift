//
//  BaseViewModelProtocol.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 12.08.2025.
//

public protocol BaseViewModelProtocol {
    var favouritesManager: FavouritesManager { get set }
    func toggleFavourite(for user: GitHubUser)
}
