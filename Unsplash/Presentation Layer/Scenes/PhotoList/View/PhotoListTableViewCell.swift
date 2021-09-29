//
//  PhotoListTableViewCell.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import UIKit

class PhotoListTableViewCell: BaseTableViewCell<Photo> {

    static let identifier = PhotoListTableViewCell.className

    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label

        return label
    }()

    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()

    override func configure() {
        super.configure()

        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(photoImageView)
        photoImageView.addSubview(userNameLabel)
    }

    private func makeConstraints() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),

            userNameLabel.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: -26),
            userNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            userNameLabel.topAnchor.constraint(greaterThanOrEqualTo: photoImageView.topAnchor),
            userNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: photoImageView.trailingAnchor)
        ])
    }

    override func bind(_ model: Photo) {
        super.bind(model)

        userNameLabel.text = model.userName
        photoImageView.image = UIImage(data: model.imageData)

        // TODO: dynamic 사이즈
    }

}
