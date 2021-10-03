//
//  PhotoSearchViewController.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import Foundation
import UIKit

class PhotoSearchViewController: UIViewController {
    static func create(with viewModel: PhotoSearchViewModel) -> PhotoSearchViewController {
        let viewController = PhotoSearchViewController()
        viewController.viewModel = viewModel

        return viewController
    }

    private var viewModel: PhotoSearchViewModel!

    private lazy var searchEmptyView: SearchEmptyView = {
        return SearchEmptyView()
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .leftThreeRightThree)
        view.delegate = self
        view.isPrefetchingEnabled = true
        view.prefetchDataSource = self
        view.alwaysBounceVertical = true
        view.backgroundColor = .black
        view.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addSubviews()
        makeConstraints()
        setupCollectionViewDiffableDataSource()
        setupSearchController()
        bindOutput()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = false
    }

    private func setupViews() {
        view.backgroundColor = .black
        navigationController?.navigationBar.topItem?.title = "Photo Search"
    }

    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(searchEmptyView)
    }

    private func makeConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor)
        ])

        searchEmptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchEmptyView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            searchEmptyView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            searchEmptyView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            searchEmptyView.topAnchor.constraint(equalTo: collectionView.topAnchor)
        ])
    }

    private func setupCollectionViewDiffableDataSource() {
        viewModel.dataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: collectionView,
                                                                                  cellProvider: { [weak self] collectionView, indexPath, photo in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath)
            (cell as? PhotoCollectionViewCell)?.model = photo
            self?.viewModel.didUpdateCell(for: photo)

            return cell
        })
    }

    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Photos, Journaling, growing ..."
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func bindOutput() {
        viewModel.scrollPageFromDetailPhoto.observe(on: self) { [weak self] in self?.updateScroll(to: $0) }
    }

    private func updateScroll(to page: IndexPath) {
        guard viewModel.dataSource.snapshot().numberOfItems != 0 else { return }

        DispatchQueue.main.async { [weak self] in
            self?.collectionView.scrollToItem(at: page, at: .bottom, animated: false)
        }
    }
}

// CollectionViewDelegate

extension PhotoSearchViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        let heightRemainFromBottom = contentHeight - yOffset

        let frameHeight = scrollView.frame.size.height
        if heightRemainFromBottom < frameHeight * 2 {
            viewModel.scrollViewDidScroll()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
    }
}

// Prefetching Delegate

extension PhotoSearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { viewModel.prefetchItem(at: $0) }
    }
}

// SearchBar Delegate

extension PhotoSearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchEmptyView.isHidden = searchBar.text?.isEmpty == false
        viewModel.didTapReuturnKey(with: searchBar.text ?? "")
    }
}
