//
//  ToastSwiftWrapper.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/29.
//

import UIKit
import Toast_Swift

extension UIView {
    func makeAlertToast(message: String, title: String?, duration: TimeInterval) {
        self.makeToast(message, duration: duration, position: .center, title: title, style: ToastStyle())

    }
}
