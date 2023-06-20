//
//  UIImage+Extension.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/20.
//

import UIKit

extension UIImage {
    func setColor(color: UIColor) -> UIImage {
        return self.withTintColor(color)
            .withRenderingMode(.alwaysOriginal)
    }
}
