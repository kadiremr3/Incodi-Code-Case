//
//  DetailViewModelDelegate.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 9.08.2025.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject {
    func didFetchDetail(of user: GitHubUser)
    func didFailWithError(_ error: Error)
}
