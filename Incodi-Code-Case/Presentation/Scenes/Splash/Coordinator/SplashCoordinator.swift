//
//  SplashCoordinator.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import UIKit

final class SplashCoordinator: Coordinator {
    var navigationController: UINavigationController
    var onFinish: (() -> Void)?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let splashViewController = SplashViewController(
            coordinator: self,
            favouritesManager: FavouritesManager.shared
        )
        splashViewController.onFinish = { [weak self] in
            self?.onFinish?()
        }
        navigationController.setViewControllers([splashViewController], animated: false)
    }
}
