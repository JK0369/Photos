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

    private lazy var horizontalScrollView: HorizontalScrollView = {
        return HorizontalScrollView(horizontalWidth: UIScreen.main.bounds.width, horizontalHeight: view.frame.height)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()

        setupViews()
        addSubviews()
        makeConstraints()
        bindOutput()
    }

    private func setupViews() {
        title = "Detail"
        view.backgroundColor = .black
        tabBarController?.tabBar.isHidden = true
    }

    private func addSubviews() {
        view.addSubview(horizontalScrollView)
    }

    private func makeConstraints() {
        horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            horizontalScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            horizontalScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            horizontalScrollView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }

    private func bindOutput() {
        viewModel.currentImage.observe(on: self, observerBlock: { [weak self] in self?.setupImages(with: $0, selectedRow: $1) })
    }

    private func setupImages(with photos: [Photo], selectedRow: Int) {
        horizontalScrollView.model = .init(images: photos.map { $0.image }, selectedIndex: selectedRow)
    }
}
