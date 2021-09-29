//
//  Photo.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import Foundation

struct Photo: Equatable, Identifiable {
    typealias Identifer = String

    let id: Identifer
    let userName: String
    let imageData: Data
    let width: CGFloat
    let height: CGFloat
}
