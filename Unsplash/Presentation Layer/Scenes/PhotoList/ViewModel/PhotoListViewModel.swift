//
//  PhotoListViewModel.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import Foundation

struct PhotoListViewModelActions {
    let showPhotoDetail: (_ photos: [Photo], _ selectedIndexPath: IndexPath) -> Void
}

protocol PhotoListViewModelInout {
    func viewDidLoad()
    func didUpdateCell(with photo: Photo)
    func didSelect(photos: [Photo], indexPath: IndexPath)
    func scrollViewDidScroll()
    func didDetectPrefetch(photo: Photo)
}

protocol PhotoListViewModelOutput {
    var photoDatas: Observable<[Photo]> { get }
    var photoImage: Observable<Photo?> { get }
    var didUpdateScroll: Observable<IndexPath> { get }
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
    private var viewState = ViewState.idle

    // Output

    var photoDatas: Observable<[Photo]> = .init([])
    var photoImage: Observable<Photo?> = .init(nil)
    var didUpdateScroll: Observable<IndexPath> = .init(IndexPath(row: 0, section: 0))

    // Input

    func viewDidLoad() {
        loadData()
    }

    func didUpdateCell(with photo: Photo) {
        loadImages(for: photo)
    }

    func scrollViewDidScroll() {
        loadData()
    }

    func didSelect(photos: [Photo], indexPath: IndexPath) {
        actions.showPhotoDetail(photos, indexPath)
    }

    func didDetectPrefetch(photo: Photo) {
        prefetchImage(photo: photo)
    }

    // Private

    private func didUpdateCell(for photo: Photo) {
        loadImages(for: photo)
    } 

    private func loadData() {
        guard viewState == .idle else { return }
        currentPage += 1

        viewState = .isLoading
        photoListUseCase.execute(requestVal: PhotoListRequestValue(page: currentPage)) { [weak self] result in
            self?.viewState = .idle

            switch result {
            case .success(let newPhotos):
                self?.photoDatas.value = newPhotos
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

extension PhotoListViewModelImpl {
    func didUpdateScroll(to page: IndexPath) {
        didUpdateScroll.value = page
    }
}
