//
//  HomeViewModel.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import Foundation

final class HomeViewModel: HomeViewModelProtocol {
    
    var homeCoordinator: HomeCoordinator!
    
    init(coordinator: HomeCoordinator!) {
        self.homeCoordinator = coordinator
    }
}
