//
//  AppCoordinator.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init (navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        openSplash()
    }
    
    private func openSplash() {
        let splashCoordinator = SplashCoordinator(navigationController: navigationController)
        children.append(splashCoordinator)
        splashCoordinator.start()
    }
}
