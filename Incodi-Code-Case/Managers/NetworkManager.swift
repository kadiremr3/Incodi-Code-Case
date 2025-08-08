//
//  NetworkManager.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 8.08.2025.
//

import Foundation

enum DataError: Error {
    case invalidData
    case invalidResponse
    case message(_ error: Error?)
}

public class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData<T: Codable>(with url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw DataError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw DataError.message(error)
        }
    }
}
