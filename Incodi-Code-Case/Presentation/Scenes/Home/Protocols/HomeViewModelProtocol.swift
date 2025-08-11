//
//  HomeViewModelProtocol.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    var delegate: HomeViewModelDelegate? { get set }
    @MainActor
    func fetchGitHubUsers(with query: String) throws
    func toggleFavourite(for user: GitHubUser)
    func isFavourite(_ user: GitHubUser) -> Bool
    func navigateToDetail(with user: GitHubUser)
}
