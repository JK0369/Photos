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
        view.backgroundColor = .black
        view.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.identifier)

        return view
    }()

    private var viewModel: PhotoListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addSubviews()
        makeConstraints()
        setupTableViewDiffableDataSource()
        bindOutput()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }

    private func setupViews() {
        view.backgroundColor = .black
        navigationController?.navigationBar.topItem?.title = "Unsplash"
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

    private func bindOutput() {
        viewModel.scrollPageFromDetailPhoto.observe(on: self) { [weak self] in self?.updateScroll(to: $0) }
    }

    private func setupTableViewDiffableDataSource() {
        viewModel.dataSource = UITableViewDiffableDataSource<Section, Photo>(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, photo in
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath)
            (cell as? PhotoTableViewCell)?.model = photo
            self?.viewModel.didUpdateCell(for: photo)
            
            return cell
        })
        viewModel.didSetupDiffableDataSource()
    }

    private func updateScroll(to page: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.scrollToRow(at: page, at: .bottom, animated: false)
        }
    }
}

extension PhotoListViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        let heightRemainFromBottom = contentHeight - yOffset

        let frameHeight = scrollView.frame.size.height
        if heightRemainFromBottom < frameHeight {
            viewModel.scrollViewDidScroll()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}

extension PhotoListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { viewModel.prefetchRow(at: $0) }
    }
}
