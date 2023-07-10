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

    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
