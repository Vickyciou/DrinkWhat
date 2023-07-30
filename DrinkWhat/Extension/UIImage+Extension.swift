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

    convenience init?(imageName: String, targetSize: CGSize) {
        self.init(named: imageName)
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }

    }
}
