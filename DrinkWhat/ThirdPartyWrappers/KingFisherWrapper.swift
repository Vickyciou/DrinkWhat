//
//  KingFisherWrapper.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/22.
//

import Foundation
import Kingfisher

extension UIImageView {

    func loadImage(_ urlString: String?, placeHolder: UIImage? = nil) {
        guard let urlString = urlString else {
            image = placeHolder
            return
        }
        let url = URL(string: urlString)
        self.kf.setImage(with: url, placeholder: placeHolder)
    }
}
