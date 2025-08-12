//
//  FavouritesViewModel.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import Foundation

final class FavouritesViewModel: BaseViewModel, FavouritesViewModelProtocol {
    
    var favouritesCoordinator: FavouritesCoordinator!
    
    init(coordinator: FavouritesCoordinator!) {
        self.favouritesCoordinator = coordinator
    }
}
