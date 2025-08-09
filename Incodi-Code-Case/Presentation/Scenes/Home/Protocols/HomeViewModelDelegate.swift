//
//  HomeViewModelDelegate.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 8.08.2025.
//

@MainActor
protocol HomeViewModelDelegate: AnyObject {
    func didFetchUsers(_ users: [GitHubUser])
    func didFailWithError(_ error: Error)
}
