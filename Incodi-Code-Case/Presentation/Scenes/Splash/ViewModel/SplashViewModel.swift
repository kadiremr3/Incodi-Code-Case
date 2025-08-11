//
//  SplashViewModel.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import Foundation

final class SplashViewModel: BaseViewModel, SplashViewModelProtocol {
    
    private var splashCoordinator: SplashCoordinator
    
    init(coordinator: SplashCoordinator) {
        self.splashCoordinator = coordinator
    }
    
    func navigateToHome() {
        splashCoordinator.navigateToHome()
    }
}
