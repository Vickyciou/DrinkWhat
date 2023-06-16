//
//  UIColor+Extension.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/16.
//

import UIKit

enum DWTColor: String {
    case darkBrown
    case midiumBrown
    case lightBrown
}

extension UIColor {
    static let darkBrown = DWTColor(.darkBrown)
    static let midiumBrown = DWTColor(.midiumBrown)
    static let lightBrown = DWTColor(.lightBrown)
    private static func DWTColor(_ color: DWTColor) -> UIColor? {
        return UIColor(named: color.rawValue)
    }
}
