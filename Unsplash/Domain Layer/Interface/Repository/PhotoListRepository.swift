//
//  PhotoListRepository.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/02.
//

import Foundation

protocol PhotoListRepository {
    func fetchPhotoList(page: Int, completion: @escaping (Result<[Photo], Error>) -> Void)
}
