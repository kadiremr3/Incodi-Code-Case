//
//  String+Extension.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 12.08.2025.
//
import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
