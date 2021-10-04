//
//  PhotoListRepositoryImpl.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/02.
//

import Foundation

final class PhotoListRepositoryImpl {
    private let provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }
}

extension PhotoListRepositoryImpl: PhotoListRepository {
    func fetchPhotoList(page: Int, completion: @escaping (Result<[Photo], Error>) -> Void) {
        let endpoint = APIEndpoints.getPhotosInfo(with: PhotoListRequestDTO(page: page))
        provider.request(with: endpoint) { result in
            switch result {
            case .success(let responseDTOs):
                var newPhotoList = [Photo]()
                responseDTOs.forEach { photoListDTO in
                    if let photo = photoListDTO.toDomain() {
                        newPhotoList.append(photo)
                    }
                }
                completion(.success(newPhotoList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
