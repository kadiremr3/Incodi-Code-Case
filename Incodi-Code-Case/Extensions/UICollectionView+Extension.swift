//
//  UICollectionView + Extension.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 12.08.2025.
//

import UIKit

extension UICollectionView {
    public func reloadDataOnMainThread() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.reloadData()
        }
    }
    
    public func reloadItemsOnMainThread(at indexPaths: [IndexPath]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.reloadItems(at: indexPaths)
        }
    }
}
