//
//  PhotoSearchRepositoryImpl.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import Foundation

final class PhotoSearchRepositoryImpl {
    private let provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }
}

extension PhotoSearchRepositoryImpl: PhotoSearchRepository {
    func fetchPhotoSearch(query: String, page: Int, completion: @escaping (Result<[Photo], Error>) -> Void) {
        let endpoint = APIEndpoints.getSearchingPhotos(with: PhotoSearchRequestDTO(query: query, page: page))
        provider.request(with: endpoint) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
