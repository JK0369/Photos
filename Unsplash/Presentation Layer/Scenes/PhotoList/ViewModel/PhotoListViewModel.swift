//
//  PhotoListViewModel.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import Foundation
import UIKit

struct PhotoListViewModelActions {
    let showPhotoDetail: (_ photos: [Photo], _ selectedIndexPath: IndexPath) -> Void
}

protocol PhotoListViewModelInout {
    func viewDidLoad(with tableView: UITableView)
    func scrollViewDidScroll()
    func prefetchRow(at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
}

protocol PhotoListViewModelOutput {
    var scrollPageFromDetailPhoto: Observable<IndexPath> { get }
}

protocol PhotoListViewModel: PhotoListViewModelInout, PhotoListViewModelOutput, PhotoDetailViewModelDelegate {}

final class PhotoListViewModelImpl: PhotoListViewModel {

    private let photoListUseCase: PhotoListUseCase
    private let actions: PhotoListViewModelActions
    private let imageCache: ImageCachable

    init(photoListUseCase: PhotoListUseCase, imageCache: ImageCachable, actions: PhotoListViewModelActions) {
        self.photoListUseCase = photoListUseCase
        self.imageCache = imageCache
        self.actions = actions
    }

    var currentPage: Int = 0
    private var dataSource: UITableViewDiffableDataSource<Section, Photo>!
    private var viewState = ViewState.idle

    // Output

    var scrollPageFromDetailPhoto: Observable<IndexPath> = .init(IndexPath(row: 0, section: 0))

    // Input

    func viewDidLoad(with tableView: UITableView) {
        setupTableViewDiffableDataSource(with: tableView)
        loadData()
    }

    func scrollViewDidScroll() {
        loadData()
    }

    func prefetchRow(at indexPath: IndexPath) {
        prefetchImage(at: indexPath)
    }

    func didSelectRow(at indexPath: IndexPath) {
        let photos = dataSource.snapshot().itemIdentifiers
        let finishFetchPhotos = photos.filter { $0.image != .placeholderImage }
        actions.showPhotoDetail(finishFetchPhotos, indexPath)
    }

    // Private

    private func setupTableViewDiffableDataSource(with tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource<Section, Photo>(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, photo in
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath)
            (cell as? PhotoTableViewCell)?.model = photo
            self?.didUpdateCell(for: photo)

            return cell
        })
    }

    private func didUpdateCell(for photo: Photo) {
        loadImages(for: photo)
    } 

    private func loadData() {
        guard viewState == .idle else { return }
        currentPage += 1

        viewState = .isLoading
        photoListUseCase.execute(requestVal: PhotoListRequestValue(page: currentPage)) { [weak self] result in
            self?.viewState = .idle
            guard let weakSelf = self else { return }

            switch result {
            case .success(let newPhotos):
                var snapshot = weakSelf.dataSource.snapshot()
                if snapshot.sectionIdentifiers.isEmpty {
                    snapshot.appendSections([.main])
                }
                snapshot.appendItems(newPhotos)
                DispatchQueue.main.async {
                    weakSelf.dataSource.apply(snapshot, animatingDifferences: false)
                }

            case .failure(let error):
                print(error)
            }
        }
    }

    private func loadImages(for photo: Photo) {

        imageCache.loadImage(for: photo) { [weak self] item, image in
            guard let weakSelf = self else { return }
            guard let photo = item as? Photo else { return }
            guard let image = image, image != photo.image else { return }

            photo.image = image
            var snapshot = weakSelf.dataSource.snapshot()
            guard snapshot.indexOfItem(photo) != nil else { return }

            snapshot.reloadItems([photo])
            DispatchQueue.main.async {
                weakSelf.dataSource.apply(snapshot, animatingDifferences: false)
            }
        }
    }

    private func prefetchImage(at indexPath: IndexPath) {
        guard let photo = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        imageCache.prefetchImage(for: photo)
    }
}

// PhotoDetailViewModelDelegate

extension PhotoListViewModelImpl {
    func didUpdateScroll(to page: IndexPath) {
        let snapshot = dataSource.snapshot()
        if page.row < snapshot.numberOfItems, page.section < snapshot.numberOfSections, dataSource.snapshot().numberOfItems != 0 {
            scrollPageFromDetailPhoto.value = page
        }
    }
}
