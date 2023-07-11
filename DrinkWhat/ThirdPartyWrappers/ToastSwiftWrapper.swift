//
//  ToastSwiftWrapper.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/29.
//

import UIKit
import Toast_Swift

extension UIViewController {
    func makeAlertToast(message: String, title: String?, duration: TimeInterval) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        window.makeToast(message, duration: duration, position: .center, title: title, style: ToastStyle())
    }
}
