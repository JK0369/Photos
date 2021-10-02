//
//  PhotoDetailViewController.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    static func create(with viewModel: PhotoDetailViewModel) -> PhotoDetailViewController {
        let viewController = PhotoDetailViewController()
        viewController.viewModel = viewModel

        return viewController
    }

    private var viewModel: PhotoDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addSubviews()
        makeConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .black
        title = "Detail"
    }

    private func addSubviews() {
    }

    private func makeConstraints() {
    }
}
