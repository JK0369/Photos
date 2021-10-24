//
//  PhotoSearchViewModel.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import Foundation

struct PhotoSearchViewModelActions {
    let showPhotoDetail: (_ photos: [Photo], _ selectedIndexPath: IndexPath) -> Void
}

protocol PhotoSearchViewModelInput {
    func scrollViewDidScroll()
    func didUpdateCell(with photo: Photo)
    func didDetectPrefetch(photo: Photo)
    func didSelect(photos: [Photo], indexPath: IndexPath)
    func didTapReuturnKey(with query: String)
}

protocol PhotoSearchViewModelOutput {
    var photoDatas: Observable<[Photo]> { get }
    var photoImage: Observable<Photo?> { get }
    var emptySearchResult: Observable<Void> { get }
    var scrollPageFromDetailPhoto: Observable<IndexPath> { get }
    var clearPhotos: Observable<Void> { get }
    var didUpdateScroll: Observable<IndexPath> { get }
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

    var currentPage: Int = 0
    private var viewState = ViewState.idle
    private var lastQuery = ""

    // Output

    var photoDatas: Observable<[Photo]> = .init([])
    var photoImage: Observable<Photo?> = .init(nil)
    var emptySearchResult: Observable<Void> = .init(())
    var scrollPageFromDetailPhoto: Observable<IndexPath> = .init(IndexPath(row: 0, section: 0))
    var clearPhotos: Observable<Void> = .init(())
    var didUpdateScroll: Observable<IndexPath> = .init(IndexPath(row: 0, section: 0))

    // Input

    func scrollViewDidScroll() {
        guard !lastQuery.isEmpty else { return }
        loadData(with: lastQuery)
    }

    func didUpdateCell(with photo: Photo) {
        loadImages(for: photo)
    }

    func didDetectPrefetch(photo: Photo) {
        prefetchImage(photo: photo)
    }

    func didSelect(photos: [Photo], indexPath: IndexPath) {
        actions.showPhotoDetail(photos, indexPath)
    }

    func didTapReuturnKey(with query: String) {
        loadData(with: query)
    }

    // Private

    private func loadData(with query: String) {
        guard viewState == .idle else { return }

        if !lastQuery.isEmpty, lastQuery != query {
            // 다른 키워드로 재검색

            currentPage = 0
            clearPhotos.value = ()
            lastQuery = ""
        }

        currentPage += 1
        lastQuery = query

        viewState = .isLoading
        photoSearchUseCase.execute(requestVal: PhotoSearchRequestValue(query: query, page: currentPage)) { [weak self] result in
            self?.viewState = .idle
            switch result {
            case .success(let photos):
                if photos.isEmpty {
                    self?.emptySearchResult.value = ()
                }
                self?.photoDatas.value = photos
            case .failure(let error):
                print(error)
            }
        }
    }

    private func loadImages(for photo: Photo) {
        imageCache.loadImage(for: photo) { [weak self] item, image in
            guard let photo = item as? Photo, let image = image, image != photo.image else { return }
            photo.image = image
            self?.photoImage.value = photo
        }
    }

    private func prefetchImage(photo: Photo) {
        imageCache.prefetchImage(for: photo)
    }
}

// PhotoDetailViewModelDelegate

extension PhotoSearchViewModelImpl {
    func didUpdateScroll(to page: IndexPath) {
        didUpdateScroll.value = page
    }
}
