//
//  HomeViewModelProtocol.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import Foundation

protocol HomeViewModelProtocol: BaseViewModelProtocol, AnyObject {
    var delegate: HomeViewModelDelegate? { get set }
    @MainActor
    func fetchGitHubUsers(with query: String) throws
    func navigateToDetail(with user: GitHubUser)
}
