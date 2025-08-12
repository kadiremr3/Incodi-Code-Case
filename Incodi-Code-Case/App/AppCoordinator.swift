//
//  AppCoordinator.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 12.08.2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var window: UIWindow
    var splashCoordinator: SplashCoordinator?

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        showSplash()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    private func showSplash() {
        let splashCoordinator = SplashCoordinator(navigationController: navigationController)
        self.splashCoordinator = splashCoordinator

        splashCoordinator.onFinish = { [weak self] in
            self?.showMainTabBar()
        }
        splashCoordinator.start()
    }

    private func showMainTabBar() {
        let tabBarCoordinator = MainTabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator.start()
    }
}
