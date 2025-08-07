//
//  HomeCoordinator.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import UIKit

final class HomeCoordinator: Coordinator {
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
        let viewModel = HomeViewModel(coordinator: self)
        let viewController = HomeViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func navigateToDetail() {
        let detailCoordinator = DetailCoordinator(
            parentCoordinator: self,
            navigationController: navigationController
        )
        detailCoordinator.start()
    }
}
