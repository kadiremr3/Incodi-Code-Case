//
//  GithubUser.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 8.08.2025.
//

public struct GitHubUser: Codable {
    let login: String
    let id: Int
    let avatar_url: String
    let html_url: String
}
