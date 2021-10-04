//
//  PhotoListResponseDTO.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/30.
//

import Foundation
import UIKit

struct PhotoListResponseDTO: Decodable {
    let id: String
    let width: Int
    let height: Int
    let urls: Urls
    let user: User

    struct Urls: Decodable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }

    struct User: Decodable {
        let username: String
    }
}

extension PhotoListResponseDTO {
    func toDomain() -> Photo? {
        guard let imageUrl = URL(string: urls.small) else { return nil }

        return Photo(image: .placeholderImage,
                     imageUrl: imageUrl,
                     username: user.username)
    }
}
