//
//  DetailViewModelProtocol.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import Foundation

protocol DetailViewModelProtocol: BaseViewModelProtocol {
    @MainActor
    func fetchDetail(of user: String) throws
    func toggleFavourite(for user: GitHubUser)
}
