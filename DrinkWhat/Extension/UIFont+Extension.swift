//
//  UIFont+Extension.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/15.
//

import UIKit

private enum DWTFontName: String {
    case regular = "PingFang TC"
}

extension UIFont {

    static func medium(size: CGFloat) -> UIFont? {
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }

    static func bold(size: CGFloat) -> UIFont? {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }

    static func regular(size: CGFloat) -> UIFont? {
        return UIFont(name: DWTFontName.regular.rawValue, size: size)
    }

    static func title1() -> UIFont? {
        return UIFont.systemFont(ofSize: 24, weight: .bold)
    }

    static func title2() -> UIFont? {
        return UIFont.systemFont(ofSize: 20, weight: .bold)
    }

    static func title3() -> UIFont? {
        return UIFont.systemFont(ofSize: 18, weight: .bold)
    }

    static func medium1() -> UIFont? {
        return UIFont.systemFont(ofSize: 20, weight: .medium)
    }

    static func medium2() -> UIFont? {
        return UIFont.systemFont(ofSize: 18, weight: .medium)
    }

    static func medium3() -> UIFont? {
        return UIFont.systemFont(ofSize: 16, weight: .medium)
    }

    static func medium4() -> UIFont? {
        return UIFont.systemFont(ofSize: 14, weight: .medium)
    }

    static func regular1() -> UIFont? {
        return UIFont.systemFont(ofSize: 20, weight: .regular)
    }

    static func regular2() -> UIFont? {
        return UIFont.systemFont(ofSize: 18, weight: .regular)
    }
    static func regular3() -> UIFont? {
        return UIFont.systemFont(ofSize: 16, weight: .regular)
    }

    static func regular4() -> UIFont? {
        return UIFont.systemFont(ofSize: 14, weight: .regular)
    }

    static func regular5() -> UIFont? {
        return UIFont.systemFont(ofSize: 12, weight: .regular)
    }
}
