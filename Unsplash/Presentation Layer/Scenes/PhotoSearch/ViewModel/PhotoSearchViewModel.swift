//
//  PhotoSearchViewModel.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import Foundation
import UIKit

struct PhotoSearchViewModelActions {
    let showPhotoDetail: (_ photos: [Photo], _ selectedIndexPath: IndexPath) -> Void
}

protocol PhotoSearchViewModelInput {
    var dataSource: UICollectionViewDiffableDataSource<Section, Photo>! { get set }

    func scrollViewDidScroll()
    func didUpdateCell(for photo: Photo)
    func prefetchItem(at indexPath: IndexPath)
    func didSelectItem(at indexPath: IndexPath)
    func didTapReuturnKey(with query: String)
}

protocol PhotoSearchViewModelOutput {
    var emptySearchResult: Observable<Void> { get }
    var scrollPageFromDetailPhoto: Observable<IndexPath> { get }
}

protocol PhotoSearchViewModel: PhotoSearchViewModelInput, PhotoSearchViewModelOutput, PhotoDetailViewModelDelegate {}

final class PhotoSearchViewModelImpl: PhotoSearchViewModel {

    private let photoSearchUseCase: PhotoSearchUseCase
    private let actions: PhotoSearchViewModelActions
    private let imageCache: ImageCachable

    init(photoSearchUseCase: PhotoSearchUseCase, imageCache: ImageCachable, actions: PhotoSearchViewModelActions) {
        self.photoSearchUseCase = photoSearchUseCase
        self.imageCache = imageCache
        self.actions = actions
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    private var currentPage: Int = 0
    private var viewState = ViewState.idle
    private var lastQuery = ""

    // Output

    var emptySearchResult: Observable<Void> = .init(())
    var scrollPageFromDetailPhoto: Observable<IndexPath> = .init(IndexPath(row: 0, section: 0))

    // Input

    func scrollViewDidScroll() {
        loadData()
    }

    func didUpdateCell(for photo: Photo) {
        loadImages(for: photo)
    }

    func prefetchItem(at indexPath: IndexPath) {
        prefetchImage(at: indexPath)
    }

    func didSelectItem(at indexPath: IndexPath) {
        let photos = dataSource.snapshot().itemIdentifiers
        let finishFetchPhotos = photos.filter { $0.image != .placeholderImage }
        actions.showPhotoDetail(finishFetchPhotos, indexPath)
    }

    func didTapReuturnKey(with query: String) {
        loadData(with: query)
    }

    // Private

    private func loadData(with query: String = "") {
        guard viewState == .idle else { return }
        키워드로 다시 검색
        guard lastQuery != query else {
            // 다른 키워드로 다시 검색한 경우
            currentPage = 0
            var snapshot = dataSource.snapshot()
            snapshot.deleteAllItems()
            dataSource.apply(snapshot)
            lastQuery = ""
            return
        }
        lastQuery = query

        print(query)

        // TODO: API
        viewState = .isLoading
        photoSearchUseCase.execute(requestVal: PhotoSearchRequestValue(query: query, page: currentPage)) { [weak self] result in
            self?.viewState = .idle
            guard let weakSelf = self else { return }

            switch result {
            case .success(let photos):
                if photos.isEmpty {
                    self?.emptySearchResult.value = ()
                }
                var snapshot = weakSelf.dataSource.snapshot()
                if snapshot.sectionIdentifiers.isEmpty {
                    snapshot.appendSections([.main])
                }
                snapshot.appendItems(photos)
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

// PhotoDetailViewModelDelegate

extension PhotoSearchViewModelImpl {
    func didUpdateScroll(to page: IndexPath) {
        let snapshot = dataSource.snapshot()
        if page.row < snapshot.numberOfItems, page.section < snapshot.numberOfSections {
            scrollPageFromDetailPhoto.value = page
        }
    }
}
