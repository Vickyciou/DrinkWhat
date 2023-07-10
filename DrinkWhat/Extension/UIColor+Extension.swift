//
//  UIColor+Extension.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/16.
//

import UIKit

enum DWTColor: String {
    case darkBrown = "DarkBrown"
    case logoBrown = "LogoBrown"
    case orangeBrown = "OrangeBrown"
    case middleBrown = "MiddleBrown"
    case lightBrown = "LightBrown"
    case skinColor = "SkinColor"
    case lightYellow = "LightYellow"
    case darkLogoBrown = "DarkLogoBrown"
    case lightGrayBrown = "LightGrayBrown"
    case lightGrayYellow = "LightGrayYellow"
    case middleDarkBrown = "MiddleDarkBrown"
}

extension UIColor {
    static let darkBrown = DWTColor(.darkBrown)
    static let logoBrown = DWTColor(.logoBrown)
    static let orangeBrown = DWTColor(.orangeBrown)
    static let middleBrown = DWTColor(.middleBrown)
    static let lightBrown = DWTColor(.lightBrown)
    static let skinColor = DWTColor(.skinColor)
    static let lightYellow = DWTColor(.lightYellow)
    static let darkLogoBrown = DWTColor(.darkLogoBrown)
    static let lightGrayBrown = DWTColor(.lightGrayBrown)
    static let lightGrayYellow = DWTColor(.lightGrayYellow)
    static let middleDarkBrown = DWTColor(.middleDarkBrown)
    private static func DWTColor(_ color: DWTColor) -> UIColor {
        guard let uiColor = UIColor(named: color.rawValue) else { return .black }
        return uiColor
    }
}

extension UIColor {
    func toImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            self.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return image
    }
}
