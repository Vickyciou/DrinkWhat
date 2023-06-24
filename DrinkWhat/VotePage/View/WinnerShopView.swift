//
//  WinnerShopView.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/18.
//

import UIKit

class WinnerShopView: UIView {
    private lazy var shopImageView: UIImageView = makeImageView()
    private lazy var shopNameLabel: UILabel = makeShopNameLabel()
    private lazy var numberOfVotesLabel: UILabel = makeNumberOfVotesLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let contents = [shopImageView, shopNameLabel, numberOfVotesLabel]
        contents.forEach { self.addSubview($0) }

        NSLayoutConstraint.activate([
            shopImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            shopImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            shopImageView.heightAnchor.constraint(equalToConstant: 100),
            shopImageView.widthAnchor.constraint(equalTo: shopImageView.heightAnchor),
            shopNameLabel.topAnchor.constraint(equalTo: shopImageView.bottomAnchor, constant: 4),
            shopNameLabel.centerXAnchor.constraint(equalTo: shopImageView.centerXAnchor),
            numberOfVotesLabel.topAnchor.constraint(equalTo: shopNameLabel.bottomAnchor, constant: 6),
            numberOfVotesLabel.centerXAnchor.constraint(equalTo: shopImageView.centerXAnchor),
            numberOfVotesLabel.widthAnchor.constraint(equalToConstant: 50),
            numberOfVotesLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)])
    }

    func setupWinnerView(shopImageURL: String?, shopName: String, numberOfVotes: Int?) {
        shopImageView.loadImage(shopImageURL, placeHolder: UIImage(systemName: "bag")?.setColor(color: .darkBrown))
        shopNameLabel.text = shopName
        numberOfVotesLabel.text = String("\(numberOfVotes ?? 0)票")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension WinnerShopView {
    private func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        return imageView
    }
    private func makeShopNameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .medium(size: 24)
        label.textColor = UIColor.darkBrown
        return label
    }
    private func makeNumberOfVotesLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .medium(size: 18)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.darkBrown
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }
}
