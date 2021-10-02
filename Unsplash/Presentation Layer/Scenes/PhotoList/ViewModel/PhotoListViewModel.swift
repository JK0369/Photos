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

enum Section: Int, CaseIterable {
    case main
}

protocol PhotoListViewModelInout {
    var dataSource: UITableViewDiffableDataSource<Section, Photo>! { get set }

    func didSetupDiffableDataSource()
    func scrollViewDidScroll()
    func didUpdateCell(for photo: Photo)
    func prefetchRow(at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
}

protocol PhotoListViewModelOutput {
}

protocol PhotoListViewModel: PhotoListViewModelInout, PhotoListViewModelOutput {}

class PhotoListViewModelImpl: PhotoListViewModel {

    private let photoListUseCase: PhotoListUseCase
    private let actions: PhotoListViewModelActions

    init(photoListUseCase: PhotoListUseCase, actions: PhotoListViewModelActions) {
        self.photoListUseCase = photoListUseCase
        self.actions = actions
    }

    var currentPage: Int = 0
    var dataSource: UITableViewDiffableDataSource<Section, Photo>!
    lazy var provider: Provider = ProviderImpl()
    lazy var imageCache = ImageCache(provider: provider)

    // Input

    func didSetupDiffableDataSource() {
        loadData()
    }

    func scrollViewDidScroll() {
        loadData()
    }

    func didUpdateCell(for photo: Photo) {
        loadImages(for: photo)
    }

    func prefetchRow(at indexPath: IndexPath) {
        prefetchImage(at: indexPath)
    }

    func didSelectRow(at indexPath: IndexPath) {
        let photos = dataSource.snapshot().itemIdentifiers
        actions.showPhotoDetail(photos, indexPath)
    }

    // Private

    private func loadData() {
        currentPage += 1

        photoListUseCase.execute(requestVal: PhotoListRequestValue(page: currentPage)) { [weak self] result in
            guard let weakSelf = self else { return }

            switch result {
            case .success(let newPhotos):
                var snapshot = weakSelf.dataSource.snapshot()
                if snapshot.sectionIdentifiers.isEmpty {
                    snapshot.appendSections([.main])
                }
                snapshot.appendItems(newPhotos)
                DispatchQueue.global(qos: .background).async {
                    weakSelf.dataSource.apply(snapshot, animatingDifferences: false)
                }

            case .failure(let error):
                print(error)
            }
        }
    }

    private func loadImages(for photo: Photo) {

        imageCache.loadImage(for: photo) { [weak self] item, image in
            guard let `self` = self else { return }
            guard let photo = item as? Photo else { return }
            guard let image = image, image != photo.image else { return }

            photo.image = image
            var snapshot = `self`.dataSource.snapshot()
            guard snapshot.indexOfItem(photo) != nil else { return }

            snapshot.reloadItems([photo])
            DispatchQueue.global(qos: .background).async {
                `self`.dataSource.apply(snapshot, animatingDifferences: false)
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
