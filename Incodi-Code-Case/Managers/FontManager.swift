//
//  FontManager.swift
//  Incodi-Code-Case
//
//  Created by Kadir Emre Yıldırım on 6.08.2025.
//

import UIKit

struct FontManager {
    enum FontType: String {
        case todo = "" // TODO: add font
    }

    static func font(_ type: FontType, size: CGFloat) -> UIFont {
        return UIFont(name: type.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
