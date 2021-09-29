//
//  PhotoListUseCase.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import Foundation

protocol PhotoListUseCase {
    // TODO 구현
    func execute(request: PhotoListUseCaseRequest)
}

struct PhotoListUseCaseRequest {

    enum OrderByType: String {
        case latest
        case oldest
        case popular
    }

    var page: Int = 1
    var perPage: Int = 10
    var orderBy: OrderByType = .latest
}
