//
//  DetailViewModel.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import Foundation

final class DetailViewModel: DetailViewModelProtocol {
    var detailCoordinator: DetailCoordinator!
    weak var delegate: DetailViewModelDelegate?
    
    init(coordinator: DetailCoordinator!) {
        self.detailCoordinator = coordinator
    }
    
    func fetchDetail(of user: String) throws {
        guard let url = URL(string: Constants.baseURL + "users/\(user)") else {
            throw URLError(.badURL)
        }
        
        Task {
            do {
                let user: GitHubUser = try await NetworkManager.shared.fetchData(with: url)
                delegate?.didFetchDetail(of: user)
            } catch {
                delegate?.didFailWithError(error)
            }
        }
    }
}
