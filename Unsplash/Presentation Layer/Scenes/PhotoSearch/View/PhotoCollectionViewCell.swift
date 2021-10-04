//
//  PhotoCollectionViewCell.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import Foundation
import UIKit

class PhotoCollectionViewCell: BaseCollectinoViewCell<Photo> {

    static let identifier = PhotoCollectionViewCell.className

    private lazy var placeholderImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .bold))
        view.contentMode = .scaleToFill
        view.clipsToBounds = true

        return view
    }()

    private let photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true

        return view
    }()

    lazy var photoUserNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 14)

        return label
    }()

    override func configure() {
        super.configure()

        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(placeholderImageView)
        contentView.addSubview(photoImageView)
        photoImageView.addSubview(photoUserNameLabel)
    }

    private func makeConstraints() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])

        photoUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoUserNameLabel.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: 12),
            photoUserNameLabel.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -12)
        ])
    }

    override func bind(_ model: Photo) {
        super.bind(model)

        photoImageView.image = model.image
        photoUserNameLabel.text = model.username
    }
}
