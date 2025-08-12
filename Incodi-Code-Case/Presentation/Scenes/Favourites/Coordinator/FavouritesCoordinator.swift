//
//  FavouritesCoordinator.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import UIKit

final class FavouritesCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = FavouritesViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
