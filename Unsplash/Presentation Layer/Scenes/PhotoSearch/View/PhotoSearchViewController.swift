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
    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>!

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
        setupCollectionViewDiffableDataSource()
        addSubviews()
        makeConstraints()
        setupSearchController()
        bindOutput()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = false
    }

    private func setupViews() {
        tabBarController?.delegate = self
        view.backgroundColor = .black
        navigationController?.navigationBar.topItem?.title = "Photo Search"
        DispatchQueue.main.async { [weak self] in
            self?.navigationItem.searchController?.searchBar.searchTextField.textColor = .white
        }
    }

    private func setupCollectionViewDiffableDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: collectionView,
                                                                                  cellProvider: { [weak self] collectionView, indexPath, photo in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath)
            (cell as? PhotoCollectionViewCell)?.model = photo
            self?.viewModel.didUpdateCell(with: photo)
            return cell
        })
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
        viewModel.photoDatas.observe(on: self, observerBlock: { [weak self] in self?.setupPhotoDatas($0) })
        viewModel.photoImage.observe(on: self, observerBlock: { [weak self] in self?.setupPhoto($0) })
        viewModel.emptySearchResult.observe(on: self) { [weak self] in self?.updateSearchEmptyView() }
        viewModel.scrollPageFromDetailPhoto.observe(on: self) { [weak self] in self?.updateScroll(to: $0) }
        viewModel.clearPhotos.observe(on: self) { [weak self] in self?.clearPhotos() }
        viewModel.didUpdateScroll.observe(on: self, observerBlock: { [weak self] in self?.scrollPageFromDetailPhoto($0)})
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

    private func updateSearchEmptyView() {
        searchEmptyView.isHidden = false
        searchEmptyView.model = .emptyResult
    }

    private func updateScroll(to page: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.scrollToItem(at: page, at: .bottom, animated: false)
        }
    }

    private func clearPhotos() {
        let snapshot =  NSDiffableDataSourceSnapshot<Section, Photo>.init()
        dataSource.apply(snapshot)
    }

    private func scrollPageFromDetailPhoto(_ page: IndexPath) {
        let snapshot = dataSource.snapshot()
        if page.row < snapshot.numberOfItems, page.section < snapshot.numberOfSections, dataSource.snapshot().numberOfItems != 0 {
            updateScroll(to: page)
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
        let photos = dataSource.snapshot().itemIdentifiers
        let finishFetchPhotos = photos.filter { $0.image != .placeholderImage }
        viewModel.didSelect(photos: finishFetchPhotos, indexPath: indexPath)
    }
}

// Prefetching Delegate

extension PhotoSearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let photo = dataSource.itemIdentifier(for: indexPath) else { continue }
            viewModel.didDetectPrefetch(photo: photo)
        }
    }
}

// SearchBar Delegate

extension PhotoSearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchEmptyView.model = .requiredQuery
        searchEmptyView.isHidden = searchBar.text?.isEmpty == false

        viewModel.didTapReuturnKey(with: searchBar.text ?? "")
    }

}

// TabBar Delegate

extension PhotoSearchViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let navigationController = viewController as? UINavigationController
        if navigationController?.viewControllers.first is Self == true {
            DispatchQueue.main.async { [weak self] in
                self?.navigationItem.searchController?.searchBar.searchTextField.becomeFirstResponder()
            }
        }
    }
}
