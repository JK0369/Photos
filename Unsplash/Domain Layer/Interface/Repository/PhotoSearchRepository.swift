//
//  PhotoSearchRepository.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import Foundation

protocol PhotoSearchRepository {
    func fetchPhotoSearch(query: String, page: Int, completion: @escaping (Result<[Photo], Error>) -> Void)
}
