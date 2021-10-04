//
//  PhotoListTableViewCell.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import UIKit

class PhotoTableViewCell: BaseTableViewCell<Photo> {

    static let identifier = PhotoTableViewCell.className

    lazy var photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.backgroundColor = .black

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
        contentView.addSubview(photoImageView)
        photoImageView.addSubview(photoUserNameLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.preservesSuperviewLayoutMargins = false
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
            photoUserNameLabel.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -12),
        ])
    }

    override func bind(_ model: Photo) {
        super.bind(model)

        photoUserNameLabel.isHidden = model.image == .placeholderImage ? true : false
        photoImageView.image = model.image
        photoUserNameLabel.text = model.username
    }

}
