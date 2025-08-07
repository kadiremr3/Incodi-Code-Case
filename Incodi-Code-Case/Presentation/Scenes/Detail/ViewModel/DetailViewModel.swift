//
//  DetailViewModel.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import Foundation

final class DetailViewModel: DetailViewModelProtocol {
    
    var detailCoordinator: DetailCoordinator!
    
    init(coordinator: DetailCoordinator!) {
        self.detailCoordinator = coordinator
    }
}
