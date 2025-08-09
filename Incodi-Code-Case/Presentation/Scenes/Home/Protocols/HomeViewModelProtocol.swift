//
//  HomeViewModelProtocol.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    var delegate: HomeViewModelDelegate? { get set }
    func navigateToDetail(with user: GitHubUser)
    @MainActor
    func fetchGitHubUsers(with query: String) throws
}
