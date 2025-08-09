//
//  DetailCoordinator.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import UIKit

final class DetailCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    var user: GitHubUser!
    
    init(
        parentCoordinator: Coordinator? = nil,
        navigationController: UINavigationController
    ) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = DetailViewModel(coordinator: self)
        let viewController = DetailViewController(viewModel: viewModel)
        viewController.user = self.user
        navigationController.pushViewController(viewController, animated: true)
    }
}
