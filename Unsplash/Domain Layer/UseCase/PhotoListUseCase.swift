//
//  PhotoListUseCase.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/02.
//

import Foundation

protocol PhotoListUseCase {
    func execute(requestVal: PhotoListRequestValue, completion: @escaping (Result<[Photo], Error>) -> Void)
}

final class PhotoListUseCaseImpl: PhotoListUseCase {

    private let photoListRepository: PhotoListRepository

    init(photoListRepository: PhotoListRepository) {
        self.photoListRepository = photoListRepository
    }

    func execute(requestVal: PhotoListRequestValue, completion: @escaping (Result<[Photo], Error>) -> Void) {
        photoListRepository.fetchPhotoList(page: requestVal.page) { result in
            switch result {
            case .success(let photos):
                return completion(.success(photos))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
}

struct PhotoListRequestValue {
    let page: Int
}
