//
//  UIFont+Extension.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/15.
//

import UIKit

private enum DWTFontName: String {
    case regular = "PingFangTC-Regular"
}

extension UIFont {

    static func medium(size: CGFloat) -> UIFont? {
        var descriptor = UIFontDescriptor(name: DWTFontName.regular.rawValue, size: size)
        descriptor = descriptor.addingAttributes(
            [UIFontDescriptor.AttributeName.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.medium]]
        )
        return UIFont(descriptor: descriptor, size: size)
    }

    static func regular(size: CGFloat) -> UIFont? {
        return DWTFont(.regular, size: size)
    }

    private static func DWTFont(_ font: DWTFontName, size: CGFloat) -> UIFont? {
        return UIFont(name: font.rawValue, size: size)
    }
}
