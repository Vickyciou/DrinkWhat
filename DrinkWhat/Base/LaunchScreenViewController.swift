//
//  LaunchScreenViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/7/12.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.storyboard?.instantiateInitialViewController()
        view.backgroundColor = .darkLogoBrown
        let imageView = UIImageView()
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "DrinkWhat-icon無字版")?
            .resizeImage(UIImage(named: "DrinkWhat-icon無字版")!,
                         targetSize: CGSize(width: 100, height: 100))
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }

}
