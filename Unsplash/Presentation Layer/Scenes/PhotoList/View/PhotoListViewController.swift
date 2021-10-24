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
    private var dataSource: UITableViewDiffableDataSource<Section, Photo>!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTableViewDiffableDataSource()
        addSubviews()
        makeConstraints()
        bindOutput()
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }

    private func setupViews() {
        view.backgroundColor = .black
        navigationController?.navigationBar.topItem?.title = "Unsplash"
    }

    private func setupTableViewDiffableDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Photo>(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, photo in
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath)
            (cell as? PhotoTableViewCell)?.model = photo
            self?.viewModel.didUpdateCell(with: photo)

            return cell
        })
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
        viewModel.photoDatas.observe(on: self) { [weak self] in self?.setupPhotoDatas($0) }
        viewModel.photoImage.observe(on: self) { [weak self] in self?.setupPhoto($0) }
        viewModel.didUpdateScroll.observe(on: self) { [weak self] in self?.scrollPageFromDetailPhoto($0) }
    }

    private func scrollPageFromDetailPhoto(_ page: IndexPath) {
        let snapshot = dataSource.snapshot()
        if page.row < snapshot.numberOfItems, page.section < snapshot.numberOfSections, dataSource.snapshot().numberOfItems != 0 {
            updateScroll(to: page)
        }
    }

    private func updateScroll(to page: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.scrollToRow(at: page, at: .bottom, animated: false)
        }
    }

    private func setupPhotoDatas(_ photos: [Photo]) {
        var snapshot = dataSource.snapshot()
        if snapshot.sectionIdentifiers.isEmpty { snapshot.appendSections([.main]) }
        snapshot.appendItems(photos)
        DispatchQueue.main.async { [weak self] in
            self?.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }

    private func setupPhoto(_ photo: Photo?) {
        guard let photo = photo else { return }
        var snapshot = dataSource.snapshot()
        guard snapshot.indexOfItem(photo) != nil else { return }
        snapshot.reloadItems([photo])
        DispatchQueue.main.async { [weak self] in
            self?.dataSource.apply(snapshot, animatingDifferences: false)
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
        let photos = dataSource.snapshot().itemIdentifiers
        let finishFetchPhotos = photos.filter { $0.image != .placeholderImage }
        viewModel.didSelect(photos: finishFetchPhotos, indexPath: indexPath)
    }
}

extension PhotoListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let photo = dataSource.itemIdentifier(for: indexPath) else { continue }
            viewModel.didDetectPrefetch(photo: photo)
        }
    }
}
