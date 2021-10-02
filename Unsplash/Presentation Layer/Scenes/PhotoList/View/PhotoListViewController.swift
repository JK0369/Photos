//
//  PhotoListViewController.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import UIKit

class PhotoListViewController: UIViewController {

    static func create(with viewModel: PhotoListViewModel) -> PhotoListViewController {
        let viewController = PhotoListViewController()
        viewController.viewModel = viewModel

        return viewController
    }

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.prefetchDataSource = self
        view.delegate = self
        view.layoutMargins = .zero
        view.separatorColor = .black
        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.identifier)

        return view
    }()

    private var viewModel: PhotoListViewModel!

    var photos = [Photo]()
    var provider: Provider? = ProviderImpl()
    var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addSubviews()
        makeConstraints()
        setupTableViewDiffableDataSource()
    }

    private func setupViews() {
        view.backgroundColor = .black
        title = "Unsplash"
        tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "photo"), tag: 0)
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func makeConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }

    private func setupTableViewDiffableDataSource() {
        viewModel.dataSource = UITableViewDiffableDataSource<Section, Photo>(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, photo in
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath)

            self?.viewModel.loadImages(for: photo)
            (cell as? PhotoTableViewCell)?.model = photo

            return cell
        })

        viewModel.loadData()
    }
}

extension PhotoListViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        let heightRemainFromBottom = contentHeight - yOffset

        let frameHeight = scrollView.frame.size.height
        if heightRemainFromBottom < frameHeight {
            viewModel.loadData()
        }
    }
}

extension PhotoListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { viewModel.prefetchImage(at: $0) }
    }
}
