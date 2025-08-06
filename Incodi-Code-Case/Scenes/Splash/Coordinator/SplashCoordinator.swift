//
//  SplashCoordinator.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import UIKit

final class SplashCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(
        parentCoordinator: Coordinator? = nil,
        navigationController: UINavigationController
    ) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = SplashViewModel(coordinator: self)
        let viewController = SplashViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
        navigationController.navigationBar.isHidden = true
    }
}
