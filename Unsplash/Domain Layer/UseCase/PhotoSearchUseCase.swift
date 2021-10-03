//
//  PhotoSearchUseCase.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import Foundation

protocol PhotoSearchUseCase {
    func execute(requestVal: PhotoSearchRequestValue, completion: @escaping (Result<[Photo], Error>) -> Void)
}

final class PhotoSearchUseCaseImpl: PhotoSearchUseCase {
    private let photoSearchRepository: PhotoSearchRepository

    init(photoSearchRepository: PhotoSearchRepository) {
        self.photoSearchRepository = photoSearchRepository
    }

    func execute(requestVal: PhotoSearchRequestValue, completion: @escaping (Result<[Photo], Error>) -> Void) {
        photoSearchRepository.fetchPhotoSearch(query: requestVal.query, page: requestVal.page) { result in
            switch result {
            case .success(let photos):
                return completion(.success(photos))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
}

struct PhotoSearchRequestValue {
    let query: String
    let page: Int
}
