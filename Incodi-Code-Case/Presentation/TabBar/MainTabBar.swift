//
//  MainTabBar.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 12.08.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = ColorSet.incodiBlue
        setupTabs()
    }

    private func setupTabs() {
        let homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
        homeCoordinator.start()
        let homeNav = homeCoordinator.navigationController
        homeNav.tabBarItem = UITabBarItem(title: "Home".localized, image: UIImage(systemName: "house"), tag: 0)
        
        let favouritesCoordinator = FavouritesCoordinator(navigationController: UINavigationController())
        favouritesCoordinator.start()
        let favouritesNav = favouritesCoordinator.navigationController
        favouritesNav.tabBarItem = UITabBarItem(title: "Favourites".localized, image: UIImage(systemName: "star"), tag: 1)
        viewControllers = [homeNav, favouritesNav]
    }
}
