//
//  PhotoDetailViewController.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import UIKit

struct HorizontalScrollModel {
    var images: [UIImage?]
    var initSelectedIndex: Int

    init(images: [UIImage?], initSelectedIndex: Int) {
        self.images = images
        self.initSelectedIndex = initSelectedIndex
    }
}

class PhotoDetailViewController: UIViewController {
    static func create(with viewModel: PhotoDetailViewModel) -> PhotoDetailViewController {
        let viewController = PhotoDetailViewController()
        viewController.viewModel = viewModel

        return viewController
    }

    private var currentPage = 0
    private var viewModel: PhotoDetailViewModel!

    private lazy var horizontalScrollView: HorizontalScrollView = {
        return HorizontalScrollView(horizontalWidth: view.bounds.width, horizontalHeight: view.bounds.height)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addSubviews()
        makeConstraints()
        bindOutput()
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        viewModel.didUpdateScroll(to: currentPage)
    }

    private func setupViews() {
        view.backgroundColor = .black
        tabBarController?.tabBar.isHidden = true
        horizontalScrollView.delegate = self
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
        viewModel.images.observe(on: self, observerBlock: { [weak self] in self?.setupImages(with: $0, selectedRow: $1) })
        viewModel.photoTitle.observe(on: self, observerBlock: { [weak self] in self?.updateNavigationTitle(to: $0) })
    }

    private func setupImages(with photos: [Photo], selectedRow: Int) {
        horizontalScrollView.model = .init(images: photos.map { $0.image }, initSelectedIndex: selectedRow)
    }

    private func updateNavigationTitle(to title: String) {
        navigationController?.navigationBar.topItem?.title = title
    }
}

extension PhotoDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
        self.currentPage = currentPage
    }
}
